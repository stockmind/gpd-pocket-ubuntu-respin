# Respin ISO for GPD Pocket
Collection of scripts and tweaks to adapt Debian, Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 
 Kudos and all the credits go to them! 

# Build iso image with tweaks

To respin an existing Ubuntu ISO you will need to use a Linux machine with 'squashfs-tools' and 'xorriso' installed (e.g. 'sudo apt install -y squashfs-tools xorriso') and a working internet connection with at least 10GB of free space.

Debian based systems:

    sudo apt install -y squashfs-tools xorriso
    
Arch based systems:

    sudo pacman -S libisoburn squashfs-tools

Build iso running this:

    ./build.sh <iso filenamme>
    
# Post install

Commands that should be run after first boot

## GRUB

Those commands will update your grub boot options to optimize the boot process for your intel Atom processor

    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
    sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable\"/" /etc/default/grub

    sudo update-grub
    
## GPDFAND

Check where *temp2_input, temp3_input, temp4_input, temp5_input* are located and update gdpfand service as needed.

    ls /sys/class/hwmon/hwmon0/ && \
    ls /sys/class/hwmon/hwmon1/ && \
    ls /sys/class/hwmon/hwmon2/ && \
    ls /sys/class/hwmon/hwmon3/ && \
    ls /sys/class/hwmon/hwmon4/
    
Mine for example are inside */sys/class/hwmon/hwmon3/* so i use this command to update the service:

    sudo sed -i "s/\/sys\/class\/hwmon\/hwmon4\//\/sys\/class\/hwmon\/hwmon3\//" /usr/local/sbin/gpdfand
    
Then restart it

    systemctl stop gpdfand.service
    systemctl start gpdfand.service
    
Check status

    systemctl status gpdfand.service

# Download ISO

Download an already respinned ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

# Troubleshooting

## Screen keep spamming errors regarding squashfs after power button press or close/open lid

Try to burn image on smaller usb device or try another one.

I sugget [Etcher]https://etcher.io/ to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

