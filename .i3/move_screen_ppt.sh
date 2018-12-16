#!/bin/bash

# Gets the pixel coordinates of the given percentage of screen width and
# height, from the top left corner.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

$I3MSG -t command move position $($I3MSG -t get_outputs \
    | $JQ -M '.[] | {active: .active, w: .rect.width, h: .rect.height}
    | select(.active == true) | [.w, .h] | [.[0]*.'"$1"', .[1]*.'"$2"']
    | map(floor) | join(" ")' | tr -d '"')
