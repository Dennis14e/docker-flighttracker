# Builder
FROM alpine:3.13 AS builder

# Packages
RUN apk add --no-cache build-base git librtlsdr-dev ncurses-dev zlib-dev argp-standalone

# readsb
WORKDIR /app

RUN git clone -b sid https://github.com/wiedehopf/readsb.git . && \
    git -c advice.detachedHead=false checkout 2d1a8d3 && \
    mkdir patches

COPY patches/*.patch patches/

RUN git apply patches/*.patch && \
    make readsb RTLSDR=yes


# Base
FROM alpine:3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash rtl-sdr ncurses zlib

# readsb
WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /app/readsb /app/readsb

RUN chmod 777 /entrypoint.sh /app/readsb && \
    mkdir /boot

# ENV
ENV ADSB_UUID=""
ENV PROGRAM_OPTIONS="--no-interactive --quiet"
ENV RECEIVER_OPTIONS="--device 0 --device-type rtlsdr --gain -10 --ppm 0"
ENV DECODER_OPTIONS="--max-range 360 --write-json-every 1 --modeac-auto"
ENV NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1200 --net-ro-interval 0.1 --net-ro-port 30002 --net-sbs-port 30003 --net-bo-port 30005 --net-api-port 8042"
ENV JSON_OPTIONS="--json-location-accuracy 2"

# Expose
EXPOSE 8042 30002 30003 30005

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# CMD
CMD [ "sh", "-c", "/app/readsb $PROGRAM_OPTIONS $RECEIVER_OPTIONS $DECODER_OPTIONS $NET_OPTIONS $JSON_OPTIONS" ]
