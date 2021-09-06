#!/bin/sh

revert() {
    xset dpms 0 0 0
    xset -dpms
}

trap revert HUP INT TERM
xset +dpms dpms 15 15 15
i3lock -n -e -i /home/achuie/.lockscreen.png
revert
