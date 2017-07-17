#!/bin/bash

cd /usr/local/bin

# copy gpd fan service files
cp gpdfand.service /etc/systemd/system/gpdfand.service
cp gpdfand /lib/systemd/system-sleep/gpdfand
cp gpdfand.conf /etc/gpdfand.conf
cp gpdfand.py /usr/local/sbin/gpdfand

# make log directory
mkdir /var/log/gpdfand

# set permissionss
chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/sbin/gpdfand
chmod 0644 /etc/gpdfand.conf
chmod 0644 /etc/systemd/system/gpdfand.service

# enable and start gpdfand
systemctl enable gpdfand.service

rm -f gpdfand gpdfand.conf gpdfand.py gpdfand.service wrapper-fan.sh
