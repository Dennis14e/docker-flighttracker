#!/usr/bin/env bash

# Environment
INPUT_TYPE="${INPUT_TYPE:-auto}"
INPUT_CONNECT_HOST="${INPUT_CONNECT_HOST:-}"
INPUT_CONNECT_PORT="${INPUT_CONNECT_PORT:-30002}"
INPUT_CONNECT="${INPUT_CONNECT_HOST}:${INPUT_CONNECT_PORT}"
RESULTS="${RESULTS:-}"
NO_ANON_RESULTS="${NO_ANON_RESULTS:-no}"
NO_MODEAC_RESULTS="${NO_MODEAC_RESULTS:-no}"
LAT="${LAT:-}"
LON="${LON:-}"
ALT="${ALT:-}"
PRIVACY="${PRIVACY:-no}"
USER="${USER:-}"
SERVER_HOST="${SERVER_HOST:-feed.adsbexchange.com}"
SERVER_PORT="${SERVER_PORT:-31090}"
SERVER="${SERVER_HOST}:${SERVER_PORT}"
NO_UDP="${NO_UDP:-no}"
LOG_TIMESTAMPS="${LOG_TIMESTAMPS:-no}"


# Validate
if [ -z "$INPUT_TYPE" ] || [ -z "$INPUT_CONNECT_HOST" ] || [ -z "$INPUT_CONNECT_PORT" ] || [ -z "$LAT" ] || [ -z "$LON" ] || [ -z "$ALT" ] || [ -z "$USER" ] || [ -z "$SERVER_HOST" ] || [ -z "$SERVER_PORT" ]
then
    >&2 echo "Required environment variables are empty. Exiting..."
    sleep 3
    exit 1
fi


# Command
ARGS="--input-type ${INPUT_TYPE} --input-connect ${INPUT_CONNECT} --lat ${LAT} --lon ${LON} --alt ${ALT} --user ${USER} --server ${SERVER}"

if [ ! -z "$RESULTS" ]
then
    ARGS="${ARGS} --results ${RESULTS}"
fi

if [ "$NO_ANON_RESULTS" = "yes" ]
then
    ARGS="${ARGS} --no-anon-results"
fi

if [ "$NO_MODEAC_RESULTS" = "yes" ]
then
    ARGS="${ARGS} --no-modeac-results"
fi

if [ "$PRIVACY" = "yes" ]
then
    ARGS="${ARGS} --privacy"
fi

if [ "$NO_UDP" = "yes" ]
then
    ARGS="${ARGS} --no-udp"
fi

if [ "$LOG_TIMESTAMPS" = "yes" ]
then
    ARGS="${ARGS} --log-timestamps"
fi


# Execute
CMD=()
for i in "$@"
do
    CMD+=("$i")
done

CMD[${#CMD[@]}-1]="${CMD[-1]} $ARGS"

exec "${CMD[@]}"
