#!/bin/bash

# GPD Pocket system environment check
# Author: Simone Roberto Nunzi aka stockmind
# Problem reporting script

echo "Kernel: $(uname -r)"
echo "Desktop Environment: $XDG_CURRENT_DESKTOP"
echo "Display: $DISPLAY"
echo "Monitor: $(xrandr | grep DSI1)"
echo "Scripts: $(ls /usr/local/sbin/)"
echo "EFI: $(dmesg | grep \"EFI v\")"
echo "EFI Release date: $(dmidecode | grep \"Release\")"
