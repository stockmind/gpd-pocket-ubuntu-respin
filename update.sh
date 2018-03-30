#!/usr/bin/env bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Check arguments
for i in "$@" ; do
    if [[ $i == "gnome" ]] ; then
        echo "Setting gnome monitors..."
        GNOME=true
        break
    fi
    if [[ $i == "kde" ]] ; then
        echo "Setting kde environment..."
        KDE=true
        break
    fi
done

if [ -n "$GNOME" ]; then
	echo "Display setting: Gnome"
	cp display/monitors_gnome.xml display/monitors.xml
else
	echo "Display setting: Xorg-Standard"
	cp display/monitors_xorg.xml display/monitors.xml
fi

# refresh packages list
apt update

# remove conflicting packages
echo "Remove conflicting packages..."
apt-get -y purge bcmwl-kernel-source

# install required packages
echo "Install required packages..."
for i in thermald tlp va-driver-all vainfo libva1 libva2 i965-va-driver gstreamer1.0-libav gstreamer1.0-vaapi python-gi gksu git python gir1.2-appindicator3-0.1 xfonts-terminus; do
  sudo apt-get install -y $i
done

# remove old display files
echo "Remove old configuration files..."
rm -f /etc/X11/Xsession.d/90x11-rotate_and_scale
rm -f /etc/X11/xorg.conf.d/90-monitor.conf

# update display files
echo "Update display files..."
cd display
cp 90-scale /etc/X11/Xsession.d/90-scale
cp 90-interface /etc/X11/Xsession.d/90-interface
chmod 644 /etc/X11/Xsession.d/90-scale
chmod 644 /etc/X11/Xsession.d/90-interface

# Make xorg conf directory if doesn't exists
mkdir -p /etc/X11/xorg.conf.d/

cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 30-monitor.conf /etc/X11/xorg.conf.d/30-monitor.conf
cp 35-screen.conf /etc/X11/xorg.conf.d/35-screen.conf
cp 40-touch.conf /etc/X11/xorg.conf.d/40-touch.conf
cp 40-trackpoint.conf /etc/X11/xorg.conf.d/40-trackpoint.conf

# remove rules to rotate screen of 90 degree right on driver load
rm -f /etc/udev/rules.d/99-goodix-touch.rules

# patch lightdm monitors config if folder exists
if [ -d /var/lib/lightdm ]; then
  echo "Patching lightdm files..."
  mkdir -p /var/lib/lightdm/.config/
  cp monitors.xml /var/lib/lightdm/.config/
  chown lightdm:lightdm /var/lib/lightdm/.config/monitors.xml
  chown lightdm:lightdm /var/lib/lightdm/.config
fi

# patch GNOME 3 monitors config if folder exists
if [ -d /var/lib/gdm3 ]; then
  echo "Patching Gnome3 files..."
  mkdir -p /var/lib/gdm3/.config/
  cp monitors.xml /var/lib/gdm3/.config/
  chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
  chown gdm:gdm /var/lib/gdm3/.config
fi

# patch GNOME wayland login setting
if [ -f /etc/gdm/custom.conf ]; then
  sed -i "s|#WaylandEnable=false|WaylandEnable=false|" /etc/gdm/custom.conf
fi
if [ -f /etc/gdm3/custom.conf ]; then
  sed -i "s|#WaylandEnable=false|WaylandEnable=false|" /etc/gdm3/custom.conf
fi

# patch MDM monitors config if folder exists
if [ -d /var/lib/mdm ]; then
  echo "Patching MDM files..."
  mkdir -p /var/lib/mdm/.config/
  cp monitors.xml /var/lib/mdm/.config/
  chown gdm:gdm /var/lib/mdm/.config/monitors.xml
  chown gdm:gdm /var/lib/mdm/.config
fi

# patch GNOME 3 based distros monitors config if folder exists
if [ -d /etc/gnome/ ]; then
  echo "Patching default gnome 3 xrandr files..."
  mkdir -p /etc/gnome-settings-daemon/xrandr/
  cp monitors.xml /etc/gnome-settings-daemon/xrandr/
fi

# patch SDDM / KDE config if exist
if [ -f /usr/share/sddm/scripts/Xsetup ]; then
  echo "Patching SDDM/KDE files..."
  if grep -Fxq "xrandr --output DSI1 --rotate right" /usr/share/sddm/scripts/Xsetup
  then 
    echo "KDE settings already present"
  else
    echo "xrandr --output DSI-1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
    echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
    echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%
  fi
  # Clean old setting
  if grep -Fxq "GDK_SCALE=2" /etc/environment
  then
    echo "Remove environment variable GDK_SCALE"
    sed -i "s|GDK_SCALE=2||" /etc/environment 
  fi
fi

if [ -n "$KDE" ]; then
  echo "KDE flag provided. No environemnt variable is needed."
  echo "Remove environment variable COGL_ATLAS_DEFAULT_BLIT_MODE"
  sed -i "s|COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer||" /etc/environment 
  echo "Remove environment variable LIBGL_DRI3_DISABLE"
  sed -i "s|LIBGL_DRI3_DISABLE=1||" /etc/environment
  # On KDE the following flags seems to give problems.
else
  # check that environment variable exists
  echo "Adding envrironment variables to prevent glitches..."
  if grep -Fxq "COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer" /etc/environment
  then 
    echo "Environment variable COGL_ATLAS_DEFAULT_BLIT_MODE already set"
  else
    echo "COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer" >> /etc/environment
  fi
  if grep -Fxq "LIBGL_DRI3_DISABLE=1" /etc/environment
  then
    echo "Environment variable LIBGL_DRI3_DISABLE already set"
  else
    echo "LIBGL_DRI3_DISABLE=1" >> /etc/environment   
  fi
fi

cd ..
# Download rotation daemons and indicator
mkdir -p temp
cd temp
git clone https://github.com/stockmind/gpd-pocket-screen-indicator.git
cd gpd-pocket-screen-indicator
chmod +x install.sh
sudo ./install.sh
cd ../../
rm -fr temp

# update GPD Fan daemon
echo "Update GPD Fan daemon"
cd fan
cp gpdfand.service /etc/systemd/system/gpdfand.service
cp gpdfand /lib/systemd/system-sleep/gpdfand
cp gpdfand.conf /etc/gpdfand.conf
cp gpdfand.py /usr/local/sbin/gpdfand
chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/sbin/gpdfand
chmod 0644 /etc/gpdfand.conf
chmod 0644 /etc/systemd/system/gpdfand.service
systemctl enable gpdfand.service
systemctl restart gpdfand.service

# check modules
echo "Check modules..."
if grep -Fxq "pwm-lpss" /etc/initramfs-tools/modules
then 
  echo "pwm-lpss module already present"
else
  echo "pwm-lpss" >> /etc/initramfs-tools/modules
fi
if grep -Fxq "pwm-lpss-platform" /etc/initramfs-tools/modules
then 
  echo "pwm-lpss-platform module already present"
else
  echo "pwm-lpss-platform" >> /etc/initramfs-tools/modules
fi
if grep -Fxq "btusb" /etc/initramfs-tools/modules
then 
  echo "btusb module already present"
else
  echo "btusb" >> /etc/initramfs-tools/modules
fi

if grep -Fxq "i915" /etc/initramfs-tools/modules
then 
  echo "i915 module already present"
else
  echo "i915" >> /etc/initramfs-tools/modules
fi

# update terminal font size
echo "Update console setup"
cp ../display/console-setup /etc/default/console-setup

echo "Update modules of last kernel"
update-initramfs -u

# update network files
echo "Update/Install network files..."
cd ../network
cp brcmfmac4356-pcie.txt /lib/firmware/brcm/brcmfmac4356-pcie.txt
mkdir -p /etc/pm/config.d/
touch /etc/pm/config.d/config
if grep -Fxq "SUSPEND_MODULES=\"brcmfmac\"" /etc/pm/config.d/config
then 
  echo "brcmfmac module already in SUSPEND_MODULE"
else
  echo "SUSPEND_MODULES=\"brcmfmac\"" >> /etc/pm/config.d/config
fi

# bluetooth enable
cp 99-local-bluetooth.rules /etc/udev/rules.d/99-local-bluetooth.rules

# update audio files
echo "Update/Install audio files..."
cd ../audio

mkdir -p /usr/share/alsa/ucm/chtrt5645
cp HiFi.conf /usr/share/alsa/ucm/chtrt5645/
cp chtrt5645.conf /usr/share/alsa/ucm/chtrt5645/

# copy headphones/speakers auto switch when jack is plugged in/out
mkdir -p /etc/acpi/events/
cp headphone-jack /etc/acpi/events/headphone-jack
cp headphone-jack.sh /etc/acpi/headphone-jack.sh
chmod +x /etc/acpi/headphone-jack.sh

# clean pulse user config
rm ~/.config/pulse/*

if grep -Fxq "set-card-profile alsa_card.platform-cht-bsw-rt5645 HiFi" /etc/pulse/default.pa
then 
  echo "set card profile already ok!"
else
  echo "set-card-profile alsa_card.platform-cht-bsw-rt5645 HiFi" >> /etc/pulse/default.pa
fi

if grep -Fxq "set-default-sink alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink" /etc/pulse/default.pa
then 
  echo "set card sink already ok!"
else
  echo "set-default-sink alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink" >> /etc/pulse/default.pa
fi

if grep -Fxq "set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink [Out] Speaker" /etc/pulse/default.pa
then 
  echo "set sink port already ok!"
else
  echo "set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink [Out] Speaker" >> /etc/pulse/default.pa
fi

# update grub
sudo sed -i "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=640x480/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1 gpd-pocket-fan.speed_on_ac=0\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1 gpd-pocket-fan.speed_on_ac=0\"/" /etc/default/grub

sudo update-grub
