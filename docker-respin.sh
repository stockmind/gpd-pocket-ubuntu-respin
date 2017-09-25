#!/bin/bash

docker run -d -v origin:/docker-input -v destination:/docker-output --name gpd-pocket-respin-container gpd-pocket-ubuntu-respin respin $1