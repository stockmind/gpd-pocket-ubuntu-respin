#!/bin/bash

ISOFILE=$1
KALI=false
KALICOMMANDS=""

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

if [ "$KALI" = true ]; then
	if [ ! -d katoolin ]; then
		echo "Downloading katoolin repo..."
		git clone https://github.com/LionSec/katoolin.git
	fi

	cd katoolin
	echo "Update katoolin repo..."
	git pull

	$KALICOMMANDS=' -f distro/katoolin.sh -c katoolin.sh '

	cd ..
fi

./clean.sh

if [ ! -f linux-image* ]; then
    echo "Looking for kernel image..."
    if [ ! -f gpd-pocket-kernel-files.zip ]; then
	 if [ ! -f gpdpocket-20170921-kernel-files.zip ]; then
	    echo "Downloading kernel files...."
	    wget https://bitbucket.org/simone_nunzi/gpdpocket-kernel/downloads/gpdpocket-20170921-kernel-files.zip
	fi
	echo "Extracting kernel files..."
    	unzip -o gpdpocket-20170921-kernel-files.zip
    else	    
        echo "Extracting custom kernel files..."
        unzip -o gpd-pocket-kernel-files.zip
    fi	
fi

if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE -l "*.deb" -e "bcmwl-kernel-source" -p "xfonts-terminus thermald tlp va-driver-all vainfo libva1 i965-va-driver gstreamer1.0-libav gstreamer1.0-vaapi vlc python-gi gksu git python gir1.2-appindicator3-0.1" -f display/20-intel.conf -f display/30-monitor.conf -f display/35-screen.conf -f display/40-touch.conf -f display/40-trackpoint.conf -f display/console-setup -f display/monitors.xml -f display/adduser.local -f display/90-scale -f display/90-interface -f display/wrapper-display.sh -f audio/chtrt5645.conf -f audio/HiFi.conf -f audio/wrapper-audio.sh -f fan/gpdfand -f fan/gpdfand.conf -f fan/gpdfand.py -f fan/gpdfand.service -f fan/wrapper-fan.sh -f network/99-local-bluetooth.rules -f network/brcmfmac4356-pcie.txt -f network/wrapper-network.sh -f power/wrapper-power.sh -c wrapper-audio.sh -c wrapper-display.sh -c wrapper-fan.sh -c wrapper-network.sh -c wrapper-power.sh $KALICOMMANDS -g "" -g "i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1"
