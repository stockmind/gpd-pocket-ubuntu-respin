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
	cd kernel-build
    else
    	# Update them if already there
	cd kernel-build
    	git fetch origin
	git reset --hard origin/master
    fi

    # If a config file is provided in input we will use that for kernel building
    if [ -f /docker-input/.config ]; then
    	echo "Using custom kernel config..."
    	cp /docker-input/.config .config
    fi

    # patch kernel config for audio crackling
    # echo "Patch audio config"
    # sed -i "s|CONFIG_INTEL_ATOMISP=y|CONFIG_INTEL_ATOMISP=n|" .config

    CPUS=$(getconf _NPROCESSORS_ONLN)
    CPUS=$(($CPUS*2+1))
    echo "Processors in use for build $CPUS"

    # Build kernel
    make clean
	make -j"$CPUS" deb-pkg LOCALVERSION=-stockmind-gpdpocket  

	cd ..
	# Remove possible old files
	rm -f "gpdpocket-kernel-files.zip"

	# Try to extract kernel version
	KERNELIMAGE=$(ls linux-image-* | head -1)
	KERNELVERSION=$(echo "$KERNELIMAGE" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+(-rc[0-9]+)?" | head -1)

	# Compress kernel files
	zip "gpdpocket-kernel-files.zip" *.deb
	# Delete old deb files
	rm -f *.deb

	LABEL=""
	NOW=$(date +"%Y%m%d")

	if [ -n "$KERNELVERSION" ]; then
		LABEL="$NOW-$KERNELVERSION"
	else
		LABEL="$NOW"
	fi

	mv "gpdpocket-kernel-files.zip" "/docker-output/gpdpocket-""$LABEL""-kernel-files.zip"

	if [ "$2" = 'keepkernel' ]; then
		echo "Copy kernel for future respins"
		cp "/docker-output/gpdpocket-""$LABEL""-kernel-files.zip" "/docker-input/gpdpocket-""$LABEL""-kernel-files.zip"
	fi
	
	exit 0
fi

if [ "$1" = 'respin' ]; then

	if [ -z "$2" ]; then
		echo "An iso image must be selected!"
		exit 1
	else
		# If node is not present
		if [ -d /dev/loop0 ]; then
			# Make node for respin
			mknod /dev/loop0 b 7 0
		fi

		cd gpd-pocket-ubuntu-respin

		git pull origin master

		echo "Images found in folder:"
		ls /docker-input/

		# Use a local kernel zip if provided
		if [ -f /docker-input/gpdpocket-*kernel-files.zip ]; then
			cp /docker-input/gpdpocket-*kernel-files.zip ./gpdpocket-kernel-files.zip
			echo "Local kernel found!"
		else
			echo "No local kernel found!"
		fi	

		echo "Starting process..."

		LABEL=""

		# argument setted?
		if [ -z "$3" ]; then
			./build.sh "/docker-input/$2" 
		else
			./build.sh "/docker-input/$2" $3

			if [ "$3" = 'unity' ]; then
				echo "Setting unity label..."
				LABEL+="unity-"
			fi
		fi

		# Try to extract kernel version
		KERNELIMAGE=$(ls linux-image-* | head -1)
		KERNELVERSION=$(echo "$KERNELIMAGE" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+(-rc[0-9]+)?" | head -1)

		FILE=$2
		# Remove path from file
		FILECLEAN="${FILE##*/}"
		# Today date
		NOW=$(date +"%Y%m%d")

		if [ -n "$KERNELVERSION" ]; then
			LABEL+="$NOW-$KERNELVERSION"
		else
			LABEL+="$NOW"
		fi

    	mv linuxium-* "/docker-output/gpdpocket-$LABEL-$FILECLEAN"
	fi
	
	exit 0
fi
