#!/usr/bin/env bash

# Environment
SHARING_KEY="${SHARING_KEY:-}"
DUMP1090_HOST="${DUMP1090_HOST:-dump1090:30002}"

# Set variables
sed -i "s/{{SHARING_KEY}}/$SHARING_KEY/g" /etc/fr24feed.ini
sed -i "s/{{DUMP1090_HOST}}/$DUMP1090_HOST/g" /etc/fr24feed.ini

# Exec CMD
exec "$@"
