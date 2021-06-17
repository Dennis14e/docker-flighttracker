#!/usr/bin/env bash

# Environment
LAT="${LAT:-}"
LON="${LON:-}"
MAX_RANGE="${MAX_RANGE:-360}"
METRIC="${METRIC:-no}"
INTERACTIVE="${INTERACTIVE:-no}"
NO_INTERACTIVE="${NO_INTERACTIVE:-yes}"
INTERACTIVE_TTL="${INTERACTIVE_TTL:-}"
ENABLE_BIASTEE="${ENABLE_BIASTEE:-no}"
QUIET="${QUIET:-yes}"
DEBUG="${DEBUG:-}"

UUID="${UUID:-}"
UUID_FILE="${UUID_FILE:-/data/uuid.txt}"

DEVICE_TYPE="${DEVICE_TYPE:-rtlsdr}"
DEVICE="${DEVICE:-}"
ENABLE_AGC="${ENABLE_AGC:-no}"
PPM="${PPM:-}"
GAIN="${GAIN:-}"
FREQ="${FREQ:-1090000000}"
PREAMBLE_THRESHOLD="${PREAMBLE_THRESHOLD:-}"

FIX="${FIX:-yes}"
NO_FIX="${NO_FIX:-no}"
FILTER_DF="${FILTER_DF:-}"
DCFILTER="${DCFILTER:-no}"
AGGRESSIVE="${AGGRESSIVE:-no}"

SHOW_ONLY="${SHOW_ONLY:-}"
RAW="${RAW:-}"
ONLYADDR="${ONLYADDR:-no}"

MODEAC="${MODEAC:-yes}"
MODEAC_AUTO="${MODEAC_AUTO:-no}"

MLAT="${MLAT:-yes}"
FORWARD_MLAT="${FORWARD_MLAT:-yes}"

STATS="${STATS:-}"
STATS_RANGE="${STATS_RANGE:-}"
STATS_EVERY="${STATS_EVERY:-}"

HEATMAP_DIR="${HEATMAP_DIR:-}"
HEATMAP="${HEATMAP:-}"

GNSS="${GNSS:-no}"
SNIP="${SNIP:-}"
WRITE_PROM="${WRITE_PROM:-}"
WRITE_STATE="${WRITE_STATE:-}"
WRITE_GLOBE_HISTORY="${WRITE_GLOBE_HISTORY:-}"
WRITE_JSON="${WRITE_JSON:-}"
WRITE_JSON_EVERY="${WRITE_JSON_EVERY:-}"
WRITE_JSON_GLOBE_INDEX="${WRITE_JSON_GLOBE_INDEX:-no}"
WRITE_JSON_GZIP="${WRITE_JSON_GZIP:-no}"
WRITE_JSON_BINCRAFT_ONLY="${WRITE_JSON_BINCRAFT_ONLY:-}"
WRITE_RECEIVER_ID_JSON="${WRITE_RECEIVER_ID_JSON:-no}"
JSON_LOCATION_ACCURACY="${JSON_LOCATION_ACCURACY:-2}"
JSON_TRACE_INTERVAL="${JSON_TRACE_INTERVAL:-}"
JSON_RELIABLE="${JSON_RELIABLE:-}"

JAERO_TIMEOUT="${JAERO_TIMEOUT:-}"

DB_FILE="${DB_FILE:-}"
DB_FILE_LT="${DB_FILE_LT:-}"

RECEIVER_FOCUS="${RECEIVER_FOCUS:-}"
CPR_FOCUS="${CPR_FOCUS:-}"
LEG_FOCUS="${LEG_FOCUS:-}"
TRACE_FOCUS="${TRACE_FOCUS:-}"

NET="${NET:-yes}"
NET_BUFFER="${NET_BUFFER:-}"
NET_VERBATIM="${NET_VERBATIM:-}"
NET_HEARTBEAT="${NET_HEARTBEAT:-}"
NET_CONNECTOR="${NET_CONNECTOR:-}"
NET_CONNECTOR_DELAY="${NET_CONNECTOR_DELAY:-}"
NET_ONLY="${NET_ONLY:-no}"
NET_BIND_ADDRESS="${NET_BIND_ADDRESS:-}"
NET_RECEIVER_ID="${NET_RECEIVER_ID:-}"
NET_INGEST="${NET_INGEST:-}"
NET_GARBAGE="${NET_GARBAGE:-}"
NET_API_PORT="${NET_API_PORT:-}"
NET_JSON_PORT="${NET_JSON_PORT:-}"
NET_RO_SIZE="${NET_RO_SIZE:-}"
NET_RO_INTERVAL="${NET_RO_INTERVAL:-}"
NET_RO_PORT="${NET_RO_PORT:-}"
NET_RI_PORT="${NET_RI_PORT:-}"
NET_BO_PORT="${NET_BO_PORT:-}"
NET_BI_PORT="${NET_BI_PORT:-}"
NET_SBS_REDUCE="${NET_SBS_REDUCE:-}"
NET_SBS_PORT="${NET_SBS_PORT:-}"
NET_SBS_IN_PORT="${NET_SBS_IN_PORT:-}"
NET_SBS_JAERO_PORT="${NET_SBS_JAERO_PORT:-}"
NET_SBS_JAERO_IN_PORT="${NET_SBS_JAERO_IN_PORT:-}"
NET_VRS_INTERVAL="${NET_VRS_INTERVAL:-}"
NET_VRS_PORT="${NET_VRS_PORT:-}"
NET_BEAST_REDUCE_INTERVAL="${NET_BEAST_REDUCE_INTERVAL:-}"
NET_BEAST_REDUCE_FILTER_DIST="${NET_BEAST_REDUCE_FILTER_DIST:-}"
NET_BEAST_REDUCE_FILTER_ALL="${NET_BEAST_REDUCE_FILTER_ALL:-}"
NET_BEAST_REDUCE_OUT_PORT="${NET_BEAST_REDUCE_OUT_PORT:-}"

BEAST_SERIAL="${BEAST_SERIAL:-}"
BEAST_DF1117_ON="${BEAST_DF1117_ON:-no}"
BEAST_MLAT_OFF="${BEAST_MLAT_OFF:-no}"
BEAST_CRC_OFF="${BEAST_CRC_OFF:-no}"
BEAST_DF045_ON="${BEAST_DF045_ON:-no}"
BEAST_FEC_OFF="${BEAST_FEC_OFF:-no}"
BEAST_MODEAC="${BEAST_MODEAC:-no}"

IFILE="${IFILE:-}"
IFORMAT="${IFORMAT:-}"
THROTTLE="${THROTTLE:-no}"

CUSTOM="${CUSTOM:-}"


# Validate
if [ -z "$DEVICE_TYPE" ] || [ -z "$DEVICE" ]
then
    >&2 echo "Required environment variables are empty. Exiting..."
    sleep 3
    exit 1
fi


# Command
ARGS="--device-type ${DEVICE_TYPE} --device ${DEVICE}"


if [ ! -z "$LAT" ]
then
    ARGS="${ARGS} --lat ${LAT}"
fi

if [ ! -z "$LON" ]
then
    ARGS="${ARGS} --lon ${LON}"
fi

if [ ! -z "$MAX_RANGE" ]
then
    ARGS="${ARGS} --max-range ${MAX_RANGE}"
fi

if [ "$METRIC" = "yes" ]
then
    ARGS="${ARGS} --metric"
fi

if [ "$INTERACTIVE" = "yes" ]
then
    ARGS="${ARGS} --interactive"
fi

if [ "$NO_INTERACTIVE" = "yes" ]
then
    ARGS="${ARGS} --no-interactive"
fi

if [ ! -z "$INTERACTIVE_TTL" ]
then
    ARGS="${ARGS} --interactive-ttl ${INTERACTIVE_TTL}"
fi

if [ "$ENABLE_BIASTEE" = "yes" ]
then
    ARGS="${ARGS} --enable-biastee"
fi

if [ "$QUIET" = "yes" ]
then
    ARGS="${ARGS} --quiet"
fi

if [ ! -z "$DEBUG" ]
then
    ARGS="${ARGS} --debug ${DEBUG}"
fi


if [ ! -z "$UUID_FILE" ]
then
    ARGS="${ARGS} --uuid-file ${UUID_FILE}"

    if [ ! -z "$UUID" ]
    then
        echo "$UUID" > "$UUID_FILE"
    fi
fi


if [ "$ENABLE_AGC" = "yes" ]
then
    ARGS="${ARGS} --enable-agc"
fi

if [ ! -z "$PPM" ]
then
    ARGS="${ARGS} --ppm ${PPM}"
fi

if [ ! -z "$GAIN" ]
then
    ARGS="${ARGS} --gain ${GAIN}"
fi

if [ ! -z "$FREQ" ]
then
    ARGS="${ARGS} --freq ${FREQ}"
fi

if [ ! -z "$PREAMBLE_THRESHOLD" ]
then
    ARGS="${ARGS} --preamble-threshold ${PREAMBLE_THRESHOLD}"
fi


if [ "$FIX" = "yes" ]
then
    ARGS="${ARGS} --fix"
fi

if [ "$NO_FIX" = "yes" ]
then
    ARGS="${ARGS} --no-fix"
fi

if [ ! -z "$FILTER_DF" ]
then
    ARGS="${ARGS} --filter-DF ${FILTER_DF}"
fi

if [ "$DCFILTER" = "yes" ]
then
    ARGS="${ARGS} --dcfilter"
fi

if [ "$AGGRESSIVE" = "yes" ]
then
    ARGS="${ARGS} --aggressive"
fi


if [ "$MODEAC" = "yes" ]
then
    ARGS="${ARGS} --modeac"
fi

if [ "$MODEAC_AUTO" = "yes" ]
then
    ARGS="${ARGS} --modeac-auto"
fi


if [ "$MLAT" = "yes" ]
then
    ARGS="${ARGS} --mlat"
fi

if [ "$FORWARD_MLAT" = "yes" ]
then
    ARGS="${ARGS} --forward-mlat"
fi


if [ ! -z "$STATS" ]
then
    ARGS="${ARGS} --stats ${STATS}"
fi

if [ ! -z "$STATS_RANGE" ]
then
    ARGS="${ARGS} --stats-range ${STATS_RANGE}"
fi

if [ ! -z "$STATS_EVERY" ]
then
    ARGS="${ARGS} --stats-every ${STATS_EVERY}"
fi


if [ ! -z "$HEATMAP_DIR" ]
then
    ARGS="${ARGS} --heatmap-dir ${HEATMAP_DIR}"
fi

if [ ! -z "$HEATMAP" ]
then
    ARGS="${ARGS} --heatmap ${HEATMAP}"
fi


if [ "$GNSS" = "yes" ]
then
    ARGS="${ARGS} --gnss"
fi

if [ ! -z "$SNIP" ]
then
    ARGS="${ARGS} --snip ${SNIP}"
fi

if [ ! -z "$WRITE_PROM" ]
then
    ARGS="${ARGS} --write-prom ${WRITE_PROM}"
fi

if [ ! -z "$WRITE_STATE" ]
then
    ARGS="${ARGS} --write-state ${WRITE_STATE}"
fi

if [ ! -z "$WRITE_GLOBAL_HISTORY" ]
then
    ARGS="${ARGS} --write-global-history ${WRITE_GLOBAL_HISTORY}"
fi

if [ ! -z "$WRITE_JSON" ]
then
    ARGS="${ARGS} --write-json ${WRITE_JSON}"
fi

if [ ! -z "$WRITE_JSON_EVERY" ]
then
    ARGS="${ARGS} --write-json-every ${WRITE_JSON_EVERY}"
fi

if [ "$WRITE_JSON_GLOBE_INDEX" = "yes" ]
then
    ARGS="${ARGS} --write-json-globe-index"
fi

if [ "$WRITE_JSON_GZIP" = "yes" ]
then
    ARGS="${ARGS} --write-json-gzip"
fi

if [ ! -z "$WRITE_JSON_BINCRAFT_ONLY" ]
then
    ARGS="${ARGS} --write-json-bincraft-only ${WRITE_JSON_BINCRAFT_ONLY}"
fi

if [ "$WRITE_RECEIVER_ID_JSON" = "yes" ]
then
    ARGS="${ARGS} --write-receiver-id-json"
fi

if [ ! -z "$JSON_LOCATION_ACCURACY" ]
then
    ARGS="${ARGS} --json-location-accuracy ${JSON_LOCATION_ACCURACY}"
fi

if [ ! -z "$JSON_TRACE_INTERVAL" ]
then
    ARGS="${ARGS} --json-trace-interval ${JSON_TRACE_INTERVAL}"
fi

if [ ! -z "$JSON_RELIABLE" ]
then
    ARGS="${ARGS} --json-reliable ${JSON_RELIABLE}"
fi


if [ ! -z "$JAERO_TIMEOUT" ]
then
    ARGS="${ARGS} --jaero-timeout ${JAERO_TIMEOUT}"
fi


if [ ! -z "$DB_FILE" ]
then
    ARGS="${ARGS} --db-file ${DB_FILE}"
fi

if [ ! -z "$DB_FILE_LT" ]
then
    ARGS="${ARGS} --db-file-lt ${DB_FILE_LT}"
fi


if [ ! -z "$RECEIVER_FOCUS" ]
then
    ARGS="${ARGS} --receiver-focus ${RECEIVER_FOCUS}"
fi

if [ ! -z "$CPR_FOCUS" ]
then
    ARGS="${ARGS} --cpr-focus ${CPR_FOCUS}"
fi

if [ ! -z "$LEG_FOCUS" ]
then
    ARGS="${ARGS} --leg-focus ${LEG_FOCUS}"
fi

if [ ! -z "$TRACE_FOCUS" ]
then
    ARGS="${ARGS} --trace-focus ${TRACE_FOCUS}"
fi


if [ "$NET" = "yes" ]
then
    ARGS="${ARGS} --net"
fi

if [ ! -z "$NET_BUFFER" ]
then
    ARGS="${ARGS} --net-buffer ${NET_BUFFER}"
fi

if [ ! -z "$NET_VERBATIM" ]
then
    ARGS="${ARGS} --net-verbatim ${NET_VERBATIM}"
fi

if [ ! -z "$NET_HEARTBEAT" ]
then
    ARGS="${ARGS} --net-heartbeat ${NET_HEARTBEAT}"
fi

if [ ! -z "$NET_CONNECTION" ]
then
    ARGS="${ARGS} --net-connection ${NET_CONNECTION}"
fi

if [ ! -z "$NET_CONNECTION_DELAY" ]
then
    ARGS="${ARGS} --net-connection-delay ${NET_CONNECTION_DELAY}"
fi

if [ "$NET_ONLY" = "yes" ]
then
    ARGS="${ARGS} --net-only"
fi

if [ ! -z "$NET_BIND_ADDRESS" ]
then
    ARGS="${ARGS} --net-bind-address ${NET_BIND_ADDRESS}"
fi

if [ ! -z "$NET_RECEIVER_ID" ]
then
    ARGS="${ARGS} --net-receiver-id ${NET_RECEIVER_ID}"
fi

if [ ! -z "$NET_INGEST" ]
then
    ARGS="${ARGS} --net-ingest ${NET_INGEST}"
fi

if [ ! -z "$NET_GARBAGE" ]
then
    ARGS="${ARGS} --net-garbage ${NET_GARBAGE}"
fi

if [ ! -z "$NET_API_PORT" ]
then
    ARGS="${ARGS} --net-api-port ${NET_API_PORT}"
fi

if [ ! -z "$NET_JSON_PORT" ]
then
    ARGS="${ARGS} --net-json-port ${NET_JSON_PORT}"
fi

if [ ! -z "$NET_RO_SIZE" ]
then
    ARGS="${ARGS} --net-ro-size ${NET_RO_SIZE}"
fi

if [ ! -z "$NET_RO_INTERVAL" ]
then
    ARGS="${ARGS} --net-ro-interval ${NET_RO_INTERVAL}"
fi

if [ ! -z "$NET_RO_PORT" ]
then
    ARGS="${ARGS} --net-ro-port ${NET_RO_PORT}"
fi

if [ ! -z "$NET_RI_PORT" ]
then
    ARGS="${ARGS} --net-ri-port ${NET_RI_PORT}"
fi

if [ ! -z "$NET_BO_PORT" ]
then
    ARGS="${ARGS} --net-bo-port ${NET_BO_PORT}"
fi

if [ ! -z "$NET_BI_PORT" ]
then
    ARGS="${ARGS} --net-bi-port ${NET_BI_PORT}"
fi

if [ ! -z "$NET_SBS_REDUCE" ]
then
    ARGS="${ARGS} --net-sbs-reduce ${NET_SBS_REDUCE}"
fi

if [ ! -z "$NET_SBS_PORT" ]
then
    ARGS="${ARGS} --net-sbs-port ${NET_SBS_PORT}"
fi

if [ ! -z "$NET_SBS_IN_PORT" ]
then
    ARGS="${ARGS} --net-sbs-in-port ${NET_SBS_IN_PORT}"
fi

if [ ! -z "$NET_SBS_JAERO_PORT" ]
then
    ARGS="${ARGS} --net-sbs-jaero-port ${NET_SBS_JAERO_PORT}"
fi

if [ ! -z "$NET_SBS_JAERO_IN_PORT" ]
then
    ARGS="${ARGS} --net-jaero-in-port ${NET_SBS_JAERO_IN_PORT}"
fi

if [ ! -z "$NET_VRS_INTERVAL" ]
then
    ARGS="${ARGS} --net-vrs-interval ${NET_VRS_INTERVAL}"
fi

if [ ! -z "$NET_VRS_PORT" ]
then
    ARGS="${ARGS} --net-vrs-port ${NET_VRS_PORT}"
fi

if [ ! -z "$NET_BEAST_REDUCE_INTERVAL" ]
then
    ARGS="${ARGS} --net-beast-reduce-interval ${NET_BEAST_REDUCE_INTERVAL}"
fi

if [ ! -z "$NET_BEAST_REDUCE_FILTER_DIST" ]
then
    ARGS="${ARGS} --net-beast-reduce-filter-dist ${NET_BEAST_REDUCE_FILTER_DIST}"
fi

if [ ! -z "$NET_BEAST_REDUCE_FILTER_ALL" ]
then
    ARGS="${ARGS} --net-beast-reduce-filter-all ${NET_BEAST_REDUCE_FILTER_ALL}"
fi

if [ ! -z "$NET_BEAST_REDUCE_OUT_PORT" ]
then
    ARGS="${ARGS} --net-beast-reduce-out-port ${NET_BEAST_REDUCE_OUT_PORT}"
fi


if [ ! -z "$BEAST_SERIAL" ]
then
    ARGS="${ARGS} --beast-serial ${BEAST_SERIAL}"
fi

if [ "$BEAST_DF1117_ON" = "yes" ]
then
    ARGS="${ARGS} --beast-df1117-on"
fi

if [ "$BEAST_MLAT_OFF" = "yes" ]
then
    ARGS="${ARGS} --beast-mlat-off"
fi

if [ "$BEAST_CRC_OFF" = "yes" ]
then
    ARGS="${ARGS} --beast-crc-off"
fi

if [ "$BEAST_DF045_ON" = "yes" ]
then
    ARGS="${ARGS} --beast-df045-on"
fi

if [ "$BEAST_FEC_OFF" = "yes" ]
then
    ARGS="${ARGS} --beast-fec-off"
fi

if [ "$BEAST_MODEAC" = "yes" ]
then
    ARGS="${ARGS} --beast-modeac"
fi


if [ ! -z "$IFILE" ]
then
    ARGS="${ARGS} --ifile ${IFILE}"
fi

if [ ! -z "$IFORMAT" ]
then
    ARGS="${ARGS} --iformat ${IFORMAT}"
fi

if [ "$THROTTLE" = "yes" ]
then
    ARGS="${ARGS} --throttle"
fi


if [ ! -z "$CUSTOM" ]
then
    ARGS="${ARGS} ${CUSTOM}"
fi


# Execute
CMD=()
for i in "$@"
do
    CMD+=("$i")
done

CMD[${#CMD[@]}-1]="${CMD[-1]} $ARGS"

exec "${CMD[@]}"
