#!/bin/bash

ISOFILE=$1
LATESTKERNEL="gpdpocket-20180911-4.18.0-rc8-kernel-files.zip"
LOCALKERNEL="gpdpocket-kernel-files.zip"
KERNELARGS="-l \"*.deb\""
ARGS=""

# Check arguments
for i in "$@" ; do
    if [[ $i == "gnome" ]] ; then
        echo "Setting gnome monitors..."
        GNOME=true
        continue
    fi
    if [[ $i == "unity" ]] ; then
    	echo "Setting unity environment..."	
    	UNITY=true
    	continue
    fi	
    if [[ $i == "bionicbeaver" ]] ; then
    	echo "Setting Bionic Beaver environment..."	
    	BIONICBEAVER=true
    	continue
    fi	
    if [[ $i == "mainline" ]] ; then
    	echo "Setting mainline kernel environment..."	
    	KERNELARGS="-u"
    	MAINLINE=true
    	continue
    fi		
    if [[ $i == "upgrade" ]] ; then
    	echo "Upgrade ISO packages..."
    	ARGS="--upgrade"
    	continue
    fi	
done

# Select correct monitors file based on Desktop Environment kind
# GNOME or Desktop Environments on Wayland require a special monitors file
if [ -n "$GNOME" ]; then
	echo "Display setting: Gnome"
	cp display/monitors_gnome.xml display/monitors.xml
else
	echo "Display setting: Xorg-Standard"
	cp display/monitors_xorg.xml display/monitors.xml
fi

# Remove old files
./clean.sh

# Looking for kernel packages and download them if required
if [ ! -f linux-image* ]; then
	if [ ! -n "$MAINLINE" ]; then
	    echo "Looking for kernel image..."
	    if [ ! -f "$LOCALKERNEL" ]; then
			if [ ! -f "$LATESTKERNEL" ]; then
				echo "Downloading kernel files...."
				wget "https://bitbucket.org/simone_nunzi/gpdpocket-kernel/downloads/$LATESTKERNEL"
			fi
			echo "Extracting latest kernel files..."
		    unzip -o "$LATESTKERNEL"
	    else	    
	        echo "Extracting custom kernel files..."
	        unzip -o "$LOCALKERNEL"
	    fi	
	fi
fi

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

# Packages that will be installed:
# Font used to scale TTY text to a resonable size during boot/TTY work
installpackages="xfonts-terminus "
# Thermal management stuff and packages
installpackages+="thermald "
installpackages+="tlp "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all "
installpackages+="vainfo "

if [ -n "$BIONICBEAVER" ]; then
	installpackages+="libva2 "
else
	installpackages+="libva1 "
fi

installpackages+="i965-va-driver "
installpackages+="gstreamer1.0-libav "
installpackages+="gstreamer1.0-vaapi "
# Useful music/video player with large set of codecs
installpackages+="vlc "
# Utilities for traybar rotation indicator and fan handling
installpackages+="python-gi " # Required by traybar rotation indicator
installpackages+="git " # Required by traybar rotation indicator to download repository
installpackages+="python " # Required by traybar rotation indicator & fan script
installpackages+="gir1.2-appindicator3-0.1 " # Required by traybar rotation indicator

# Packages that will be removed:
removepackages="bcmwl-kernel-source " # This may conflict with wifi provided driver and blacklist it

# If Unity is requested, install it and remove other Display Manager to avoid conflicts
if [ -n "$UNITY" ]; then
	echo "Display setting: Unity"

	installpackages+="unity "
	installpackages+="lightdm "

	removepackages+="gdm "
	removepackages+="gdm3 "
	removepackages+="sddm "
fi

chmod +x isorespin.sh

sync

./isorespin.sh $ARGS $KERNELARGS -i $ISOFILE \
	-e "$removepackages" \
	-p "$installpackages" \
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
	-g "i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1 gpd-pocket-fan.speed_on_ac=0"
