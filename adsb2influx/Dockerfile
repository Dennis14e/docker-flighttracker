# Builder
FROM python:3.9-alpine3.13 AS builder

# Workdir
WORKDIR /app

# Packages
COPY ./requirements.txt /app/requirements.txt

RUN mkdir -p /app/python-packages && \
    pip install --no-cache-dir --prefix=/app/python-packages -r /app/requirements.txt


# Release
FROM python:3.9-alpine3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/python-packages /usr/local
COPY ./adsb2influx.py /app/adsb2influx.py

# Permissions
RUN chmod +x /app/adsb2influx.py

# Environment
ENV DUMP1090_HOST="dump1090" \
    DUMP1090_PORT="30003" \
    INFLUX_URL="" \
    INFLUX_TOKEN="" \
    INFLUX_ORG="" \
    INFLUX_BUCKET="adsb" \
    INFLUX_MEASUREMENT="messages" \
    SEND_INTERVAL="60"

# Command
CMD [ "sh", "-c", "python3 adsb2influx.py -dh $DUMP1090_HOST -dp $DUMP1090_PORT -iu $INFLUX_URL -it $INFLUX_TOKEN -io $INFLUX_ORG -ib $INFLUX_BUCKET -im $INFLUX_MEASUREMENT -si $SEND_INTERVAL" ]
