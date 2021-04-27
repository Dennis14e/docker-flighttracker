#!/usr/bin/env bash

# Environment
SHARING_KEY="${SHARING_KEY:-}"
DUMP1090_HOST="${DUMP1090_HOST:-dump1090:30002}"
RECEIVER="${RECEIVER:-avr-tcp}"
BS="${BS:-no}"
RAW="${RAW:-no}"
LOGMODE="${LOGMODE:-0}"
WINDOWMODE="${WINDOWMODE:-0}"
MPX="${MPX:-no}"
MLAT="${MLAT:-yes}"
MLAT_WITHOUT_GPS="${MLAT_WITHOUT_GPS:-yes}"

# Set variables
sed -i "s/{{SHARING_KEY}}/$SHARING_KEY/g" /etc/fr24feed.ini
sed -i "s/{{DUMP1090_HOST}}/$DUMP1090_HOST/g" /etc/fr24feed.ini
sed -i "s/{{RECEIVER}}/$RECEIVER/g" /etc/fr24feed.ini
sed -i "s/{{BS}}/$BS/g" /etc/fr24feed.ini
sed -i "s/{{RAW}}/$RAW/g" /etc/fr24feed.ini
sed -i "s/{{LOGMODE}}/$LOGMODE/g" /etc/fr24feed.ini
sed -i "s/{{WINDOWMODE}}/$WINDOWMODE/g" /etc/fr24feed.ini
sed -i "s/{{MPX}}/$MPX/g" /etc/fr24feed.ini
sed -i "s/{{MLAT}}/$MLAT/g" /etc/fr24feed.ini
sed -i "s/{{MLAT_WITHOUT_GPS}}/$MLAT_WITHOUT_GPS/g" /etc/fr24feed.ini

# Exec CMD
exec "$@"
