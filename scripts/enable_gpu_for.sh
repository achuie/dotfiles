#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    exit 1
fi

SANDBOX=""
if [ "$1" == "discord" ]; then
    SANDBOX="--no-sandbox"
fi
$@  --ignore-gpu-blocklist \
    --disable-features=UseOzonePlatform \
    --enable-features=VaapiVideoDecoder,VaapiVideoEncoder \
    --use-gl=desktop \
    --enable-gpu-rasterization \
    --enable-zero-copy \
    $SANDBOX
