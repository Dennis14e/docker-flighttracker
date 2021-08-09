#!/usr/bin/env sh

case `uname -m` in
    x86_64)
        archive="https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_1.0.25-3_amd64.tgz"
        ;;

    i386|i686)
        archive="https://repo-feed.flightradar24.com/linux_x86_binaries/fr24feed_1.0.25-3_i386.tgz"
        ;;

    armv6l|armv7l|aarch64)
        archive="https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_1.0.28-1_armhf.tgz"
        ;;

    *)
        echo "Unsupported architecture"
        exit 1
esac

wget -O - "$archive" | tar -xvzf - --strip 1 -C /app
