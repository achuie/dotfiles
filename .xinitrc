#!/usr/bin/bash

xrdb -load .Xresources

compton --config /home/achuie/.config/compton/config &

xset -dpms
xset s off

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx

#bash /home/achuie/.screenlayout/default.sh
bash /home/achuie/.fehbg

clipit -n &

exec i3
