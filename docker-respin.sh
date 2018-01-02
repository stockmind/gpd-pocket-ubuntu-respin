#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
# Source basic functions
source "$SCRIPTPATH"/utils.sh

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"

if $(docker image inspect stockmind/gpd-pocket-ubuntu-respin:latest >/dev/null 2>&1); then
	print_info "Found Docker Hub image!"
	IMAGENAME="stockmind/gpd-pocket-ubuntu-respin"
elif $(docker image inspect gpd-pocket-ubuntu-respin:latest >/dev/null 2>&1); then
	print_info "Found local image!"
	IMAGENAME="gpd-pocket-ubuntu-respin"
else
	print_error "Build docker image or download it from Docker Hub!"
	exit 1
fi

IMAGENAME="gpd-pocket-ubuntu-respin-test"

print_details "Image name:" "$IMAGENAME"
print_details "Input dir:" "$INPUTDIR"
print_details "Output dir:" "$OUTPUTDIR"

# Refresh container
OLDCONTAINER=$(docker ps -aq --filter name=gpd-pocket-respin-container)
if [ $OLDCONTAINER != "" ]; then
	docker rm $(docker ps -aq --filter name=gpd-pocket-respin-container)
fi

# Run command
docker run -t --cap-add MKNOD -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --privileged --name gpd-pocket-respin-container "$IMAGENAME" respin $1 $2
