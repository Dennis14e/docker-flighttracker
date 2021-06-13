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
