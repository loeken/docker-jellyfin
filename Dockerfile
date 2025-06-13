FROM alpine:3.22@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 as builder

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

FROM alpine:3.22@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

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
RUN ln -s /usr/share/webapps/jellyfin-web /usr/lib/jellyfin/jellyfin-web

ENTRYPOINT ["/usr/bin/jellyfin", \
     "--datadir", "/config", \
     "--cachedir", "/cache", \
     "--ffmpeg", "/usr/local/bin/ffmpeg"]
