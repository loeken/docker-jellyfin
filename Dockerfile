FROM alpine:3.22@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 as builder

# Required for compiling ffmpeg with VAAPI/QSV
RUN apk add --no-cache \
    gcc \
    g++ \
    make \
    yasm \
    nasm \
    perl \
    libva-dev \
    libdrm-dev \
    libvdpau-dev \
    mesa-dev \
    wayland-dev \
    x264-dev \
    x265-dev \
    xvidcore-dev \
    v4l-utils-dev \
    alsa-lib-dev \
    intel-media-sdk-dev \
    onevpl-dev

# Optional: You could also add `--enable-libvpx` or `--enable-libfdk_aac` if needed

COPY . /ffmpeg
WORKDIR /ffmpeg

# Configure ffmpeg with hardware acceleration support
RUN ./configure \
  --prefix=/usr/local \
  --enable-gpl \
  --enable-nonfree \
  --enable-vaapi \
  --enable-libdrm \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxvid \
  --enable-libvpl \
  --enable-libv4l2 \
  --enable-hwaccel=h264_vaapi \
  --enable-hwaccel=hevc_vaapi

RUN make -j$(nproc)
RUN make install DESTDIR=/output


FROM alpine:3.22@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

# Install runtime dependencies for Jellyfin and VAAPI/QSV
RUN apk add --no-cache \
    jellyfin \
    jellyfin-web \
    jellyfin-mpv-shim \
    libva \
    libva-utils \
    mesa-dri-gallium \
    mesa-vulkan-intel \
    intel-media-driver \
    intel-media-sdk \
    libva-intel-driver \
    onevpl \
    libdrm \
    tzdata \
    bash \
    alsa-lib \
    v4l-utils \
    ffmpeg  # This line is safe to remove if you only want your custom-built ffmpeg

# Copy in your compiled ffmpeg (with hwaccel support)
COPY --from=builder /output/ /

# Link the web UI correctly
RUN ln -s /usr/share/webapps/jellyfin-web /usr/lib/jellyfin/jellyfin-web

# Expose necessary devices (optional: handled via Kubernetes or `--device`)
VOLUME /config /cache
EXPOSE 8096 8920

ENTRYPOINT ["/usr/bin/jellyfin", \
  "--datadir", "/config", \
  "--cachedir", "/cache", \
  "--ffmpeg", "/usr/local/bin/ffmpeg"]
