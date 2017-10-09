#!/bin/bash

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"

if [[ $(docker inspect --type=image stockmind/gpd-pocket-ubuntu-respin) == 0 ]]; then
	echo "Found Docker Hub image!"
	IMAGENAME="stockmind/gpd-pocket-ubuntu-respin"
elif [[ $(docker inspect --type=image gpd-pocket-ubuntu-respin) == 0 ]]; then
	echo "Found local image!"
	IMAGENAME="gpd-pocket-ubuntu-respin"
else
	echo "Docker image not found! Build docker image or download it from Docker Hub!"
	exit 1
fi

echo "Input dir: $INPUTDIR"
echo "Output dir: $OUTPUTDIR"

# Refresh container
docker rm $(docker ps -aq --filter name=gpd-pocket-respin-container)
# Run command
docker run -t --cap-add MKNOD -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --privileged --name gpd-pocket-respin-container "$IMAGENAME" respin $1
