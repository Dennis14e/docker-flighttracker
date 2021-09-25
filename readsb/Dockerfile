# Builder
FROM alpine:3.14 AS builder

# Packages
RUN apk add --no-cache build-base git librtlsdr-dev ncurses-dev zlib-dev argp-standalone

# Workdir
WORKDIR /app

# Get readsb
RUN git clone -b sid https://github.com/wiedehopf/readsb.git . && \
    git -c advice.detachedHead=false checkout 82713b6655f58c4105e843fb504796afa82738c0 && \
    mkdir patches

COPY patches/*.patch patches/

# Apply patches and compile
RUN git apply patches/*.patch && \
    make readsb RTLSDR=yes


# Release
FROM alpine:3.14 AS release
LABEL maintainer="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.authors="Dennis Neufeld <git@dneufeld.net>" \
      org.opencontainers.image.url="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.source="https://github.com/Dennis14e/docker-flighttracker" \
      org.opencontainers.image.licenses="MIT"

# Packages
RUN apk add --no-cache bash rtl-sdr ncurses zlib

# Workdir
WORKDIR /app

COPY --from=builder /app/readsb /app/readsb
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh /app/readsb && \
    mkdir /data

# Environment
ENV LAT="" \
    LON="" \
    MAX_RANGE="360" \
    METRIC="no" \
    INTERACTIVE="no" \
    NO_INTERACTIVE="yes" \
    INTERACTIVE_TTL="" \
    ENABLE_BIASTEE="no" \
    QUIET="yes" \
    DEBUG="" \
    \
    UUID="" \
    UUID_FILE="/data/uuid.txt" \
    \
    DEVICE_TYPE="rtlsdr" \
    DEVICE="" \
    ENABLE_AGC="no" \
    PPM="" \
    GAIN="" \
    FREQ="1090000000" \
    PREAMBLE_THRESHOLD="" \
    \
    FIX="yes" \
    NO_FIX="no" \
    FILTER_DF="" \
    DCFILTER="no" \
    AGGRESSIVE="no" \
    \
    SHOW_ONLY="" \
    RAW="" \
    ONLYADDR="no" \
    \
    MODEAC="yes" \
    MODEAC_AUTO="no" \
    \
    MLAT="yes" \
    FORWARD_MLAT="yes" \
    \
    STATS="" \
    STATS_RANGE="" \
    STATS_EVERY="" \
    \
    HEATMAP_DIR="" \
    HEATMAP="" \
    \
    GNSS="no" \
    SNIP="" \
    WRITE_PROM="" \
    WRITE_STATE="" \
    WRITE_GLOBE_HISTORY="" \
    WRITE_JSON="" \
    WRITE_JSON_EVERY="" \
    WRITE_JSON_GLOBE_INDEX="no" \
    WRITE_JSON_GZIP="no" \
    WRITE_JSON_BINCRAFT_ONLY="" \
    WRITE_RECEIVER_ID_JSON="no" \
    JSON_LOCATION_ACCURACY="2" \
    JSON_TRACE_INTERVAL="" \
    JSON_RELIABLE="" \
    \
    JAERO_TIMEOUT="" \
    \
    DB_FILE="" \
    DB_FILE_LT="" \
    \
    RECEIVER_FOCUS="" \
    CPR_FOCUS="" \
    LEG_FOCUS="" \
    TRACE_FOCUS="" \
    \
    NET="yes" \
    NET_BUFFER="" \
    NET_VERBATIM="" \
    NET_HEARTBEAT="" \
    NET_CONNECTOR="" \
    NET_CONNECTOR_DELAY="" \
    NET_ONLY="no" \
    NET_BIND_ADDRESS="" \
    NET_RECEIVER_ID="" \
    NET_INGEST="" \
    NET_GARBAGE="" \
    NET_API_PORT="" \
    NET_JSON_PORT="" \
    NET_RO_SIZE="" \
    NET_RO_INTERVAL="" \
    NET_RO_PORT="" \
    NET_RI_PORT="" \
    NET_BO_PORT="" \
    NET_BI_PORT="" \
    NET_SBS_REDUCE="" \
    NET_SBS_PORT="" \
    NET_SBS_IN_PORT="" \
    NET_SBS_JAERO_PORT="" \
    NET_SBS_JAERO_IN_PORT="" \
    NET_VRS_INTERVAL="" \
    NET_VRS_PORT="" \
    NET_BEAST_REDUCE_INTERVAL="" \
    NET_BEAST_REDUCE_FILTER_DIST="" \
    NET_BEAST_REDUCE_FILTER_ALL="" \
    NET_BEAST_REDUCE_OUT_PORT="" \
    \
    BEAST_SERIAL="" \
    BEAST_DF1117_ON="no" \
    BEAST_MLAT_OFF="no" \
    BEAST_CRC_OFF="no" \
    BEAST_DF045_ON="no" \
    BEAST_FEC_OFF="no" \
    BEAST_MODEAC="no" \
    \
    IFILE="" \
    IFORMAT="" \
    THROTTLE="no" \
    CUSTOM=""

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command
CMD [ "sh", "-c", "/app/readsb" ]
