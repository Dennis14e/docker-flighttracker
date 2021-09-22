#!/usr/bin/env sh

case `uname -m` in
    x86_64)
        archive="http://client.planefinder.net/pfclient_5.0.162_amd64.tar.gz"
        ;;

    i386|i686)
        archive="http://client.planefinder.net/pfclient_5.0.161_i386.tar.gz"
        ;;

    armv6l|armv7l|aarch64)
        archive="http://client.planefinder.net/pfclient_5.0.161_armhf.tar.gz"
        ;;

    *)
        echo "Unsupported architecture"
        exit 1
esac

wget -O - "$archive" | tar -xvzf - -C /app
