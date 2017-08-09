#!/usr/bin/env bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Check arguments
for i in "$@" ; do
    if [[ $i == "wayland" ]] ; then
        echo "Setting wayland monitors..."
        WAYLAND=$i
        break
    fi
done

if [ -n "$WAYLAND" ]; then
	echo "Display setting: Wayland"
	cp display/monitors_wayland.xml display/monitors.xml
else
	echo "Display setting: Xorg"
	cp display/monitors_xorg.xml display/monitors.xml
fi

# remove conflicting packages
echo "Remove conflicting packages..."
apt-get -y purge bcmwl-kernel-source

# install required packages
echo "Install required packages..."
apt-get -y install thermald tlp va-driver-all vainfo libva1 i965-va-driver gstreamer1.0-libav gstreamer1.0-vaapi

# remove old display files
echo "Remove old configuration files..."
rm /etc/X11/Xsession.d/90x11-rotate_and_scale
rm /etc/X11/xorg.conf.d/90-monitor.conf

# update display files
echo "Update display files..."
cd display
cp 90-scale /etc/X11/Xsession.d/90-scale
cp 90-touch /etc/X11/Xsession.d/90-touch
cp 90-interface /etc/X11/Xsession.d/90-interface
chmod 644 /etc/X11/Xsession.d/90-scale
chmod 644 /etc/X11/Xsession.d/90-touch
chmod 644 /etc/X11/Xsession.d/90-interface
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 30-monitor.conf /etc/X11/xorg.conf.d/30-monitor.conf

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
  if grep -Fxq "GDK_SCALE=2" /etc/environment
  then
    echo "Remove environment variable GDK_SCALE"
    sed -i "s|GDK_SCALE=2||" /etc/environment 
  fi
fi

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


# Add touchscreen rotation daemon for login screens and wayland
echo "Update/Install touchscreen and display rotation daemon..."
cp gpdtouch.sh /usr/local/sbin/gpdtouch
chmod +x /usr/local/sbin/gpdtouch
cp gpdtouch /lib/systemd/system-sleep/gpdtouch
chmod +x /lib/systemd/system-sleep/gpdtouch
cp gpdtouch.service /etc/systemd/system/gpdtouch.service
cp gpdtouch-wake.service /etc/systemd/system/gpdtouch-wake.service
chmod 0644 /etc/systemd/system/gpdtouch.service
chmod 0644 /etc/systemd/system/gpdtouch-wake.service
systemctl enable gpdtouch.service
systemctl enable gpdtouch-wake.service

# update GPD Fan daemon
echo "Update GPD Fan daemon"
cd ../fan
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
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1\"/" /etc/default/grub
sudo update-grub
