# Builder
FROM alpine:3.13 AS builder
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Packages
RUN apk add git

# adsb2influx
WORKDIR /app

RUN git clone --depth 1 https://github.com/Dennis14e/adsb2influx.git . && \
    chmod +x adsb2influx.py


# Base
FROM alpine:3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Packages
RUN apk add ca-certificates python3 py3-requests

# adsb2influx
WORKDIR /app

COPY --from=builder /app/adsb2influx.py /app/adsb2influx.py

RUN chmod 750 /app/adsb2influx.py

# ENV
ENV DUMP1090_HOST=dump1090
ENV DUMP1090_PORT=30003
ENV INFLUX_URL=
ENV INFLUX_USER=
ENV INFLUX_PASS=
ENV INFLUX_DB=adsb
ENV SEND_INTERVAL=60

# Entrypoint
ENTRYPOINT [ "python3" ]

# CMD
CMD [ "/app/adsb2influx.py", "-ds", $DUMP1090_HOST, "-dp", $DUMP1090_PORT, "-iu", $INFLUX_URL, "-in", $INFLUX_USER, "-ip", $INFLUX_PASS, "-db", $INFLUX_DB, "-si", $SEND_INTERVAL ]
