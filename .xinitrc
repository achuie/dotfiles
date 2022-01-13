#!/usr/bin/bash

xrdb -load .Xresources

picom -b --experimental-backends --config /home/achuie/.config/picom/picom.conf

xset -dpms
xset s off

export GDK_DPI_SCALE=1.5
export QT_SCALE_FACTOR=1.5

export TERMINAL=alacritty

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx

bash /home/achuie/.screenlayout/default.sh
bash /home/achuie/.fehbg

dunst &

exec i3
