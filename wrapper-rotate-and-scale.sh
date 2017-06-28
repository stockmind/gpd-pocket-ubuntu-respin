#!/bin/bash

cd /usr/local/bin
cp 90x11-rotate_and_scale /etc/X11/Xsession.d/90x11-rotate_and_scale
chmod 755 /etc/X11/Xsession.d/90x11-rotate_and_scale

cp monitors.xml /usr/share/monitors.xml
cp adduser.local /usr/local/sbin/adduser.local
chmod +x /usr/local/sbin/adduser.local

mkdir -p /var/lib/lightdm/.config/
cp monitors.xml /var/lib/lightdm/.config/
chown lightdm:lightdm /var/lib/lightdm/.config/monitors.xml

mkdir -p /etc/X11/xorg.conf.d/
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf

rm -f monitors.xml adduser.local 90x11-rotate_and_scale wrapper-rotate-and-scale.sh
