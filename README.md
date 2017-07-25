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
    
Build Xorg iso (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:

    ./build.sh <iso filenamme>
    
Build Wayland iso (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:

    ./build.sh <iso filenamme> wayland
        
## Arch based systems:

    sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools

Build Xorg iso (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:

    PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filenamme>
    
Build Wayland iso (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:

    PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filenamme> wayland

# Build latest kernel

## Debian based systems:

    sudo apt-get install build-essential git libncurses5-dev libssl-dev libelf-dev
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
    sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1\"/" /etc/default/grub

    sudo update-grub
    
## GPDFAND 

Latest GPD Fan control script is integrated into iso.
You should update your installation using these commands:

    git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin.git
    cd gpd-pocket-ubuntu-respin/fan/
    sudo cp gpdfand.service /etc/systemd/system/gpdfand.service
    sudo cp gpdfand /lib/systemd/system-sleep/gpdfand
    sudo cp gpdfand.conf /etc/gpdfand.conf
    sudo cp gpdfand.py /usr/local/sbin/gpdfand
    sudo chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/sbin/gpdfand
    sudo chmod 0644 /etc/gpdfand.conf
    sudo chmod 0644 /etc/systemd/system/gpdfand.service
    sudo systemctl enable gpdfand.service
    sudo systemctl restart gpdfand.service
    
Check status using:

    systemctl status gpdfand.service

## SDDM/KDE DPI and Rotate

To let SDDM (The preferred display manager for KDE Plasma desktop) to scale correctly and be rotated you should put two xrandr arguments into his starting configuration file like this:

    echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
    echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%

# Download ISO

Download an already respinned ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

# Troubleshooting

## Blank screen on Live USB boot and white power led on

Press power button to let usual desktop loading and look at issue below.

## Sleep on plug of charger

Some sort of Unity daemon or watcher seems to read bad values from battery or charge and put system on sleep when charger is plugged in. This seems to happen also on boot of Live USB.
Press any key or power button to wake.
It only happens on Unity as far as i know.

## Screen keep spamming errors regarding squashfs after power button press or close/open lid

Try to burn image on smaller usb device or try another one.

I sugget [Etcher]https://etcher.io/ to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

## No sound / streaming video crashing/not playing

Check that the correct sound output device is selected in System Settings. 
It should be "Speakers: chtrt5645" for device speakers and "Headphones: chtrt5645" for the audio jack output.

