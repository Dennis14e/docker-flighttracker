# Builder
FROM alpine:3.14 AS builder

# Workdir
WORKDIR /app

# Copy downloader
COPY dl-pfclient.sh /tmp/dl-pfclient.sh

# Download pfclient
RUN chmod +x /tmp/dl-pfclient.sh && \
    /tmp/dl-pfclient.sh


# Release
FROM alpine:3.14 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN [ `uname -m` = "aarch64" ] && echo "armhf" > /etc/apk/arch; \
    apk add --no-cache bash sed libc6-compat gcompat

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/pfclient /app/
COPY entrypoint.sh /entrypoint.sh
COPY pfclient-config.json /app/

RUN chmod +x /entrypoint.sh /app/pfclient
RUN chmod 644 /app/pfclient-config.json

# ENV
ENV SHARING_KEY="" \
    DUMP1090_HOST="readsb" \
    DUMP1090_PORT="30002" \
    LAT="" \
    LON=""

# Expose
EXPOSE 30053

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command
CMD [ "/app/pfclient" ]
