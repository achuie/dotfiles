#!/usr/bin/env bash

# Focus a workspace or create a new one.

set -euo pipefail

NIRI=$(command -v niri) || exit 1
JQ=$(command -v jq) || exit 2
TOFI=$(command -v tofi) || exit 3

MODE="${1:-switch}"

NAME="$(
  $NIRI msg --json workspaces |
      $JQ -r '.[] | select(.active_window_id != null) | (.name // (.idx | tostring))' |
  sort -u |
  $TOFI \
    -c "$HOME/.config/tofi/tofi_run_theme" \
    --anchor=bottom \
    --margin-bottom=26 \
    --prompt-text=" ${MODE}: "
)"

[[ -z "$NAME" ]] && exit 0

CURRENT="$($NIRI msg --json windows | $JQ -M '.[] | select(.is_focused) | .id')"

# Existence test
if $NIRI msg --json workspaces | $JQ -e --arg name "$NAME" '.[] | select(.name == $name)' >/dev/null; then
    if [[ "$MODE" == "move" ]]; then
        $NIRI msg action move-window-to-workspace "$NAME"
    else
        $NIRI msg action focus-workspace "$NAME"
    fi
else
    $NIRI msg action focus-workspace $($NIRI msg --json workspaces | $JQ -M '. | length')
    $NIRI msg action set-workspace-name "$NAME"

    if [[ "$MODE" == "move" ]]; then
        $NIRI msg action focus-window --id $CURRENT
        niri msg action move-window-to-workspace "$NAME"
    fi
fi
