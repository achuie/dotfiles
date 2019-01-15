#!/bin/bash

tmux new -s music \; send-keys "ncmpcpp" Enter \; split-window -h \; \
send-keys "ncmpcpp" Enter 8 \; split-window -v \; send-keys "ncmpcpp" Enter 4 \
\; attach
