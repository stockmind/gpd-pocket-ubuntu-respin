#!/bin/bash

ISOFILE=$1

# Check arguments
for i in "$@" ; do
    if [[ $i == "gnome" ]] ; then
        echo "Setting gnome monitors..."
        GNOME=$i
        break
    fi
    if [[ $i == "kali" ]] ; then
    	echo "Setting kali environment..."	
    	KALI=true
    	break
    fi	
done

if [ -n "$GNOME" ]; then
	echo "Display setting: Gnome"
	cp display/monitors_gnome.xml display/monitors.xml
else
	echo "Display setting: Xorg-Standard"
	cp display/monitors_xorg.xml display/monitors.xml
fi

./clean.sh

if [ ! -f linux-image* ]; then
    echo "Looking for kernel image..."
    if [ ! -f gpd-pocket-kernel-files.zip ]; then
	 if [ ! -f gpdpocket-20180115-kernel-files.zip ]; then
	    echo "Downloading kernel files...."
	    wget https://bitbucket.org/simone_nunzi/gpdpocket-kernel/downloads/gpdpocket-20180115-kernel-files.zip
	fi
	echo "Extracting kernel files..."
    	unzip -o gpdpocket-20180115-kernel-files.zip
    else	    
        echo "Extracting custom kernel files..."
        unzip -o gpd-pocket-kernel-files.zip
    fi	
fi

if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

packages="xfonts-terminus "
packages+="thermald "
packages+="tlp "
packages+="va-driver-all "
packages+="vainfo "
packages+="libva1 "
packages+="i965-va-driver "
packages+="gstreamer1.0-libav "
packages+="gstreamer1.0-vaapi "
packages+="vlc "
packages+="python-gi "
packages+="gksu "
packages+="git "
packages+="python "
packages+="gir1.2-appindicator3-0.1"

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
	-l "*.deb" \
	-e "bcmwl-kernel-source" \
	-p "$packages" \
	-f display/20-intel.conf \
	-f display/30-monitor.conf \
	-f display/35-screen.conf \
	-f display/40-touch.conf \
	-f display/40-trackpoint.conf \
	-f display/console-setup \
	-f display/monitors.xml \
	-f display/adduser.local \
	-f display/90-scale \
	-f display/90-interface \
	-f display/wrapper-display.sh \
	-f audio/chtrt5645.conf \
	-f audio/HiFi.conf \
	-f audio/headphone-jack \
	-f audio/headphone-jack.sh \
	-f audio/wrapper-audio.sh \
	-f fan/gpdfand \
	-f fan/gpdfand.conf \
	-f fan/gpdfand.py \
	-f fan/gpdfand.service \
	-f fan/wrapper-fan.sh \
	-f network/99-local-bluetooth.rules \
	-f network/brcmfmac4356-pcie.txt \
	-f network/wrapper-network.sh \
	-f power/wrapper-power.sh \
	-c wrapper-audio.sh \
	-c wrapper-display.sh \
	-c wrapper-fan.sh \
	-c wrapper-network.sh \
	-c wrapper-power.sh \
	-g "" \
	-g "i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1"
