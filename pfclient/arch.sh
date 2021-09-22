#!/usr/bin/env bash

case `uname -m` in
    armv7l|aarch64)
        dpkg --add-architecture armhf
        apt-get update
        apt-get install --no-install-recommends -y libc6:armhf
        rm -rf /var/lib/apt/lists/*
        ;;

    *)
        echo "Supported architecture"
        ;;
esac
