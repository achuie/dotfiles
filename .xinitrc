#!/usr/bin/bash

xrdb -load .Xresources

compton -b --config /home/achuie/.config/compton/config

xset -dpms
xset s off

bash /home/achuie/.screenlayout/default.sh
bash /home/achuie/.fehbg

clipit -n &

exec i3
