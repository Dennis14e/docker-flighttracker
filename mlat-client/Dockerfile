# Builder
FROM python:3.9-alpine3.13 AS builder

# Packages
RUN apk add --no-cache build-base git

# Workdir
WORKDIR /app

# Git Repository
RUN mkdir mlat-client && \
    cd mlat-client && \
    git clone -b master https://github.com/wiedehopf/mlat-client.git . && \
    git -c advice.detachedHead=false checkout c71c179 && \
    mkdir -p /app/python-packages && \
    python3 setup.py install --prefix=/app/python-packages

# Cleanup
RUN rm -rf /app/mlat-client/.git*


# Release
FROM python:3.9-alpine3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Workdir
WORKDIR /app

# Packages
RUN apk add --no-cache bash

# Python packages
COPY --from=builder /app/python-packages /usr/local

# mlat-client
COPY entrypoint.sh /entrypoint.sh

COPY --from=builder /app/mlat-client/ /app/

RUN chmod +x /entrypoint.sh mlat-client fa-mlat-client && \
    mkdir /app/data

# ENV
ENV INPUT_TYPE="auto"
ENV INPUT_CONNECT_HOST=""
ENV INPUT_CONNECT_PORT="30002"
ENV RESULTS=""
ENV NO_ANON_RESULTS="no"
ENV NO_MODEAC_RESULTS="no"
ENV LAT=""
ENV LON=""
ENV ALT=""
ENV PRIVACY="no"
ENV USER=""
ENV SERVER_HOST="feed.adsbexchange.com"
ENV SERVER_PORT="31090"
ENV NO_UDP="no"
ENV LOG_TIMESTAMPS="no"

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# CMD
CMD [ "sh", "-c", "python3 mlat-client" ]
