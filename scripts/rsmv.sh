#!/usr/bin/env bash

function usage() {
    cat <<EOF
$(basename $0)
Copy files with rsync for resilience and progress reporting, then remove source
files, similar to 'mv'.

USAGE:
    $(basename $0) <src> <dest>
EOF
}

if [ $# -lt 2 ]; then
    usage
    exit 1
elif [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
    exit 0
fi

rsync -hvrtP --remove-source-files --info=progress2 "$1" "$2" && find "$1" -depth -exec rmdir {} +
