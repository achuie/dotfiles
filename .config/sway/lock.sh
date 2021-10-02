#!/bin/sh

revert() {
    pkill swayidle
}

trap revert HUP INT TERM
exec swayidle \
    timeout 15 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &

swaylock -e --font "Fira Code Light" --font-size 18 --indicator-radius 75 \
    -li $HOME/images/wallpapers/aspen_woods.jpg

revert
