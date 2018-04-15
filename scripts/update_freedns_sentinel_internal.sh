#!/bin/bash

ADDR=$(ip addr | grep inet | grep enp0s31f6 | awk '{print $2}' | cut --delimiter=/ --fields=1)
/usr/bin/wget --read-timeout=0 - http://freedns.afraid.org/dynamic/update.php?bzFzY0o3SVVtVHFnMk9OQmt4c3BTTmlkOjE3MjU5MTA1\&address=$ADDR #>> /tmp/freedns_sentinel_pwnz_org.log 2>&1
rm update.php*
