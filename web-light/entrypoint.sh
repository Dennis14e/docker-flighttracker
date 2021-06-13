#!/usr/bin/env sh

# Environment
READSB_HOST="${READSB_HOST:-readsb}"
READSB_PORT="${READSB_PORT:-8042}"

PAGE_TITLE="${PAGE_TITLE:-Flighttracker Web Light}"
REFRESH_RATE="${REFRESH_RATE:-250}"
CENTER_LAT="${CENTER_LAT:-45.0}"
CENTER_LNG="${CENTER_LNG:-9.0}"
CENTER_RADIUS="${CENTER_RADIUS:-500}"

# Set variables
sed -i "s/{{READSB_HOST}}/$READSB_HOST/g" /etc/nginx/nginx.conf
sed -i "s/{{READSB_PORT}}/$READSB_PORT/g" /etc/nginx/nginx.conf
sed -i "s/{{CENTER_LAT}}/$CENTER_LAT/g" /etc/nginx/nginx.conf
sed -i "s/{{CENTER_LNG}}/$CENTER_LNG/g" /etc/nginx/nginx.conf
sed -i "s/{{CENTER_RADIUS}}/$CENTER_RADIUS/g" /etc/nginx/nginx.conf

sed -i "s/{{PAGE_TITLE}}/$PAGE_TITLE/g" /app/index.html
sed -i "s/{{REFRESH_RATE}}/$REFRESH_RATE/g" /app/index.html
sed -i "s/{{CENTER_LAT}}/$CENTER_LAT/g" /app/index.html
sed -i "s/{{CENTER_LNG}}/$CENTER_LNG/g" /app/index.html
