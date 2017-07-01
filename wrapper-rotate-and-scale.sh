#!/bin/bash

cd /usr/local/bin
cp 90x11-rotate_and_scale /etc/X11/Xsession.d/90x11-rotate_and_scale
chmod 755 /etc/X11/Xsession.d/90x11-rotate_and_scale

cp monitors.xml /usr/share/monitors.xml
cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

mkdir -p /etc/X11/xorg.conf.d/
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 90-monitor.conf /etc/X11/xorg.conf.d/90-monitor.conf

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

rm -f monitors.xml adduser.local 90x11-rotate_and_scale wrapper-rotate-and-scale.sh
