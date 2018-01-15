#!/usr/bin/env bash
set -e

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
# Source basic functions
source "$SCRIPTPATH"/utils.sh

DEFAULT_GATEWAY=`ip r | grep default | cut -d ' ' -f 3`
print_details "Gateway: $DEFAULT_GATEWAY"

if ( ! ping -q -w 1 -c 1 "${DEFAULT_GATEWAY}" > /dev/null 2>&1 ); then
	print_error "Internet test failed."
	print_details "RESULT:"
	ping -q -w 1 -c 1 "${DEFAULT_GATEWAY}"
else
	print_success "Internet test passed."
fi

if [ "$1" = 'kernel' ]; then
    # Check if kernel sources have already been downloaded
    if [ ! -d kernel-build ]; then
	# Download them if missing
    	git clone https://github.com/jwrdegoede/linux-sunxi.git ./kernel-build
	cd kernel-build
    else
    	# Update them if already there
	cd kernel-build
    	git fetch origin
	git reset --hard origin/master
    fi

    # If a config file is provided in input we will use that for kernel building
    if [ -f /docker-input/.config ]; then
    	print_details "Using custom kernel config..."
    	cp /docker-input/.config .config
    fi

    # patch kernel config for audio crackling
    # echo "Patch audio config"
    # sed -i "s|CONFIG_INTEL_ATOMISP=y|CONFIG_INTEL_ATOMISP=n|" .config

    CPUS=$(getconf _NPROCESSORS_ONLN)
    CPUS=$(($CPUS*2+1))
    print_details "Processors in use for build $CPUS"

    # Build kernel
    make clean
	make -j"$CPUS" deb-pkg LOCALVERSION=-stockmind-gpdpocket  

	cd ..
	# Remove possible old files
	rm -f "gpdpocket-kernel-files.zip"
	# Compress kernel files
	zip "gpdpocket-kernel-files.zip" *.deb
	# Delete old deb files
	rm -f *.deb

	NOW=$(date +"%Y%m%d")
	mv "gpdpocket-kernel-files.zip" "/docker-output/gpdpocket-""$NOW""-kernel-files.zip"
	
	exit 0
fi

if [ "$1" = 'respin' ]; then

	if [ -z "$2" ]; then
		print_error "An iso image must be selected!"
		exit 1
	else
		# If node is not present
		if [ -d /dev/loop0 ]; then
			# Make node for respin
			mknod /dev/loop0 b 7 0
		fi

		cd gpd-pocket-ubuntu-respin

		git pull origin interactive

		print_details "Images found in folder:"
		ls /docker-input/

		# If a custom kernel is present in origin folder we use that for respin the image
		if [ -f /docker-input/gpd-pocket-kernel-files.zip ]; then
			cp /docker-input/gpd-pocket-kernel-files.zip ./gpd-pocket-kernel-files.zip
		fi

		print_details "Starting process..."

		# gnome argument setted?
		if [ -z "$3" ]; then
			./build.sh "/docker-input/$2" 
		else
			./build.sh "/docker-input/$2" gnome
		fi

		FILE=$2
		# Remove path from file
		FILECLEAN="${FILE##*/}"
		# Today date
		NOW=$(date +"%Y%m%d")

    	mv linuxium-* "/docker-output/gpdpocket-$NOW-$FILECLEAN"
	fi
	
	exit 0
fi

exec "$@"
