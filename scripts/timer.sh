#!/bin/bash

# A program to play a tone at the end of an interval.
#
# Usage:
#   timer.sh <seconds>

sleep $1
sudo beep -r 2
# mplayer /usr/share/sounds/freedesktop/stereo/phone-outgoing-calling.oga

exit 0
