[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YYGKKE6FDX2KY) [![Donate Bitcoin](https://img.shields.io/badge/Donate-Bitcoin-green.svg)](https://stockmind.github.io/donate-bitcoin/) [![Docker Build Statu](https://img.shields.io/docker/build/stockmind/gpd-pocket-ubuntu-respin.svg)]() [![Docker Automated buil](https://img.shields.io/docker/automated/stockmind/gpd-pocket-ubuntu-respin.svg)]()

![GPD Pocket Ubuntu](https://github.com/stockmind/gpd-pocket-ubuntu-respin/raw/master/screenshot.png)

# Update an installed system

You can update an installed system using the update commands here:
[Update steps](#post-install)

# Check new rotation script and tray icon!
![GPD Pocket Screen rotation utility](https://github.com/stockmind/gpd-pocket-screen-indicator/raw/master/screenshot.png)

https://github.com/stockmind/gpd-pocket-screen-indicator

Run [update script](#post-install) to install it automatically.

# Have an issue?

Check [Troubleshooting section.](#troubleshooting)
Try to download this repository and run `update.sh` script and `update-kernel.sh` script to update system to latest working configuration. [Check update section.](#update-script)
If your problem persist or is not on the troubleshooting list check [Problem reporting section](#problem-reporting) before open an issue.

**Scripts on this repository are not compatible with Ansible-playbook setup due to rotation and other scripts that may conflict. Clean your system before use this.
You may try this clean script at your own risk: [Clean Ansible Playbook script](https://github.com/stockmind/gpd-pocket-ubuntu-respin/blob/master/clean-ansible.sh)**

# Donate

If my work helped you consider a little donation to buy me a coffe... or an energy drink! :smile:

**Paypal**

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YYGKKE6FDX2KY)

**Bitcoin**

[![Donate Bitcoin](https://stockmind.github.io/donate-bitcoin/bitcoin-button.png)](https://stockmind.github.io/donate-bitcoin/)

# How to Respin an ISO for GPD Pocket
## Overview
This is a collection of scripts and tweaks to adapt Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Chrisawcom base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 - https://www.indiegogo.com/projects/gpd-pocket-7-0-umpc-laptop-ubuntu-or-win-10-os-laptop--2/x/16403171#/ - GPD Pocket Indiegogo Campaign page 
 - https://github.com/nexus511/gpd-ubuntu-packages - Alternative project by nexus511 
 - https://github.com/cawilliamson/ansible-gpdpocket - Alternative awesome project by Cawilliamson that targets any linux distro - not maintained anymore
 
 Kudos and all the credits for things not related to my work go to developers and users on those pages!
 
### What Works Out-of-the-Box

 - ✔ Display already rotated in terminal buffer and desktop/login ( Hans de Goede kernel patch, monitors.xml file and rotation daemon based on initial work of *Chrisawcom* )
 - ✔ Scaling already set to 175%
 - ✔ Touchscreen aligned to rotation ( [Check new rotation script and tray icon](https://github.com/stockmind/gpd-pocket-screen-indicator) )
 - ✔ Multitouch ( [Check multitouch section  for more information](#multitouch) )
 - ✔ Wifi
 - ✔ Speaker ( Must select "Speakers" in audio output devices if no sound output )
 - ✔ Headphones ( Must select "Headphones" in audio output devices, works only on kernel 4.13+ )
 - ✔ Battery manager
 - ✔ Screen brightness ( Only after install at the moment )
 - ✔ Cooling fan ( Amazing initial work of *ErikaFluff*, rewritten in Python by *Chrisawcom*! Check post installation section of this readme to optimize it )
 - ✔ Bluetooth ( Credits to Reddit user *dveeden* )
 - ✔ Intel video driver for streaming without tearing or crash ( [Check Google Chrome workaround](#google-chrome-tearing-glitch-or-flickering-while-scrolling-or-browsing-heavy-web-pages) )
 - ✔ Sleep/wake
 - ✔ HDMI port
 - ✔ Charging at full speed ([Check charging info for more information](#charging-info))
 - ✔ **USB-C for data** ( Kernel version 4.14 or later )
 - ✔ TTY/Console font size reasonably bigger to improve readability ( Thanks joshskidmore for the intuition! - Worsk only on installed system and a "update.sh" run may be needed )
 - ✔ Trackpoint faster for a better experience right from the start ( Thanks rustige for config! )
 - ✔ Bluetooth audio ( Kernel version 4.14-rc3 or later ) 
 - ✔ **Audio aligned to Windows experience** ( Kernel version 4.14-rc3 with audio flag fix. See for previous issues: https://bugzilla.kernel.org/show_bug.cgi?id=196351, check also [Troubleshooting section for more informations](https://github.com/stockmind/gpd-pocket-ubuntu-respin/blob/master/README.md#audio-jack-disconnected-on-volume-over-70-80-windows-and-linux-same-behaviour-with-some-headphones) )
 - ✔ **Headphones/Speakers auto switch on jack plugged in/out** 
 
### What Doesn't Work at the Moment

 - Audio on hdmi ( Need feedback )
 - Hibernation ( Need feedback )
 - USB-C as video output
 
### Overview for Building and Respinning an ISO

1. [Clone the repo and install necessary tools](#step-1-cloning-the-repo-and-installing-tools)
1. [Download your ISO of choice](#step-2-download-your-iso-of-choice)
1. [Download or build the latest kernel](#step-3-download-or-build-a-kernel-for-the-respin)
1. [Respin the ISO (it many take a about 30 minutes or even longer)](#step-4-build-your-respun-iso)
1. [Install OS and run post-install update](#step-5-install-and-update)

### Download an Already Respun ISO

[Click here for the downloads section](#downloading-existing-isos)

### Updating the BIOS
At the moment no BIOS update is required to run Ubuntu respin iso.
You can run any BIOS you want and you probably won't notice big differences.
Different BIOS have however different features enabled. Check BIOS section [here](#bios-updates-and-original-firmwares)

## Respin iso and build kernels with Docker

![Docker](https://github.com/stockmind/gpd-pocket-ubuntu-respin/raw/master/Docker.png)

[Click here for the Docker building section](#build-with-docker)

## Build and respin without Docker
## Step 1: Cloning the Repo and Installing Tools

To respin an existing Ubuntu ISO, you will need to use a Linux machine with `squashfs-tools` and `xorriso` installed (e.g. `sudo apt install -y squashfs-tools xorriso`) and a working internet connection and at least 10GB of free storage space.

The first step is to clone this repo: 
```
git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin/
cd gpd-pocket-ubuntu-respin/
```
### Debian-based systems:

Install all the required packages:
```
sudo apt install -y git wget genisoimage bc squashfs-tools xorriso
```
### Arch-Based Systems:

Install all the required packages:
``` 
sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools
```

## Step 2: Download your ISO of Choice

Download your favourite distribution ISO and copy it in this repository cloned folder.

## Step 3: Download or Build a Kernel for the Respin

### Option 1: Download the Latest Kernel

1. Running `./build.sh` in the terminal will download the most recent kernel automatically.

### Option 2: Build Your Own Kernel

Kernel suggested is the one with patches from Hans De Goede. You can find his repository here:
[Hans De Goede Kernel Repository](https://github.com/jwrdegoede/linux-sunxi.git)
 
#### Debian Based Systems:
```
sudo apt-get install build-essential git libncurses5-dev libssl-dev libelf-dev
git clone https://github.com/jwrdegoede/linux-sunxi.git
```

If you have already donwloaded the repository, you can update it with latest commits issuing:
```
git fetch origin
git reset --hard origin/master
```

**If you want to use the custom kernel config provided by this repository copy and overwrite `.config` that you can find in this repository in `kernel/.config` with `.config` file of Hans kernel repository**

Then proceed with building:

```
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
* Build Gnome based ISO (Ubuntu Gnome, Kali Linux, Gnome based distro) running this:
```
./build.sh <iso filename> gnome
```

### Build on Arch-based systems:

* Build Xorg ISO (Ubuntu Unity, Linux Mint, XFCE, KDE) running this:
```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename>
```  
* Build Gnome based ISO (Ubuntu Gnome, Kali Linux, Elementary OS, Gnome based distro) running this:
```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename> gnome
```

Gnome desktop environment and derivate (Pantheon of Elementary OS) use a different name convention for monitors.
The default Xorg configuration won't work and a custom configuration must be used to get everything to work.
That's the reason of the "gnome" argument for update and build script.

## Step 5: Install and Update

### Boot ISO from USB device

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

Boot system using one time boot menu: Press during GPD logo Fn + F7 keys.

Don't boot your USB from a USB Type C adapter or USB Type C drive as it wouldn't work until USB Type C data is supported by kernel.

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
sudo ./update.sh gnome
```

Gnome desktop environment and derivate (Pantheon of Elementary OS) use a different name convention for monitors.
The default Xorg configuration won't work and a custom configuration must be used to get everything to work.
That's the reason of the "gnome" argument for update and build script.

Update kernel to latest version issuing the following command:

```
sudo ./update-kernel.sh
```

A kernel update is always recommended.

# Additional Notes
## Downloading Existing ISO's

Here is an already respinned Ubuntu ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

## BIOS Updates and Original Firmwares

At the moment no BIOS update is required to run Ubuntu respin iso.
You can run any BIOS you want and you probably won't notice big differences.
Different BIOS have however different features enabled. Check changelogs below.

You can find BIOS updates for GPD Pocket and original firmware files on this page:

http://www.gpd.hk/news.asp?id=1519&selectclassid=002002

Useful informations:

http://tieba.baidu.com/p/5293185138

### Official GPD Pocket Ubuntu ISO

Diffs of latest (0809_2) GPD Official Ubuntu image with files that GPD added to vanilla Ubuntu ISO: 

https://www.reddit.com/r/GPDPocket/comments/70qdsp/diff_of_latest_gpd_official_ubuntu_firmware_iso/?st=j7pa5css&sh=02dc3f67

Files: [Download Here](http://ge.tt/4t7qsZm2)

ISO:

Latest versions are available here: http://www.gpd.hk/news.asp?id=1519&selectclassid=002002

[Second version](https://mega.nz/#!SsNiQIKI!NyiD2EnKD-GguGmBfvdsD1nFoutvABcLEb0uUuXtjOA) - [Chinese Mirror](https://pan.baidu.com/s/1jIBV13K?fref=gc) - [My mirror](https://mega.nz/#!caAjUAKR!fwR0Mf9qBqSS4D43U5Ds8Wjj-3a1qc44LIR01cMGkx8)

[First version](https://mega.nz/#!ZaoCDSqA!tbFx0Pev2dU0al8iVdmvNNiEA9RuL2jLZQV9md1S-iI) (Working iso, GPD one uploaded on indiegogo was corrupt)

### BIOS versions:

 - [Customary BIOS](https://mega.nz/#!kYRXzCYQ!3DJERs4tAV-Il_jbvkejcxLC4iOl_RjAj54e4dNIOAg): Original BIOS shipped with first batch of production.
 - [2017/06/28 BIOS for Ubuntu](https://www.dropbox.com/s/826snv05ix8tmfw/P7-20170628-Ubuntu-BIOS.zip?dl=0#): BIOS released for Ubuntu beta firmware.
          
       Changelog:
          1 - All settings are enabled so you can customize all the option of the BIOS.
          2 - Should have the fan working on boot
          
 - [2017/07/05 BIOS](https://mega.nz/#!EZoCmZhJ!s6VNjC6SOWuUhDZvxKf0jAYcs8rpuHeSo8Y0Ruzk3zM): Second BIOS officially released, on this BIOS fan will turn on while charging when device is powered off.
 
    [Changelog - Chinese](http://tieba.baidu.com/p/5242896448)

       Changelog (Google translate):
           1 - boot on the fan ( Probably to support GPD official Ubuntu firmware that doesn't seems to handle fan directly )
           2 - improve the DPTF temperature, before the limit for the CPU temperature higher than 85 degrees or the battery temperature is higher than 58 degrees will CPU down.
           
 - [2017/08/07 BIOS](https://mega.nz/#!RZoG2I6Y!E3tDSn2M2BNn-JxW8pX7OEo8QgxUkFLs11Uw_WiG0Wc)   
 
       Changelog (Google translate)
           1 - This BIOS has changed the boot logic. In the previous BIOS device will boot only with a charge of 10 to 17%, now you only need at least some charge to boot. 
           
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

## Charging info

To get charging working correctly a different Power Delivery 2.0 charger may be required, based on kernel used, otherwise charging will be slow and will just keep device charge stable when in use. i.e. it will not drain battery as it may happen on old or generic kernels, but won't charge device more than when connected to power.

Follow some data recorded with several chargers and systems regarding the charge delivered and perceived by the system:

| Charger           | System                                   | Volts (Avg.) | Ampere (Avg.) |
|-------------------|------------------------------------------|--------------|---------------|
| Stock GPD charger | 4.12-rc2+ kernel (GPD official firmware) | 4.70v        | 2.5a          |
| Aukey charger     | 4.12-rc2+ kernel (GPD official firmware) | 4.70v        | 2.5a          |
| Stock GPD charger | 4.12-rc7 kernel (HansDeGoede kernel)     | 4.89v        | 0.5a \*        |
| Aukey charger     | 4.12-rc7 kernel (HansDeGoede kernel)     | 4.89v        | 2a            |
| Stock GPD charger | 4.13-rc3 kernel (HansDeGoede kernel)     | 11.8v        | 1.5a          |
| Aukey charger     | 4.13-rc3 kernel (HansDeGoede kernel)     | 9.20v        | 0.5a \*\*       |
| Stock GPD charger | 4.13-rc5 kernel (HansDeGoede kernel)     | 11.8v        | 1.3a          |
| Aukey charger     | 4.13-rc5 kernel (HansDeGoede kernel)     | 9.0v         | 1.4a          |
| Stock GPD charger | Windows 10                               | 11.70v       | 1.7a          |
| Aukey charger     | Windows 10                               | 8.90v        | 2a            |

\* Charging will not drain battery but won't charge device more than when connected to power

\*\* Charging will be slow

**Any kernel after 4.13-rc5 (From Hans de Goede repository) should be fine for full-speed charging!
Mainline kernel 4.14 or later should be fine.**

Ampere delivered may vary depending on the remaining battery charge.

The tests have been performed using this [Jokitech USB-C Power Meter Tester Multimeter](https://www.amazon.it/gp/product/B06XJNHFFX/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1) 

Follow link of Anker charger used.

[Amazon UK - AUKEY USB C 29W PD 2.0](https://www.amazon.co.uk/gp/product/B01MYVJELP/ref=oh_aui_detailpage_o07_s00?ie=UTF8&psc=1)

[Amazon IT - AUKEY USB C 29W PD 2.0](https://www.amazon.it/gp/product/B01N6536VP/ref=oh_aui_detailpage_o01_s00?ie=UTF8&psc=1)

## Multitouch

 - Google Chrome: Works out of the box with multitouch gestures. No configuration needed.
 - Firefox: Bundled builds of Firefox in Ubuntu and derivates doesn't support touch gestures by default. You need a build with cairo-gtk3 enabled, you can check it in "about:buildconfig", if it's missing touch will probably won't work in your build. You can get a build with that module enabled on Firefox official site or [here](https://sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build/). Install it and add 
 
       MOZ_USE_XINPUT2=1
    
    in /etc/environment (if not already present) or run Firefox with 

       env MOZ_USE_XINPUT2=1 firefox
    
    If it still doesn't work after a reboot try to add this boolean key in "about:config": browser.tabs.remote.force-enable and set it to true.
 - [Touchegg](https://github.com/JoseExposito/touchegg/issues/281#issuecomment-255712894): This enable some multitouch gesture on touchscreen and you can use it like a touchpad. It works only with non-libinput backend. Works good on XFCE. Won't work with GNOME, Elementary OS. [Issue](https://github.com/JoseExposito/touchegg/issues/281) [Possible fix for GNOME, Elementary OS](https://github.com/JoseExposito/touchegg/issues/281#issuecomment-255712894) 
 You can install it by issuing "sudo apt-get install touchegg" and use, or try the [gpdpocket-touchegg-config](https://github.com/nexus511/gpd-ubuntu-packages) package by nexus511
 - [Libinput-gestures](https://github.com/bulletmark/libinput-gestures): This enable multitouch gestures. Works on GNOME, Unity, Elementary OS and Desktop Environment that use libinput as default. It supports Xorg and partially Wayland.

## Monitor CPU frequencies

You can monitor frequencies of cpu issuing:
```
cat /sys/bus/cpu/devices/cpu*/cpufreq/scaling_cur_freq
```

# Build with Docker

![Docker](https://github.com/stockmind/gpd-pocket-ubuntu-respin/raw/master/Docker.png)

You can respin iso and build kernels on a Docker environment easily. This build system will likely work on any x86 Docker supported platform. Tested and working on Linux and MacOS, builds on Windows not tested yet.

You just need to build the Docker image, or download it from Docker Hub, and follow the steps below.

## 1a. Download image from Docker Hub

```
docker pull stockmind/gpd-pocket-ubuntu-respin
```

## 1b. Or build the Docker image locally

Clone repository and run the following script to build the docker image

```
./docker-build-image.sh
```

Once the image is ready you can choose from the following steps:

## 2a. Respin ISO

To respin an ISO you need to place desired ISO in ```origin/``` folder of this repository then run:

a. Distro based on Unity, KDE, XFCE as Desktop Environment:    
```
./docker-respin.sh <iso-file-name-without-path>
```
b. Distro based on GNOME, Pantheon (Elementary OS) as Desktop Environment:
```
./docker-respin.sh <iso-file-name-without-path> gnome
```

Example:
```
./docker-respin.sh ubuntu-17.04-desktop-amd64.iso
```
Or:
```
./docker-respin.sh ubuntu-GNOME-17.04-desktop-amd64.iso gnome
```

Let it run, it will take from 10 to 30 minutes based on your internet connection and system speed.
Once done you will find output ISO in ```destination/``` folder of this repository named as  ```gpdpocket-<build-date>-<iso-file-name>.iso```.

## 2b. Build latest kernel

To build latest kernel you just need to run the following script:
```
./docker-build-kernel.sh
```

Let it run, it will take a while.
When it's done you can find the kernel zipped in ```destination/``` folder of this repository.

If you want to customize the .config flags edit the file in `kernel/.config` of this repository and launch kernel build script. Configuration will be copied over the Hans one before building.

If you want to build kernel using the original .config file provided by Hans instead of the one provided in this repository run the script with `keepconfig` argument:
```
./docker-build-kernel.sh keepconfig
```

## Stop running containers

If you made a mistake and want to stop the running containers in background for respinning or building you can use the stop script:
```
./docker-stop.sh
```

# Troubleshooting

## Blank screen on Live USB boot and white power led on

Press the power button to let the desktop load and look at issues below.

## Brightness management doesn't work

Brightness management is currently broken on a Live environment. You must install system on your drive to get it working.

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

## Video glitches and overlapping desktops when HDMI connected

Check your system displays settings and move your displays until they are not overlapping each others.

## System freeze or hangs on high temperatures, high load or randomly

Disable DPTF in BIOS (Unlocked BIOS might be required), that's what freezes the system before it reaches the hardcoded factory limit of 90 degree. 

## Audio crackling and noise through speakers and headphones

Update your system configuration with latest of this repository.
You can encounter noises if you use a kernel 4.14-rc5 or below (Hans de Goede kernel) or if your kernel was compiled with `CONFIG_INTEL_ATOMISP=y` (If you are not using Hans de Goede kernel patches or a kernel compiled by his repository below 4.14-rc5).
Set `CONFIG_INTEL_ATOMISP=y` to `CONFIG_INTEL_ATOMISP=n` and compile/install kernel. Noises should disappear.
You may still encounter noises while on headphones, in this case check that your HiFi headphones volume configuration is not too high.

Open the following file:

```
/usr/share/alsa/ucm/chtrt5645/HiFi.conf
```


And check that `cset "name='Headphone Playback Volume'"` is not too high. A good value seems to range between 25 and 30.

Thanks to [Petr Matula @petrmatula](https://github.com/petrmatula190) for discovering and tests!

## Audio jack disconnected on volume over 70-80% (only Linux behaviour) with some headphones

Audio jack may get disconnected on some headsets when volume is set over 70-80%. Windows does't have this problem with official GPD audio drivers. Windows have the same problem only when you using unofficial audio drivers (only one accept way is update audio driver over device manager). 
This doesn't seems to happen on tiny headphones. When this happen audio start to have a crackling noise again. To fix this you should restart pulseaudio and audio player.

To restart pulseaudio issue the following command

```
pulseaudio --kill && pulseaudio --start
```
or 
```
pulseaudio -k
```

[Video of the problem](https://www.youtube.com/watch?v=Dnm0bOqcVTk) by [Petr Matula @petrmatula](https://github.com/petrmatula190)  (enable subtitles!)

## Google Chrome tearing, glitch or flickering while scrolling or browsing heavy web pages

Chrome doens't seems to behave great with the i915 intel driver, a workaround for the glitches or flickering while scrolling pages or seeing video is to set "GPU Rasterization" to "Force-Enabled for all layers". Quick link: [chrome://flags/#enable-gpu-rasterization](chrome://flags/#enable-gpu-rasterization)

## Why is system UI so big?

The scaling ratio is set to `2` to be able to read on the screen but it sure takes of a lot of space out of the FullHD screen.
Things will be more aliased and have better edge but take more space on screen.
To restore to native pixel resolution you have to edit the scale configuration:
```
sudo nano /etc/X11/Xsession.d/90-scale
```
You have to edit all the values to their default:
```
gsettings set com.ubuntu.user-interface scale-factor "{'DSI-1': 8, 'DSI1': 8}" // Unity
gsettings set org.gnome.desktop.interface scaling-factor 1 // Gnome 3
gsettings set org.gnome.desktop.interface text-scaling-factor 1 // Gnome 3
gsettings set org.cinnamon.desktop.interface scaling-factor 1 // Cinnamon
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1 // Cinnamon
```

This will affect all the different desktop environments. This might require a log-out, log-in, or reboot to take effect. Restarting the display manager service will also work.
This way you can still read fine (if you have good 👀 ) and have all your pixels back.

## Touchscreen or display rotation is wrong after wake/sleep or screen lock

Sometimes it may happen that rotation of touch or display is wrong due to several factor, particularly on GNOME or derived Desktop Environments. You can fix this simply selecting with mouse the GPD Screen Rotation icon on the tray bar ( ![GPD Screen Rotation icon](https://github.com/stockmind/gpd-pocket-screen-indicator/raw/b26ef297ab46e1cb0c6534ff66571d60e10b25ad/icons/screen-rotation-button-black.png) ) and clicking on the desired rotation on menu.

Ex.
If your display is rotated in landscape correctly but touchscreen is not aligned, you can select "Rotate landscape" to fix this. The opposite is also valid.
The script will do it's best to compensate the alignment problems that may happen.

## Touchscreen stop to respond

You can try to use the "Reset touchscreen" option from the GPD Screen Rotation icon on your tray bar ( ![GPD Screen Rotation icon](https://github.com/stockmind/gpd-pocket-screen-indicator/raw/b26ef297ab46e1cb0c6534ff66571d60e10b25ad/icons/screen-rotation-button-black.png) ). It will ask for your password. Wait for 5 seconds than retry to use touchscreen. If problem persist try to put system in sleep for a bit or reboot your device.

## No GPD Screen Rotation icon on GNOME Shell

[Check this](https://github.com/stockmind/gpd-pocket-screen-indicator#gnome-shell-users)

## No GPD Screen Rotation icon shows at boot

In some system it may happen that tray icon won't show at boot. Try to run in a terminal

    gpdscreen-indicator
    
If it works add "gpdscreen-indicator" command to your system "Startup Application" utility to run it at boot.

# Problem reporting

To report a problem clone the repo, run "problem-reporting.sh" script and attach the output to your github issue. This will help debugging.

```
sudo ./problem-reporting.sh
```

# Donate

If my work helped you consider a little donation to buy me a coffe... or an energy drink! :smile:

**Paypal**

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YYGKKE6FDX2KY)

**Bitcoin**

[![Donate Bitcoin](https://stockmind.github.io/donate-bitcoin/bitcoin-button.png)](https://stockmind.github.io/donate-bitcoin/)
