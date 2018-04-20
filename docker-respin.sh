#!/bin/bash

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"
ORIGINDIR="origin/"
ISO=${1#$ORIGINDIR} # Remove 'origin/' prefix path if found

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

echo "Iso: $ISO"
echo "Input dir: $INPUTDIR"
echo "Output dir: $OUTPUTDIR"

# Refresh container
docker rm $(docker ps -aq --filter name=gpd-pocket-respin-container)
# Run command
docker run -t --cap-add MKNOD -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --privileged --name gpd-pocket-respin-container "$IMAGENAME" respin $ISO "${@:2}"
