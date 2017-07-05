# Respin ISO for GPD Pocket
Collection of scripts and tweaks to adapt Debian, Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 
 Kudos and all the credits go to them! 
 
 Repository need a lot of refactoring to naming scripts better and documenting things. I'll do it in the next days.
 
# What works out of the box

 - ✔ Display already rotated in terminal buffer and desktop/login
 - ✔ Scaling already set to 175%
 - ✔ Touchscreen aligned to rotation
 - ✔ Wifi
 - ✔ Sound (Must select "Speakers" in audio output devices if no sound output)
 - ✔ Battery manager
 - ✔ Screen brightness ( Only after install at the moment )
 - ✔ Cooling fan ( Amazing ErikaFluff work! Check post installation section of this readme to optimize it )
 - ✔ Bluetooth ( Credits to Reddit user dveeden )
 - ✔ Intel video driver for streaming without tearing or crash
 - ✔ Sleep/wake

# Build iso image with tweaks

To respin an existing Ubuntu ISO you will need to use a Linux machine with 'squashfs-tools' and 'xorriso' installed (e.g. 'sudo apt install -y squashfs-tools xorriso') and a working internet connection with at least 10GB of free space.

## Debian based systems:

    sudo apt install -y git wget genisoimage bc squashfs-tools xorriso
    
Build iso running this:

    ./build.sh <iso filenamme>
    
## Arch based systems:

    sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools

Build iso running this:

    PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filenamme>
    
# Build latest kernel

## Debian based systems:

    sudo apt-get install build-essential git libncurses5-dev libssl-dev
    git clone https://github.com/jwrdegoede/linux-sunxi.git
    cd linux-sunxi/
    make clean
    make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-custom   

You can find the generated kernel .deb files in the parent folder where linux-sunxi repository have been cloned.

Compress all the .deb files generated into a zip named "gpd-pocket-kernel-files.zip" and put it in the root folder of this repository. Overwrite existing zip.

Build.sh script will extract them and install during respin.

# Post install

Commands that should be run after first boot

## GRUB

Those commands will update your grub boot options to optimize the boot process for your intel Atom processor

    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
    sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1\"/" /etc/default/grub

    sudo update-grub
    
## GPDFAND ( ISO BUILT BEFORE 05/07/2017 ONLY [dd/mm/yyyy] )

GPDFAND must be updated to point where *temp2_input, temp3_input, temp4_input, temp5_input* are located.
Mine for example are inside */sys/class/hwmon/hwmon3/*.
Use this command to let the system find requested files and update the service as needed:

Custom built ISO:

    HWMONPATH=$(for i in /sys/class/hwmon/hwmon*/; do [ "$(cat "$i"name)" = coretemp ] && break; done; echo "$i")
    sudo sed -i 's|/sys/class/hwmon/hwmon4/|'$HWMONPATH'|' /usr/local/sbin/gpdfand

Current ISO:

    HWMONPATH=$(for i in /sys/class/hwmon/hwmon*/; do [ "$(cat "$i"name)" = coretemp ] && break; done; echo "$i")
    sudo sed -i 's|/sys/class/hwmon/hwmon\*/|'$HWMONPATH'|' /usr/local/sbin/gpdfand
    
Then restart it

    systemctl stop gpdfand.service
    systemctl start gpdfand.service
    
Check status

    systemctl status gpdfand.service
    
## SDDM/KDE DPI and Rotate

To let SDDM (The preferred display manager for KDE Plasma desktop) to scale correctly and be rotated you should put two xrandr arguments into his starting configuration file like this:

    echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
    echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%

# Download ISO

Download an already respinned ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

# Troubleshooting

## Screen keep spamming errors regarding squashfs after power button press or close/open lid

Try to burn image on smaller usb device or try another one.

I sugget [Etcher]https://etcher.io/ to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

## No sound / streaming video crashing/not playing

Check that the correct sound output device is selected in System Settings. 
It should be "Speakers: chtrt5645" for device speakers and "Headphones: chtrt5645" for the audio jack output.

