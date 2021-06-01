# Builder
FROM python:3.9-alpine3.13 AS builder
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Workdir
WORKDIR /app

# Packages
COPY ./requirements.txt /app/requirements.txt

RUN mkdir -p /app/python-packages && \
    pip install --no-cache-dir --prefix=/app/python-packages -r /app/requirements.txt


# Base
FROM python:3.9-alpine3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Workdir
WORKDIR /app

# Packages
COPY --from=builder /app/python-packages /usr/local

# adsb2influx
COPY ./adsb2influx.py /app/adsb2influx.py

RUN chmod +x /app/adsb2influx.py

# ENV
ENV DUMP1090_HOST=dump1090
ENV DUMP1090_PORT=30003
ENV INFLUX_URL=
ENV INFLUX_TOKEN=
ENV INFLUX_ORG=
ENV INFLUX_BUCKET=adsb
ENV INFLUX_MEASUREMENT=messages
ENV SEND_INTERVAL=60

# CMD
CMD [ "sh", "-c", "python3 adsb2influx.py -dh $DUMP1090_HOST -dp $DUMP1090_PORT -iu $INFLUX_URL -it $INFLUX_TOKEN -io $INFLUX_ORG -ib $INFLUX_BUCKET -im $INFLUX_MEASUREMENT -si $SEND_INTERVAL" ]
