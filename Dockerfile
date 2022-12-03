FROM alpine:3.17 as builder

 RUN apk add \
    #  jellyfin \
    #  jellyfin-web \
    #  jellyfin-mpv-shim \
    gcc \
    g++ \
    make \
    yasm yasm-dev \
    nasm 

#CMD [ "which","ffmpeg" ]

RUN mkdir /ffmpeg
COPY . /ffmpeg

WORKDIR /ffmpeg
RUN ./configure
RUN make -j 8
RUN make install DESTDIR=/output

RUN ls /output
FROM alpine:3.17

RUN apk add \
     jellyfin \
     jellyfin-web 
#     jellyfin-mpv-shim
COPY --from=builder /output /

ENTRYPOINT ["/usr/bin/jellyfin", \
     "--datadir", "/config", \
     "--cachedir", "/cache", \
     "--ffmpeg", "/usr/bin/ffmpeg"]