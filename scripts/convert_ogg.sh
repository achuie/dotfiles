#!/bin/bash

# Converts lossless music files to 320kbps .ogg files.
#
# Must be run in the top-level music directory, if MPD isn't configured to use
# absolute paths.
#
# Suggested to write the results of 'find' to a file in order to convert/copy a
# directory instead of a playlist.
#
# Usage:
#   ./convert_ogg.sh <playlist file> <target directory>

OLDIFS=$IFS
IFS=$'\n'

while read -r -u 10 LINE || [[ -n "$LINE" ]]; do
    DIR=$(dirname "$LINE")
    SONG=$(basename "$LINE")

    if [[ ! -d "$2/$DIR" ]]; then
        mkdir -p $2/$DIR
    fi

    if [[ -a "$2/$DIR/${SONG%.*}.ogg" ]]; then
        echo "    Redundant $LINE"
        continue;
    fi

    # if file is in lossless format
    if [[ $(ffprobe -v error -select_streams a -show_entries \
            stream=codec_name -of default=nokey=1:noprint_wrappers=1 $LINE) \
            =~ .*?(flac|alac) ]]; then
        echo "    Converting $LINE"
        ffmpeg -loglevel warning -i "$LINE" -map 0:a -c:a libvorbis -b:a 320k \
                "$2/$DIR/${SONG%.*}.ogg"
    else
        echo "    Copying $LINE"
        cp $LINE "$2/$DIR/$SONG"
    fi

# redirect to fd 10 is arbitrary and necessary to avoid stdin read/write
# conflict
done 10<"$1"

IFS=$OLDIFS
