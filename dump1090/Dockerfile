# Builder
FROM alpine:3.13 AS builder
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Packages
RUN apk add build-base git librtlsdr-dev

# dump1090
WORKDIR /app

RUN git clone --depth 1 https://github.com/antirez/dump1090.git . && \
    make

RUN sed -i 's/CenterLat=45.0;/CenterLat={{GMAP_CENTER_LAT}};/g' /app/gmap.html && \
    sed -i 's/CenterLon=9.0;/CenterLon={{GMAP_CENTER_LNG}};/g' /app/gmap.html

# Base
FROM alpine:3.13 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>"

# Packages
RUN apk add bash sed rtl-sdr

# dump1090
WORKDIR /app

COPY --from=builder /app/dump1090 /app/dump1090
COPY --from=builder /app/gmap.html /app/gmap.html

COPY entrypoint.sh /entrypoint.sh
COPY gmap.html /app/gmap_new.html

RUN chmod 777 /entrypoint.sh /app/dump1090
RUN chmod 644 /app/gmap*.html

# Expose
EXPOSE 8080 30001 30002 30003

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# CMD
CMD [ "/app/dump1090", "--net" ]
