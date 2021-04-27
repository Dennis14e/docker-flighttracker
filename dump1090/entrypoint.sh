#!/usr/bin/env bash

# Environment
TITLE="${GMAP_STYLE:-dump1090}"
GMAP_STYLE="${GMAP_STYLE:-old}"
GMAP_CENTER_LAT="${GMAP_CENTER_LAT:-45.0}"
GMAP_CENTER_LNG="${GMAP_CENTER_LNG:-9.0}"

# New style
if [ $GMAP_STYLE != "old" ]
then
    # Overwrite old gmap tmpl
    mv -f /app/gmap_new.html /app/gmap.html
fi

# Set variables
sed -i "s/{{TITLE}}/$TITLE/g" /app/gmap.html
sed -i "s/{{GMAP_CENTER_LAT}}/$GMAP_CENTER_LAT/g" /app/gmap.html
sed -i "s/{{GMAP_CENTER_LNG}}/$GMAP_CENTER_LNG/g" /app/gmap.html

# Exec CMD
exec "$@"
