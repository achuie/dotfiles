#!/usr/bin/env bash

revert() {
    xset dpms 0 0 0
    xset -dpms
}

trap revert HUP INT TERM
xset +dpms dpms 15 15 15

if [ ! -e "${HOME}/.lockscreen.png" ]; then
    wall="$(tail -n 1 ${HOME}/.fehbg | sed "s/[^']*'//" | sed "s/' //")"
    convert "$wall" -resize 2256x2256 -blur 0x48 "${HOME}/.lockscreen.png"
fi

i3lock --nofork --ignore-empty-password \
    --radius 40 --ring-width 10 --indicator --ind-pos="550:y+h-180" \
    --color=000000ff \
    --inside-color=15151800 --ring-color=f4f4f4f0 --line-color=e8e8e800 --keyhl-color=181818a0 \
    --ringver-color=f4f4f4ff --insidever-color=30303000 \
    --ringwrong-color=f4f4f4f0 --insidewrong-color=404040a8 \
    --verif-text=" " --wrong-text=" " \
    --verif-color=00000000 --wrong-color=00000000 \
    --clock --time-pos="ix-250:iy+5" --date-pos="ix-250:ty+60" \
    --time-color=f4f4f4f0 --time-size=80 --time-str="%H:%M:%S" \
    --date-color=f4f4f4f0 --date-size=45 --date-str="%a %Y-%m-%d" \
    -i "${HOME}/.lockscreen.png"

revert
