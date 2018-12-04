#!/bin/bash

# Run with sudo

reflector --verbose --latest 40 --number 10 --sort rate --protocol http --save /etc/pacman.d/mirrorlist
exit 0
