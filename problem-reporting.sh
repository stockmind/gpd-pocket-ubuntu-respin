#!/usr/bin/env bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# GPD Pocket system environment check
# Author: Simone Roberto Nunzi aka stockmind
# Problem reporting script

echo "Kernel: $(uname -r)"
echo "Desktop Environment: $XDG_CURRENT_DESKTOP"
echo "Display: $DISPLAY"
echo "Monitor: $(xrandr | grep DSI1)"
echo "Scripts: " $(ls /usr/local/sbin/ | tr "\n" " ")
echo "EFI: " $(dmesg | grep "EFI v")
echo "EFI " $(dmidecode | grep "Release")
