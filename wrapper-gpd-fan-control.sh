#!/bin/bash

cd /usr/local/bin

# load modules into initramfs make tools to include on boot
echo "pwm-lpss" >> /etc/initramfs-tools/modules
echo "pwm-lpss-platform" >> /etc/initramfs-tools/modules
echo "btusb" >> /etc/initramfs-tools/modules

# bluetooth enable
cp 99-local-bluetooth.rules /etc/udev/rules.d/99-local-bluetooth.rules

# update grub config
echo "Update grub default..."
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable\"/" /etc/default/grub

# add wifi module for sleep
mkdir -p /etc/pm/config.d/
touch /etc/pm/config.d/config
echo "SUSPEND_MODULES=\"brcmfmac\"" >> /etc/pm/config.d/config

# set audio output
pacmd set-default-sink "alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink"
sed -i "s/; default-sink =/default-sink = alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink/" /etc/pulse/client.conf

# use sbin for gpdfand service
sed -i "s/\/usr\/local\/bin\/gpdfand/\/usr\/local\/sbin\/gpdfand/" gpdfand.service

# copy gpd fan service files
cp gpdfand.service /etc/systemd/system/gpdfand.service
cp gpdfand /lib/systemd/system-sleep/gpdfand
cp gpdfand.pl /usr/local/sbin/gpdfand

# make log directory
mkdir /var/log/gpdfand

# set permissionss
chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/sbin/gpdfand

# enable and start gpdfand
systemctl enable gpdfand.service

rm -f gpdfand gpdfand-gist gpdfand.service wrapper-gpd-fan-control.sh
