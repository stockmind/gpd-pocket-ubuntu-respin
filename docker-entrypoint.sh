#!/bin/bash
set -e

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
		cd gpd-pocket-ubuntu-respin

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