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

RUN apk add \
     jellyfin \
     jellyfin-web \
     jellyfin-mpv-shim
COPY --from=builder /output /

ENTRYPOINT ["/usr/bin/jellyfin", \
     "--datadir", "/config", \
     "--cachedir", "/cache", \
     "--ffmpeg", "/usr/bin/ffmpeg"]
