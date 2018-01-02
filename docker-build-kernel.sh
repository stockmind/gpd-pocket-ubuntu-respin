#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
# Source basic functions
source "$SCRIPTPATH"/utils.sh

INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"

print_details "Input dir:" "$INPUTDIR"
print_details "Output dir:" "$OUTPUTDIR"

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

# If no arg specified we use the custom kernel config provided in this repository
if [ "$1" != 'keepconfig' ]; then
	cp "$SCRIPTPATH"/kernel/.config "$INPUTDIR"/.config
fi

# Refresh container
OLDCONTAINER=$(docker ps -aq --filter name=gpd-pocket-kernel-container)
if [ $OLDCONTAINER != "" ]; then
	docker rm $(docker ps -aq --filter name=gpd-pocket-kernel-container)
fi

IMAGENAME="gpd-pocket-ubuntu-respin-test"

# Run command
docker run -t -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --name gpd-pocket-kernel-container "$IMAGENAME" kernel
