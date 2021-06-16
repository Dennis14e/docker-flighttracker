#!/usr/bin/env sh

# Environment
ADSBX_UUID="${ADSBX_UUID:-}"

# Set file
if [ ! -z "$ADSBX_UUID" ]
then
    echo "$ADSBX_UUID" > /boot/adsbx-uuid
fi

# Exec CMD
exec "$@"
