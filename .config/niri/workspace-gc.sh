#!/usr/bin/env bash

# Remove empty named workspaces.

set -euo pipefail

cleanup() {
    niri msg --json workspaces |
    jq -r '
        .[]
        | select(
            .name != null and
            (.name | startswith("@") | not) and
            .active_window_id == null and
            .is_focused == false
        )
        | .name
    ' |
    while read -r name
    do
        niri msg action unset-workspace-name "$name"
    done
}

cleanup

niri msg event-stream |
while read -r _
do
    cleanup
done
