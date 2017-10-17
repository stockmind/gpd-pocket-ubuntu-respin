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

# copy headphones/speakers auto switch when jack is plugged in/out
cp headphone-jack /etc/acpi/events/headphone-jack
cp headphone-jack.sh /etc/acpi/headphone-jack.sh
chmod +x /etc/acpi/headphone-jack.sh

rm -f HiFi.conf chtrt5645.conf headphone-jack headphone-jack.sh wrapper-audio.sh
