#!/bin/bash

cd /usr/local/bin

# load modules into initramfs make tools to include on boot
echo "pwm-lpss" >> /etc/initramfs-tools/modules
echo "pwm-lpss-platform" >> /etc/initramfs-tools/modules
echo "btusb" >> /etc/initramfs-tools/modules

rm -f wrapper-power.sh
