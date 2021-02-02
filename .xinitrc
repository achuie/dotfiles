#!/usr/bin/bash

xrdb -load .Xresources

picom -b --experimental-backends --config /home/achuie/.config/picom/picom.conf

xset -dpms
xset s off

export TERMINAL=st

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx

bash /home/achuie/.screenlayout/default.sh
bash /home/achuie/.fehbg

exec i3
