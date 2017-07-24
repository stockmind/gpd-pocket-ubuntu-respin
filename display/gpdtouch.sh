#!/usr/bin/env bash

# determine necessary variables
DISPLAY=:0
XAUTHORITY=$(ps aux |grep -e Xorg | head -n1 | awk '{ split($0, a, "-auth "); split(a[2], b, " "); print b[1] }')
export DISPLAY XAUTHORITY

# try at least 3 times to set correct transformation matrix
for k in `seq 1 3`;
do 
	echo "trying $k..."
	SEARCH="Goodix Capacitive TouchScreen"

	id=$(xinput list --id-only pointer:"Goodix Capacitive TouchScreen")

	# Rotate every instance of Touchscreen, this will workaround the ambiguity warning problem
	# that arise when calling xinput on "Goodix Capacitive Touchscreen"
	xinput set-prop $id "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	
	# try also to rotate display if monitors file gets ignored
	xrandr --output DSI1 --rotate right

	sleep 5
	# wait for X loading on every try
done   
