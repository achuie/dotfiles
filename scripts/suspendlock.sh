#!/usr/bin/env bash

HYPRLOCK=$(command -v hyprlock) || exit 1

$HYPRLOCK >/dev/null & disown && sleep 1; systemctl suspend
