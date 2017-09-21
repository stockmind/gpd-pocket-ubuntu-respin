#!/bin/bash

cd /usr/local/bin
cp 90-scale /etc/X11/Xsession.d/90-scale
cp 90-interface /etc/X11/Xsession.d/90-interface
chmod 644 /etc/X11/Xsession.d/90-scale
chmod 644 /etc/X11/Xsession.d/90-interface

# Download rotation daemons and indicator
mkdir -p temp
cd temp
git clone https://github.com/stockmind/gpd-pocket-screen-indicator.git
cd gpd-pocket-screen-indicator
chmod +x install.sh
sudo ./install.sh
cd ../../
rm -fr temp

cp monitors.xml /usr/share/monitors.xml
cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

mkdir -p /etc/X11/xorg.conf.d/
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 30-monitor.conf /etc/X11/xorg.conf.d/30-monitor.conf
cp 35-screen.conf /etc/X11/xorg.conf.d/35-screen.conf
cp 40-touch.conf /etc/X11/xorg.conf.d/40-touch.conf
cp 40-trackpoint.conf /etc/X11/xorg.conf.d/40-trackpoint.conf

cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

# fix missing glyphs and graphic glitches on resume
echo "COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer" >> /etc/environment
echo "LIBGL_DRI3_DISABLE=1" >> /etc/environment

echo "i915" >> /etc/initramfs-tools/modules


# patch lightdm monitors config if folder exists
if [ -d /var/lib/lightdm ]; then
  mkdir -p /var/lib/lightdm/.config/
  cp monitors.xml /var/lib/lightdm/.config/
  chown lightdm:lightdm /var/lib/lightdm/.config/monitors.xml
  chown lightdm:lightdm /var/lib/lightdm/.config
fi

# patch SDDM / KDE config if exist
if [ -f /usr/share/sddm/scripts/Xsetup ]; then
  echo "xrandr --output DSI-1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
  echo "xrandr --output DSI1 --rotate right" >> /usr/share/sddm/scripts/Xsetup # Rotate Monitor0
  echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%
fi

# patch GNOME 3 monitors config if folder exists
if [ -d /var/lib/gdm3 ]; then
  mkdir -p /var/lib/gdm3/.config/
  cp monitors.xml /var/lib/gdm3/.config/
  chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
  chown gdm:gdm /var/lib/gdm3/.config
fi

# patch GNOME 3 based distros monitors config if folder exists
if [ -d /etc/gnome/ ]; then
  mkdir -p /etc/gnome-settings-daemon/xrandr/
  cp monitors.xml /etc/gnome-settings-daemon/xrandr/
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
  mkdir -p /var/lib/mdm/.config/
  cp monitors.xml /var/lib/mdm/.config/
  chown gdm:gdm /var/lib/mdm/.config/monitors.xml
  chown gdm:gdm /var/lib/mdm/.config
fi

# update terminal font size
cp display/console-setup /etc/default/console-setup

rm -f adduser.local 20-intel.conf 30-monitor.conf 90-touch 90-scale wrapper-display.sh
