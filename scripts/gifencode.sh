#!/bin/bash

# Converts a video file into a gif of alright quality.
#
# Usage:
#   $ ./gifencode.sh <input video file> <name of output gif> [low|normal|high]

palette="/tmp/palette.png"

case ${3:-"normal"} in
    "high")
        filters="fps=30"
        puse="dither=sierra2_4a"
        ;;
    "normal")
        filters="fps=30,scale=640:-1:flags=lanczos"
        puse="dither=sierra2_4a"
        ;;
    "low")
        filters="fps=24,scale=320:-1:flags=lanczos"
        puse="dither=bayer:bayer_scale=3"
        ;;
esac

ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $1 -i $palette -lavfi \
    "$filters [x]; [x][1:v] paletteuse=$puse" -y $2
