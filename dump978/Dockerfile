# Builder
FROM alpine:3.13 AS builder

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev boost-dev && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr-dev

# Workdir
WORKDIR /app

# Checkout SoapyRTLSDR
RUN git clone -b master https://github.com/pothosware/SoapyRTLSDR.git soapy-rtlsdr && \
    cd soapy-rtlsdr && \
    git -c advice.detachedHead=false checkout 53ee8f4a19dd97011a569cfc2e6f7ad63f896100

# Compile SoapyRTLSDR
RUN mkdir soapy-rtlsdr/build && \
    mkdir soapy-rtlsdr/install && \
    cd soapy-rtlsdr/build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install && \
    make && \
    make install

# Checkout dump978
RUN ls -la
RUN git clone -b master https://github.com/flightaware/dump978.git dump978
RUN cd dump978 && \
    git -c advice.detachedHead=false checkout c1e37f4acd7e47c46ca312a4016128aecfd03630

# Compile dump978
RUN cd dump978 && \
    make dump978-fa


# Release
FROM alpine:3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash librtlsdr boost-system boost-program_options boost-regex boost-filesystem && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/soapy-rtlsdr/install/ /usr/local/
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
