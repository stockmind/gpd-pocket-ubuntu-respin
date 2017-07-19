#!/bin/bash

ISOFILE=$1
WAYLAND=$2

if [ -n "$WAYLAND" ]; then
	echo "Display setting: Wayland"
	cp display/monitors_wayland.xml display/monitors.xml
else
	echo "Display setting: Xorg"
	cp display/monitors_xorg.xml display/monitors.xml
fi

./clean.sh

if [ ! -f linux-image* ]; then
    echo "Kernel image not found"

    if [ ! -f gpdpocket-kernel-files-17072017.zip ]; then
	echo ""
	echo ""
	echo "###### WARNING KERNEL FILES MISSING! ######"
    	echo "Download kernel files zip from this link: "
	echo "http://ge.tt/85TkCpl2"
	echo "And put it on the build.sh folder."
	echo "###########################################"
	exit 1;
    fi

    echo "Extracting kernel files..."
    unzip -o gpdpocket-kernel-files-17072017.zip
fi

if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE -l "*.deb" -p "thermald tlp va-driver-all vainfo libva1 i965-va-driver gstreamer1.0-libav gstreamer1.0-vaapi vlc" -f display/20-intel.conf -f display/30-monitor.conf -f display/monitors.xml -f display/adduser.local -f display/90-scale -f display/90-touch -f display/gpdtouch.sh -f display/gpdtouch.service -f display/wrapper-display.sh -f audio/chtrt5645.conf -f audio/HiFi.conf -f audio/wrapper-audio.sh -f fan/gpdfand -f fan/gpdfand.conf -f fan/gpdfand.py -f fan/gpdfand.service -f fan/wrapper-fan.sh -f network/99-local-bluetooth.rules -f network/brcmfmac4356-pcie.txt -f network/wrapper-network.sh -f power/wrapper-power.sh -c wrapper-audio.sh -c wrapper-display.sh -c wrapper-fan.sh -c wrapper-network.sh -c wrapper-power.sh -g "" -g "i915.fastboot=1 i915.semaphores=1"




