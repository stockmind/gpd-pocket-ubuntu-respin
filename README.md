# How to Respin an ISO for GPD Pocket
## Overview
This is a collection of scripts and tweaks to adapt Debian, Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 - https://www.indiegogo.com/projects/gpd-pocket-7-0-umpc-laptop-ubuntu-or-win-10-os-laptop--2/x/16403171#/ - GPD Pocket Indiegogo Campaign page 
 
 Kudos and all the credits for things not related to my work go to developers and users on those pages!
 
### What Works Out-of-the-Oox

 - ✔ Display already rotated in terminal buffer and desktop/login
 - ✔ Scaling already set to 175%
 - ✔ Touchscreen aligned to rotation
 - ✔ Wifi
 - ✔ Sound ( Must select "Speakers" in audio output devices if no sound output )
 - ✔ Battery manager
 - ✔ Screen brightness ( Only after install at the moment )
 - ✔ Cooling fan ( Amazing ErikaFluff work! Check post installation section of this readme to optimize it )
 - ✔ Bluetooth ( Credits to Reddit user dveeden )
 - ✔ Intel video driver for streaming without tearing or crash
 - ✔ Sleep/wake
 
### What Doesn't Work at the Moment

 - Charging at full speed ( Charging will be slow and will keep device charge stable when in use. i.e. it will not drain battery as it may happen on old or generic kernels. Shutdown device to get full speed charge. )
 - Bluetooth audio ( Need further testing and experience, audio on bluetooth seems to work for just 10 seconds then crash )
 
### Overview for Building and respinning an ISO
1. Clone the repo
1. Install necessary tools and download the ISO
1. Download OR build the latest kernel
1. Run the build.sh (it many take a about 30 minutes or even longer)
1. Write ISO on USB drive and boot from it
1. Install OS and run post-install update

### Download an already respinned ISO

[Click here for downloads section.](#downloading-existing-isos)
 
## Step 1: Cloning the Repo and Installing Tools
### Overview
To respin an existing Ubuntu ISO, you will need to use a Linux machine with `squashfs-tools` and `xorriso` installed (e.g. `sudo apt install -y squashfs-tools xorriso`) and a working internet connection with at least 10GB of free space.

The first step is to clone this repo: 
 ```
 git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin/
 cd gpd-pocket-ubuntu-respin/
 ```
       

## Step 2: Download your ISO of Choice
### Debian based systems:
 1. install required packages:

        sudo apt install -y git wget genisoimage bc squashfs-tools xorriso
    
 1. Download your favourite distribution ISO and copy it in this repository cloned folder.

 1. Run `./build.sh` on terminal for the first time to get kernel files download link.

 1. Download zip file from link provided and put it in this repository cloned folder.
    
 1. Build ISO
 
     a. Build Xorg iso (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:

            ./build.sh <iso filenamme>
    
     a. Build Wayland iso (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:
        
            ./build.sh <iso filenamme> wayland
        
## Arch based systems:

 1. Install required packages:
 
        sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools
    
 1. Download your favourite distribution ISO and copy it in this repository cloned folder.

 1. Run `./build.sh` on terminal for the first time to get kernel files download link.

 1. Download zip file from link provided and put it in this repository cloned folder.  
 
 1. Build ISO

      a. Build Xorg iso (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:

            PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filenamme>
    
      5b. Build Wayland iso (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:

            PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filenamme> wayland

# Step 3: Build the Latest Kernel
## Debian based systems:

    sudo apt-get install build-essential git libncurses5-dev libssl-dev libelf-dev
    git clone https://github.com/jwrdegoede/linux-sunxi.git
    cd linux-sunxi/
    make clean
    make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-custom   

You can find the generated kernel .deb files in the parent folder where linux-sunxi repository have been cloned.

Compress all the .deb files generated into a zip named "gpd-pocket-kernel-files.zip" and put it in the root folder of this repository. Overwrite existing zip.

# Step 4: Build Your Respun ISO
1. Run ./build.sh script as specified for your desired distro.
1. The build script wiill extract the kernels you zipped and install during respin.

# Steps 5: Install and Update
## Boot ISO from USB device

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

Boot system using one time boot menu: Press during GPD logo Fn + F7 keys.

## Post-install

These commands should be run after the first boot. There is an update script that will do it automatically, or you can run the necessary commands manually.

### Update script

You can run my update script to update your installation and grub options, and to setup everything after an install or after a Desktop Environment change.

    sudo apt-get install -y git
    git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin.git
    cd gpd-pocket-ubuntu-respin/
    chmod +x update.sh
    sudo ./update.sh

### Manual update

#### GRUB

Those commands will update your grub boot options to optimize the boot process for your intel Atom processor

    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
    sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1\"/" /etc/default/grub

    sudo update-grub
    
#### GPDFAND 

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

#### SDDM/KDE DPI and Rotate

To let SDDM (The preferred display manager for KDE Plasma desktop) to scale correctly and be rotated you should put two xrandr arguments into his starting configuration file like this:

    echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
    echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%

# Additional Notes
## Downloading Existing ISO's

Here is an already respinned Ubuntu ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

## BIOS updates and original firmwares

You can find BIOS updates for GPD Pocket and original firmware files on this page:

http://www.gpd.hk/news.asp?id=1519&selectclassid=002002

BIOS versions:

 - Customary BIOS: Original BIOS shipped with first batch of production.
 - 2017/06/28 BIOS Ubuntu: BIOS released for Ubuntu beta firmware. http://pan.baidu.com/s/1ge3CTiV#list/path=%2F 
          
       Changelog:
          1 - All settings are enabled so you can customize all the option of the BIOS.
          2 - Should have the fan working on boot
          
 - 2017/07/05 BIOS: Second BIOS officially released, it seems to be affected by a bug that turn on fan while charging when device is powered off.

       Changelog (Google translate):
           1 - boot on the fan ( Probably to support GPD official Ubuntu firmware that doesn't seems to handle fan directly )
           2 - improve the DPTF temperature, before the limit for the CPU temperature higher than 85 degrees or the battery temperature is higher than 58 degrees will CPU down.

# Troubleshooting

## Blank screen on Live USB boot and white power led on

Press power button to let usual desktop loading and look at issue below.

## Sleep on plug of charger

Some sort of Unity daemon or watcher seems to read bad values from battery or charge and put system on sleep when charger is plugged in. This seems to happen also on boot of Live USB.
Press any key or power button to wake.
It only happens on Unity as far as i know.

## Screen keep spamming errors regarding squashfs after power button press or close/open lid

Try to burn image on smaller usb device or try another one.

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

## No sound / streaming video crashing/not playing

Check that the correct sound output device is selected in System Settings. 
It should be "Speakers: chtrt5645" for device speakers and "Headphones: chtrt5645" for the audio jack output.

## Why system UI is so big ?

The scaling ratio is set to `2` to be able to read on the screen but it sure takes of a lot of space out of the FullHD screen.
Things will be more aliased and have better edge but take more space on screen.
To restore to native pixel resolution you have to edit the scale configuration
```sh
sudo nano /etc/X11/Xsession.d/90-scale
```
You have to edit all the values to their default:

    gsettings set com.ubuntu.user-interface scale-factor "{'DSI-1': 1, 'DSI1': 1}" // Unity
    gsettings set org.gnome.desktop.interface scaling-factor 1 // Gnome 3
    gsettings set org.gnome.desktop.interface text-scaling-factor 1 // Gnome 3
    gsettings set org.cinnamon.desktop.interface scaling-factor 1 // Cinnamon
    gsettings set org.cinnamon.desktop.interface text-scaling-factor 1 // Cinnamon

This will affect all the different DE. This might require a log-out log-in or reboot to take effect. Restart the dm service will also work.
This way you can still read fine (if you have good 👀 ) and have all your pixels back.
