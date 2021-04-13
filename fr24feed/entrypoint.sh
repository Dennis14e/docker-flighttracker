#!/usr/bin/env bash

# Environment
SHARING_KEY="${SHARING_KEY:-}"

# Set variables
sed -i "s/{{SHARING_KEY}}/$SHARING_KEY/g" /etc/fr24feed.ini

# Exec CMD
exec "$@"
