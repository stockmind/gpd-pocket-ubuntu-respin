#!/bin/bash

cd /usr/local/bin

mkdir -p /usr/share/alsa/ucm/chtrt5645
cp HiFi.conf /usr/share/alsa/ucm/chtrt5645/
cp chtrt5645.conf /usr/share/alsa/ucm/chtrt5645/

cp brcmfmac4356-pcie.txt /lib/firmware/brcm/

rm -f brcmfmac4356-pcie.txt HiFi.conf chtrt5645.conf wrapper-fix-sound-wifi.sh
