#!/bin/bash

cd /usr/local/bin

cp brcmfmac4356-pcie.txt /lib/firmware/brcm/brcmfmac4356-pcie.txt

# add wifi module for sleep
mkdir -p /etc/pm/config.d/
touch /etc/pm/config.d/config
echo "SUSPEND_MODULES=\"brcmfmac\"" >> /etc/pm/config.d/config

# enforce brcmfmac load on boot
echo "brcmfmac" >> /etc/modules

rm -f brcmfmac4356-pcie.txt wrapper-network.sh
