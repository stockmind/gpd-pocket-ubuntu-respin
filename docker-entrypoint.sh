#!/bin/bash
set -e

echo $(ip r)

DEFAULT_GATEWAY=`ip r | grep default | cut -d ' ' -f 3`
echo "Gateway: $DEFAULT_GATEWAY"

if ( ! ping -q -w 1 -c 1 "${DEFAULT_GATEWAY}" > /dev/null 2>&1 ); then
	echo "Internet test failed."
	echo "RESULT:"
	ping -q -w 1 -c 1 "${DEFAULT_GATEWAY}"
else
	echo "Internet test passed."
fi

if [ "$1" = 'kernel' ]; then
	# Check if kernel sources have already been downloaded
	if [ ! -d kernel-build ]; then
		# Download them if missing
    	git clone https://github.com/jwrdegoede/linux-sunxi.git ./kernel-build
    else
    	# Update them if already there
    	git fetch origin
		git reset --hard origin/master
	fi

    cd kernel-build

    CPUS=$(getconf _NPROCESSORS_ONLN)
    echo "Processors in use for build $CPUS"

    # Build kernel
    make clean
	make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-gpdpocket  

	cd ..
	# Remove possible old files
	rm -f "gpdpocket-kernel-files.tar.gz"
	# Compress kernel files
	tar -czvf "gpdpocket-kernel-files.tar.gz" *.deb
	# Delete old deb files
	rm -f *.deb

	NOW=$(date +"%Y%m%d")
	mv "gpdpocket-kernel-files.tar.gz" "/docker-output/gpdpocket-""$NOW""-kernel-files.tar.gz"
fi

if [ "$1" = 'respin' ]; then

	if [ -z "$2" ]; then
		echo "An iso image must be selected!"
	else
		# Make node for respin
		mknod /dev/loop0 b 7 0

		cd gpd-pocket-ubuntu-respin
		echo "Images found in folder:"
		ls /docker-input/

		echo "Starting process..."

		# gnome argument setted?
		if [ -z "$3"]; then
			./build.sh "/docker-input/$2" 
		else
			./build.sh "/docker-input/$2" gnome
		fi
		
    	mv linuxium-* /docker-output/
	fi
fi

exec "$@"