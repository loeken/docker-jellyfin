FROM alpine:3.21@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c as builder

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

FROM alpine:3.21@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

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
