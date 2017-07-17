#!/bin/sh

sleep 5

export XAUTHORITY=$(ps aux |grep -e Xorg | head -n1 | awk '{ split($0, a, "-auth "); split(a[2], b, " "); print b[1] }')

DISPLAY=:0 xrandr --output DSI1 --rotate right >/dev/null 2>&1
DISPLAY=:1 xrandr --output DSI1 --rotate right >/dev/null 2>&1
