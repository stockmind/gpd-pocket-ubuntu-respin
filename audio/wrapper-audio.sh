#!/bin/bash

cd /usr/local/bin

mkdir -p /usr/share/alsa/ucm/chtrt5645
cp HiFi.conf /usr/share/alsa/ucm/chtrt5645/
cp chtrt5645.conf /usr/share/alsa/ucm/chtrt5645/

# set audio output
echo "set-card-profile alsa_card.platform-cht-bsw-rt5645 HiFi" >> /etc/pulse/default.pa
echo "set-default-sink alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink" >> /etc/pulse/default.pa
echo "set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink [Out] Speaker" >> /etc/pulse/default.pa

echo "realtime-scheduling = no" >> /etc/pulse/daemon.conf

rm -f HiFi.conf chtrt5645.conf wrapper-audio.sh
