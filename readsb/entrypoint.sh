#!/usr/bin/env sh

# Environment
ADSB_UUID="${ADSB_UUID:-}"

# Set file
if [ ! -z "$ADSB_UUID" ]
then
    echo "$ADSB_UUID" > /boot/adsbx-uuid
fi

# Exec CMD
exec "$@"
