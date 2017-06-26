#!/bin/bash

cd /usr/local/bin

# load pwm for Intel Low Power Subsystem PWM controller driver
echo "pwm-lpss" >> /etc/initramfs-tools/modules
echo "pwm-lpss-platform" >> /etc/initramfs-tools/modules

cp gpdfand.service /etc/systemd/system/gpdfand.service
cp gpdfand /lib/systemd/system-sleep/gpdfand

update-initramfs -u -k all

# update grub config
echo "Update grub defult..."
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable\"/" /etc/default/grub

# add wifi module for sleep
mkdir -p /etc/pm/config.d/
touch /etc/pm/config.d/config
echo "SUSPEND_MODULES=\"brcmfmac\"" >> /etc/pm/config.d/config

# fetch fan control script
wget -O gpdfand-gist https://gist.githubusercontent.com/efluffy/3e9b8a70e28bd801aa0dad93f0f60519/raw/c71a230e9eae87b2ec033a271a33b20ad0717b56/gpdfan

cp gpdfand-gist /usr/local/sbin/gpdfand

# set permissionss
chmod +x /usr/local/sbin/gpdfand /lib/systemd/system-sleep/gpdfand

# enable and start gpdfand
systemctl enable gpdfand.service

rm -f gpdfand gpdfand-gist gpdfand.service wrapper-gpd-fan-control.sh
