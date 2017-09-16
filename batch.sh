#!/bin/bash

# Generate iso in batch from folder

mkdir -p origin
mkdir -p destination

# Exec as root
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Remove *.iso from found files
shopt -s nullglob
for FILE in origin/*.iso; do

	NOW=$(date +"%Y%m%d")

	# Remove path from file
	FILECLEAN="${FILE##*/}"
	# Find extension
	FILEXT="${FILECLEAN##*.}"
	# Get file name without extension, look until last dot
	FILENAME="${FILECLEAN%.*}"
	echo $FILENAME
	# No spaces
	FILENAME="${FILENAME// /-}"
	echo $FILENAME
	# Only one dash
	FILENAME="$(echo $FILENAME | tr -s '-')"
	# Sanitize name
	FILENAME="${FILENAME//[^[:alnum:]_-]/}"

	if [[ $FILENAME == *"gnome"* ]] || [[ $FILENAME == *"elementary"* ]]; then
		echo "Gnome ISO"
		./build.sh "$FILE" gnome
	else
		echo "Standard ISO"	
		./build.sh "$FILE" 
	fi

	mv "linuxium-$FILECLEAN" "destination/gpdpocket-$NOW-$FILECLEAN"
done
