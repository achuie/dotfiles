#!/usr/bin/env bash

function usage() {
    cat <<EOF
$(basename $0)
Run Electron- or Chromium-based programs with options to explicitly enable GPU
acceleration.

USAGE:
    $(basename $0) <PROGRAM>

ARGS:
    PROGRAM     The program to run

EOF
}
if [ $# -lt 1 ]; then
    usage
    exit 1
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
    exit 0
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
