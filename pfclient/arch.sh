#!/usr/bin/env bash

if [ `uname -m` = "aarch64" ]
then
    dpkg --add-architecture armhf
    apt-get update
    apt-get install --no-install-recommends -y libc6:armhf
    rm -rf /var/lib/apt/lists/*
fi
