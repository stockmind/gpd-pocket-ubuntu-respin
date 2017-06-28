#!/bin/bash

ISOFILE=$1

if [ ! -f linux-image* ]; then
    echo "Kernel image not found"

    if [ ! -f gpdpocket-kernel-wifi-sound-display.zip ]; then
    	echo "Download kernel files"
    	wget -O gpdpocket-kernel-wifi-sound-display.zip https://www.dropbox.com/s/fgohikbsb9aehyu/gpdpocket-kernel-wifi-sound-display.zip?dl=1 
    fi

    echo "Extracting kernel files..."
    unzip -o gpdpocket-kernel-wifi-sound-display.zip
fi

if [ ! -d gpdfand ]; then
	echo "Gpdfand folder missing. Donwloading it..."
	git clone https://github.com/efluffy/gpdfand.git
fi

echo "Overwrite working monitors.xml"
rm monitors.xml
cp monitors_working.xml monitors.xml

if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE -l "*.deb" -p "libproc-daemon-perl libproc-pid-file-perl liblog-dispatch-perl thermald va-driver-all vainfo i965-va-driver gstreamer1.0-libav gstreamer1.0-plugins-bad-faad gstreamer1.0-vaapi" -f 90x11-rotate_and_scale -f HiFi.conf -f chtrt5645.conf -f brcmfmac4356-pcie.txt -f wrapper-fix-sound-wifi.sh -f wrapper-rotate-and-scale.sh -f gpdfand/gpdfand -f gpdfand/gpdfand.pl -f gpdfand/gpdfand.service -f wrapper-gpd-fan-control.sh -f monitors.xml -f adduser.local -f 20-intel.conf -c wrapper-rotate-and-scale.sh -c wrapper-fix-sound-wifi.sh -c wrapper-gpd-fan-control.sh -g "i915.fastboot=1 fbcon=rotate:1"




