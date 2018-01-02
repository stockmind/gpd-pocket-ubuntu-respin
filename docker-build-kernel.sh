#!/bin/bash

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"

echo "Input dir: $INPUTDIR"
echo "Output dir: $OUTPUTDIR"

if $(docker image inspect stockmind/gpd-pocket-ubuntu-respin:latest >/dev/null 2>&1); then
	echo "Found Docker Hub image!"
	IMAGENAME="stockmind/gpd-pocket-ubuntu-respin"
elif $(docker image inspect gpd-pocket-ubuntu-respin:latest >/dev/null 2>&1); then
	echo "Found local image!"
	IMAGENAME="gpd-pocket-ubuntu-respin"
else
	echo "Build docker image or download it from Docker Hub!"
	exit 1
fi

# If no arg specified we use the custom kernel config provided in this repository
if [ "$1" != 'keepconfig' ]; then
	cp "$SCRIPTPATH"/kernel/.config "$INPUTDIR"/.config
fi

# Refresh container
docker rm $(docker ps -aq --filter name=gpd-pocket-kernel-container)
# Run command
docker run -t -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --name gpd-pocket-kernel-container "$IMAGENAME" kernel
