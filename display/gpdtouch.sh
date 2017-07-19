#!/usr/bin/env bash

# determine necessary variables
DISPLAY=:${1}
XAUTHORITY=$(ps aux |grep -e Xorg | head -n1 | awk '{ split($0, a, "-auth "); split(a[2], b, " "); print b[1] }')
export DISPLAY XAUTHORITY

$SEARCH="Goodix Capacitive Touchscreen"

ids=$(xinput --list | awk -v search="$SEARCH" \
    '$0 ~ search {match($0, /id=[0-9]+/);\
                  if (RSTART) \
                    print substr($0, RSTART+3, RLENGTH-3)\
                 }'\
     )

# Rotate every instance of Touchscreen, this will workaround the ambiguity warning problem
# that arise when calling xinput on "Goodix Capacitive Touchscreen"
for i in $ids
do
    xinput set-prop $i "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
done


