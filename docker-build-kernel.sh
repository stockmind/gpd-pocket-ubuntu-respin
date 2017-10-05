#!/bin/bash

# Find current directory
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
INPUTDIR="$SCRIPTPATH""/origin"
OUTPUTDIR="$SCRIPTPATH""/destination"

echo "Input dir: $INPUTDIR"
echo "Output dir: $OUTPUTDIR"

# Refresh container
docker rm $(docker ps -aq --filter name=gpd-pocket-kernel-container)
# Run command
docker run -t -v "$INPUTDIR":/docker-input -v "$OUTPUTDIR":/docker-output --name gpd-pocket-kernel-container gpd-pocket-ubuntu-respin kernel