#!/usr/bin/env bash

# Environment
SHARING_KEY="${SHARING_KEY:-}"
DUMP1090_HOST="${DUMP1090_HOST:-dump1090}"
DUMP1090_PORT="${DUMP1090_PORT:-30002}"
LAT="${LAT:-}"
LON="${LON:-}"

# Set variables
sed -i "s/{{SHARING_KEY}}/$SHARING_KEY/g" /app/pfclient-config.json
sed -i "s/{{DUMP1090_HOST}}/$DUMP1090_HOST/g" /app/pfclient-config.json
sed -i "s/{{DUMP1090_PORT}}/$DUMP1090_PORT/g" /app/pfclient-config.json
sed -i "s/{{LAT}}/$LAT/g" /app/pfclient-config.json
sed -i "s/{{LON}}/$LON/g" /app/pfclient-config.json

# Exec CMD
exec "$@"
