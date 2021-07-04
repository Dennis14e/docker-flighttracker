# Builder
FROM alpine:3.14 AS builder

# Packages
RUN apk add --no-cache build-base git librtlsdr-dev

# Workdir
WORKDIR /app

# Get dump1090
RUN git clone https://github.com/antirez/dump1090.git . && \
    git -c advice.detachedHead=false checkout de61bd564f1aa929bae414a70e421acd0b81789a && \
    make

# Modify original gmap.html
RUN sed -i 's/<head>/<head><title>{{TITLE}}<\/title>/g' /app/gmap.html && \
    sed -i 's/CenterLat=45.0;/CenterLat={{GMAP_CENTER_LAT}};/g' /app/gmap.html && \
    sed -i 's/CenterLon=9.0;/CenterLon={{GMAP_CENTER_LNG}};/g' /app/gmap.html


# Release
FROM alpine:3.14 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flightradar" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash sed rtl-sdr

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/dump1090 /app/dump1090
COPY --from=builder /app/gmap.html /app/gmap.html
COPY entrypoint.sh /entrypoint.sh
COPY gmap.html /app/gmap_new.html

# Permissions
RUN chmod +x /entrypoint.sh /app/dump1090
RUN chmod 644 /app/gmap*.html

# ENV
ENV TITLE="dump1090" \
    GMAP_STYLE="old" \
    GMAP_CENTER_LAT="45.0" \
    GMAP_CENTER_LNG="9.0"

# Expose
EXPOSE 8080 30001 30002 30003

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command
CMD [ "/app/dump1090", "--net" ]
