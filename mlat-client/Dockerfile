# Builder
FROM python:3.9-alpine3.14 AS builder

# Packages
RUN apk add --no-cache build-base git

# Workdir
WORKDIR /app

# Get mlat-client
RUN mkdir mlat-client && \
    cd mlat-client && \
    git clone -b master https://github.com/wiedehopf/mlat-client.git . && \
    git -c advice.detachedHead=false checkout 6faf42052ce461ded1c38cdb4b2127e32b45788b && \
    mkdir -p /app/python-packages && \
    python3 setup.py install --prefix=/app/python-packages

# Cleanup
RUN rm -rf /app/mlat-client/.git*


# Release
FROM python:3.9-alpine3.14 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.licenses="MIT"

# Workdir
WORKDIR /app

# Packages
RUN apk add --no-cache bash

# Copy files
COPY --from=builder /app/python-packages /usr/local
COPY --from=builder /app/mlat-client/ /app/
COPY entrypoint.sh /entrypoint.sh

# Permissions
RUN chmod +x /entrypoint.sh mlat-client fa-mlat-client && \
    mkdir /app/data

# Environment
ENV INPUT_TYPE="auto" \
    INPUT_CONNECT_HOST="" \
    INPUT_CONNECT_PORT="30002" \
    RESULTS="" \
    NO_ANON_RESULTS="no" \
    NO_MODEAC_RESULTS="no" \
    LAT="" \
    LON="" \
    ALT="" \
    PRIVACY="no" \
    USER="" \
    SERVER_HOST="feed.adsbexchange.com" \
    SERVER_PORT="31090" \
    NO_UDP="no" \
    LOG_TIMESTAMPS="no"

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command
CMD [ "sh", "-c", "python3 mlat-client" ]
