#!/bin/bash

cd /usr/local/bin
cp 90-scale /etc/X11/Xsession.d/90-scale
chmod 644 /etc/X11/Xsession.d/90-scale

cp gpdtouch.sh /usr/local/sbin/gpdtouch
chmod +x /usr/local/sbin/gpdtouch

cp gpdtouch.service /etc/systemd/system/gpdtouch.service
chmod 0644 /etc/systemd/system/gpdtouch.service

systemctl enable gpdtouch.service

cp monitors.xml /usr/share/monitors.xml
cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

mkdir -p /etc/X11/xorg.conf.d/
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 30-monitor.conf /etc/X11/xorg.conf.d/30-monitor.conf

cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

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

# patch MDM monitors config if folder exists
if [ -d /var/lib/mdm ]; then
  mkdir -p /var/lib/mdm/.config/
  cp monitors.xml /var/lib/mdm/.config/
  chown gdm:gdm /var/lib/mdm/.config/monitors.xml
  chown gdm:gdm /var/lib/mdm/.config
fi

rm -f adduser.local 20-intel.conf 30-monitor.conf 90-touch 90-scale wrapper-display.sh
