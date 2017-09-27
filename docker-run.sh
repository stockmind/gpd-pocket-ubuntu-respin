#!/bin/bash

# Refresh container
./docker-respin.sh $1
# Run command
docker attach gpd-pocket-respin-container