#!/usr/bin/env bash

# Environment
SDR_DRIVER="${SDR_DRIVER:-rtlsdr}"
SDR_AUTO_GAIN="${SDR_AUTO_GAIN:-no}"
SDR_GAIN="${SDR_GAIN:-}"
SDR_PPM="${SDR_PPM:-}"
SDR_ANTENNA="${SDR_ANTENNA:-}"
SDR_STREAM_SETTINGS="${SDR_STREAM_SETTINGS:-}"
SDR_DEVICE_SETTINGS="${SDR_DEVICE_SETTINGS:-}"
STRATUXV3="${STRATUXV3:-}"
FORMAT="${FORMAT:-CS8}"

RAW_STDOUT="${RAW_STDOUT:-no}"
JSON_STDOUT="${JSON_STDOUT:-no}"

RAW_PORT="${RAW_PORT:-30002}"
JSON_PORT="${JSON_PORT:-}"

CUSTOM="${CUSTOM:-}"


# Validate
if [ -z "$SDR_DRIVER" ]
then
    >&2 echo "Required environment variables are empty. Exiting..."
    sleep 3
    exit 1
fi


# Command
ARGS="--sdr driver=${SDR_DRIVER} --raw-port ${RAW_PORT}"


if [ "$SDR_AUTO_GAIN" = "yes" ]
then
    ARGS="${ARGS} --sdr-auto-gain"
fi

if [ ! -z "$SDR_GAIN" ]
then
    ARGS="${ARGS} --sdr-gain ${SDR_GAIN}"
fi

if [ ! -z "$SDR_PPM" ]
then
    ARGS="${ARGS} --sdr-ppm ${SDR_PPM}"
fi

if [ ! -z "$SDR_ANTENNA" ]
then
    ARGS="${ARGS} --sdr-antenna ${SDR_ANTENNA}"
fi

if [ ! -z "$SDR_STREAM_SETTINGS" ]
then
    ARGS="${ARGS} --sdr-stream-settings ${SDR_STREAM_SETTINGS}"
fi

if [ ! -z "$SDR_DEVICE_SETTINGS" ]
then
    ARGS="${ARGS} --sdr-device-settings ${SDR_DEVICE_SETTINGS}"
fi

if [ ! -z "$STRATUXV3" ]
then
    ARGS="${ARGS} --stratuxv3 ${STRATUXV3}"
fi

if [ ! -z "$FORMAT" ]
then
    ARGS="${ARGS} --format ${FORMAT}"
fi

if [ "$RAW_STDOUT" = "yes" ]
then
    ARGS="${ARGS} --raw-stdout"
fi

if [ "$JSON_STDOUT" = "yes" ]
then
    ARGS="${ARGS} --json-stdout"
fi


if [ ! -z "$JSON_PORT" ]
then
    ARGS="${ARGS} --json-port ${JSON_PORT}"
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
