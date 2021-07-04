# Builder
FROM flighttrackr/soapysdr-rtlsdr:alpine3.14 AS builder

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev boost-dev

# Workdir
WORKDIR /app

# Checkout dump978
RUN git clone -b master https://github.com/flightaware/dump978.git dump978
RUN cd dump978 && \
    git -c advice.detachedHead=false checkout c1e37f4acd7e47c46ca312a4016128aecfd03630

# Compile dump978
RUN cd dump978 && \
    make dump978-fa


# Release
FROM flighttrackr/soapysdr-rtlsdr:alpine3.14 AS release

LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash librtlsdr boost-system boost-program_options boost-regex boost-filesystem

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/dump978/dump978-fa /app/dump978
COPY entrypoint.sh /entrypoint.sh

# Permissions
RUN chmod +x /entrypoint.sh /app/dump978

# Environment
ENV SDR_DRIVER="rtlsdr" \
    SDR_AUTO_GAIN="no" \
    SDR_GAIN="" \
    SDR_PPM="" \
    SDR_ANTENNA="" \
    SDR_STREAM_SETTINGS="" \
    SDR_DEVICE_SETTINGS="" \
    STRATUXV3="" \
    FORMAT="CS8" \
    RAW_STDOUT="no" \
    JSON_STDOUT="no" \
    RAW_PORT="30002" \
    JSON_PORT="" \
    CUSTOM=""

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command
CMD [ "sh", "-c", "/app/dump978" ]
