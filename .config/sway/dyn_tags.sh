#!/bin/bash

# Focus a workspace or create a new one.

SWAYMSG=$(command -v swaymsg) || exit 1
JQ=$(command -v jq) || exit 2

$SWAYMSG workspace $($SWAYMSG -t get_workspaces | $JQ -M '.[] | .name' \
    | tr -d '"' | sort -u | dmenu)

MOVE=""
MENUPROMPT="switch:"
if [ $1 = "move" ]; then
    MOVE="-t command move"
    MENUPROMPT="move:"
fi

$SWAYMSG $MOVE workspace $($SWAYMSG -t get_workspaces | $JQ -M '.[] | .name' \
    | tr -d '"' | sort -u | tofi -c $HOME/.config/tofi/tofi_run_theme --anchor=bottom \
    --prompt-text=" $MENUPROMPT " --margin-bottom=18)
