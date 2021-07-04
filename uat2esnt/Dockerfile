# Builder
FROM alpine:3.14 AS builder

# Packages
RUN apk add --no-cache build-base git

# Workdir
WORKDIR /app

# Checkout uat2esnt
RUN git clone -b master https://github.com/adsbxchange/uat2esnt.git . && \
    git -c advice.detachedHead=false checkout 1992abdcb409d1c5e23139fd993bb1c81c349abd

# Compile uat2esnt
RUN make uat2esnt


# Release
FROM alpine:3.14 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash socat

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/uat2esnt /app/uat2esnt

# Permissions
RUN chmod +x /app/uat2esnt

# Environment
ENV DUMP978_HOST="dump978" \
    DUMP978_PORT="30002" \
    OUTPUT_PORT="30002"

# Command
CMD [ "sh", "-c", "socat -u tcp:${DUMP978_HOST}:${DUMP978_PORT} stdout | /app/uat2esnt | socat -d -d -u stdin tcp-listen:${OUTPUT_PORT},fork" ]
