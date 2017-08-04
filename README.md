# How to Respin an ISO for GPD Pocket
## Overview
This is a collection of scripts and tweaks to adapt Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 - https://www.indiegogo.com/projects/gpd-pocket-7-0-umpc-laptop-ubuntu-or-win-10-os-laptop--2/x/16403171#/ - GPD Pocket Indiegogo Campaign page 
 
 Kudos and all the credits for things not related to my work go to developers and users on those pages!
 
### What Works Out-of-the-Box

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
 
### Overview for Building and Respinning an ISO

1. [Clone the repo and install necessary tools](#step-1-cloning-the-repo-and-installing-tools)
1. [Download your ISO of choice](#step-2-download-your-iso-of-choice)
1. [Download or build the latest kernel](#step-3-download-or-build-a-kernel-for-the-respin)
1. [Respin the ISO (it many take a about 30 minutes or even longer)](#step-4-build-your-respun-iso)
1. [Install OS and run post-install update](#step-5-install-and-update)

### Download an Already Respun ISO

[Click here for the downloads section](#downloading-existing-isos)

### Updating the BIOS
To update the BIOS, please go [here](#bios-updates-and-original-firmwares)
 
## Step 1: Cloning the Repo and Installing Tools

To respin an existing Ubuntu ISO, you will need to use a Linux machine with `squashfs-tools` and `xorriso` installed (e.g. `sudo apt install -y squashfs-tools xorriso`) and a working internet connection with at least 10GB of free space.

The first step is to clone this repo: 
```
git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin/
cd gpd-pocket-ubuntu-respin/
```
### Debian-based systems:

Install required packages:
```
sudo apt install -y git wget genisoimage bc squashfs-tools xorriso
```
### Arch-Based Systems:

Install required packages:
``` 
sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools
```

## Step 2: Download your ISO of Choice

Download your favourite distribution ISO and copy it in this repository cloned folder.

## Step 3: Download or Build a Kernel for the Respin

### Option 1: Download the Latest Kernel

1. Run `./build.sh` in the terminal to get the most recent download link
1. Download the zipped kernel file from the link generated in the terminal.
1. Place the downloaded kernel in the cloned repo's root directory. 

### Option 2: Build Your Own Kernel
 
#### Debian Based Systems:
```
sudo apt-get install build-essential git libncurses5-dev libssl-dev libelf-dev
git clone https://github.com/jwrdegoede/linux-sunxi.git
cd linux-sunxi/
make clean
make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-custom   
```
You can find the generated kernel .deb files in the parent folder where linux-sunxi repository have been cloned.

Compress all the .deb files generated into a zip named "gpd-pocket-kernel-files.zip" and put it in the root folder of this repository.

## Step 4: Build Your Respun ISO

Run `./build.sh` script as specified for your desired distro. If you built your own kernel, the build script wiill extract the kernels you zipped and install during respin.

### Build on Debian-based systems:

* Build Xorg ISO (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:
```
./build.sh <iso filename>
```
* Build Wayland ISO (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:
```
./build.sh <iso filename> wayland
```

### Build on Arch-based systems:

* Build Xorg ISO (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:
```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename>
```  
* Build Wayland ISO (Ubuntu Gnome, Kali Linux, Elementary OS, Gnome based distro) running this:
```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename> wayland
```

## Step 5: Install and Update

### Boot ISO from USB device

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

Boot system using one time boot menu: Press during GPD logo Fn + F7 keys.

### Post-install

These commands should be run after the first boot. There is an update script that will do it automatically, or you can run the necessary commands manually.

#### Update script

You can run my update script to update your installation and grub options, and to setup everything after an install or after a Desktop Environment change.
```
sudo apt-get install -y git
git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin.git
cd gpd-pocket-ubuntu-respin/
chmod +x update.sh
```
1. Unity, KDE, XFCE as Desktop Environment:    
```    
sudo ./update.sh
```
1. GNOME, Pantheon (Elementary OS) as Desktop Environment:
```
sudo ./update.sh wayland
```
#### Manual update

##### GRUB

Those commands will update your grub boot options to optimize the boot process for your Intel Atom processor
```
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1\"/" /etc/default/grub
sudo update-grub
```    
##### GPDFAND 

Latest GPD Fan control script is integrated into ISO.
You should update your installation using these commands:
```
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
```   
Check status using:
```
systemctl status gpdfand.service
```
##### SDDM/KDE DPI and Rotate

To let SDDM (The preferred display manager for KDE Plasma desktop) to scale correctly and be rotated you should put two xrandr arguments into his starting configuration file like this:
```
echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%
```

# Additional Notes
## Downloading Existing ISO's

Here is an already respinned Ubuntu ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

## BIOS Updates and Original Firmwares

You can find BIOS updates for GPD Pocket and original firmware files on this page:

http://www.gpd.hk/news.asp?id=1519&selectclassid=002002

### BIOS versions:

 - [Customary BIOS](https://mega.nz/#!kYRXzCYQ!3DJERs4tAV-Il_jbvkejcxLC4iOl_RjAj54e4dNIOAg): Original BIOS shipped with first batch of production.
 - [2017/06/28 BIOS for Ubuntu](https://www.dropbox.com/s/826snv05ix8tmfw/P7-20170628-Ubuntu-BIOS.zip?dl=0#): BIOS released for Ubuntu beta firmware.
          
       Changelog:
          1 - All settings are enabled so you can customize all the option of the BIOS.
          2 - Should have the fan working on boot
          
 - [2017/07/05 BIOS](https://mega.nz/#!EZoCmZhJ!s6VNjC6SOWuUhDZvxKf0jAYcs8rpuHeSo8Y0Ruzk3zM): Second BIOS officially released, it seems to be affected by a bug that turn on fan while charging when device is powered off.

       Changelog (Google translate):
           1 - boot on the fan ( Probably to support GPD official Ubuntu firmware that doesn't seems to handle fan directly )
           2 - improve the DPTF temperature, before the limit for the CPU temperature higher than 85 degrees or the battery temperature is higher than 58 degrees will CPU down.
           
### Updating the BIOS
1. Download the latest BIOS
2. Install the flashing utility
```
sudo apt install flashrom
```
3. Use `cd` to enter the directory where you downloaded the BIOS
4. Backup the current BIOS
```
sudo flashrom -p internal -r backup.bin
```
5. Flash the new BIOS
```
sudo flashrom -p internal -w Rom_8MB_Tablet.bin
```
6. Reboot Your Computer

Notes: You may need to restore BIOS setting to their default in order to get everything running smoothly.

# Troubleshooting

## Blank screen on Live USB boot and white power led on

Press the power button to let the desktop load and look at issues below.

## Sleep when plugging in charger

Some sort of Unity daemon or watcher seems to read bad values from battery or charge and put system on sleep when charger is plugged in. This seems to happen also on boot of Live USB.
Press any key or power button to wake.
It only happens on Unity as far as i know.

## Screen keeps spamming errors regarding squashfs after power button press or close/open lid

Try to burn the image on a smaller usb device or try another image.

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

## No sound / streaming video crashing/not playing

Check that the correct sound output device is selected in System Settings. 
It should be "Speakers: chtrt5645" for device speakers and "Headphones: chtrt5645" for the audio jack output.

## Why is system UI so big?

The scaling ratio is set to `2` to be able to read on the screen but it sure takes of a lot of space out of the FullHD screen.
Things will be more aliased and have better edge but take more space on screen.
To restore to native pixel resolution you have to edit the scale configuration:
```
sudo nano /etc/X11/Xsession.d/90-scale
```
You have to edit all the values to their default:
```
gsettings set com.ubuntu.user-interface scale-factor "{'DSI-1': 1, 'DSI1': 1}" // Unity
gsettings set org.gnome.desktop.interface scaling-factor 1 // Gnome 3
gsettings set org.gnome.desktop.interface text-scaling-factor 1 // Gnome 3
gsettings set org.cinnamon.desktop.interface scaling-factor 1 // Cinnamon
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1 // Cinnamon
```

```
sudo nano /etc/environment
```
You have to edit the value to its default or comment out this line:
```
GDK_SCALE=2
```

This will affect all the different desktop environments. This might require a log-out, log-in, or reboot to take effect. Restarting the display manager service will also work.
This way you can still read fine (if you have good 👀 ) and have all your pixels back.
