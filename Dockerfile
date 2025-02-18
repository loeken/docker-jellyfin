FROM alpine:3.20 as builder

RUN apk add \
    gcc \
    g++ \
    make \
    yasm yasm-dev \
    nasm

RUN mkdir /ffmpeg
COPY . /ffmpeg

WORKDIR /ffmpeg
RUN ./configure
RUN make
RUN make install DESTDIR=/output

FROM alpine:3.19

RUN apk add --no-cache \
     jellyfin \
     jellyfin-web \
     jellyfin-mpv-shim \
     mesa-dri-gallium \
     intel-media-driver \
     intel-media-sdk \
     libva-intel-driver \
     onevpl
COPY --from=builder /output /

ENTRYPOINT ["/usr/bin/jellyfin", \
     "--datadir", "/config", \
     "--cachedir", "/cache", \
     "--ffmpeg", "/usr/bin/ffmpeg"]
