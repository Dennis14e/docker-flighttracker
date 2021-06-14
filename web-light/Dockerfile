# Builder
FROM alpine:3.13 AS builder

WORKDIR /app

# Packages
RUN apk add --no-cache \
    findutils

# Leaflet
ARG LEAFLET_URL="https://github.com/Leaflet/Leaflet/archive/refs/tags/v1.7.1.tar.gz"
RUN mkdir -p leaflet assets/leaflet && \
    wget -O - "$LEAFLET_URL" | tar -xvzf - --strip 1 -C /app/leaflet

RUN cp -r \
    leaflet/dist/leaflet.css \
    leaflet/dist/leaflet.js \
    leaflet/dist/leaflet.js.map \
    leaflet/dist/images/ \
    assets/leaflet/

RUN find /app -type d -exec chmod 755 {} \; && \
    find /app -type f -exec chmod 644 {} \;


# Base
FROM nginx:1.21-alpine AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# web-light
WORKDIR /app

COPY entrypoint.sh /docker-entrypoint.d/50-entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /app/index.html
COPY --from=builder /app/assets/ /app/assets/

RUN chmod 777 /docker-entrypoint.d/50-entrypoint.sh
RUN chmod 644 /app/index.html

# ENV
ENV READSB_HOST="readsb"
ENV READSB_PORT="8042"
ENV PAGE_TITLE="Flighttracker Web Light"
ENV REFRESH_RATE="250"
ENV CENTER_LAT="45.0"
ENV CENTER_LNG="9.0"
ENV CENTER_RADIUS="500"
