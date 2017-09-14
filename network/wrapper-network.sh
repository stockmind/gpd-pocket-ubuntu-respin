#!/bin/bash

cd /usr/local/bin

cp brcmfmac4356-pcie.txt /lib/firmware/brcm/brcmfmac4356-pcie.txt

# add wifi module for sleep
mkdir -p /etc/pm/config.d/
touch /etc/pm/config.d/config
echo "SUSPEND_MODULES=\"brcmfmac\"" >> /etc/pm/config.d/config

# enforce brcmfmac load on boot
echo "brcmfmac" >> /etc/modules-load.d/brcmfmac.conf

# bluetooth enable
cp 99-local-bluetooth.rules /etc/udev/rules.d/99-local-bluetooth.rules


rm -f 99-local-bluetooth.rules brcmfmac4356-pcie.txt wrapper-network.sh
