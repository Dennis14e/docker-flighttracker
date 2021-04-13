# Builder
FROM alpine:3.13 AS builder
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# fr24feed
WORKDIR /app

COPY dl-fr24feed.sh /tmp/dl-fr24feed.sh

RUN chmod 777 /tmp/dl-fr24feed.sh && \
    /tmp/dl-fr24feed.sh


# Base
FROM alpine:3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Packages
RUN apk add bash sed libc6-compat libstdc++6

# fr24feed
WORKDIR /usr/lib/fr24

COPY --from=builder /app /usr/lib/fr24

COPY entrypoint.sh /entrypoint.sh
COPY fr24feed.ini /etc/fr24feed.ini

RUN chmod 777 /entrypoint.sh /usr/lib/fr24/fr24feed
RUN chmod 644 /etc/fr24feed.ini

# Expose
EXPOSE 8754

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# CMD
CMD [ "/usr/lib/fr24/fr24feed" ]
