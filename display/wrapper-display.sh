#!/bin/bash

cd /usr/local/bin
cp 90-touch /etc/X11/Xsession.d/90-touch
cp 90-scale /etc/X11/Xsession.d/90-scale
cp 90-rotate /etc/X11/Xsession.d/90-rotate

chmod 644 /etc/X11/Xsession.d/90-touch
chmod 644 /etc/X11/Xsession.d/90-scale
chmod 644 /etc/X11/Xsession.d/90-rotate

mkdir -p /etc/X11/xorg.conf.d/
cp 20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp 30-monitor.conf /etc/X11/xorg.conf.d/30-monitor.conf

# patch SDDM / KDE DPI config if exist
if [ -f /usr/share/sddm/scripts/Xsetup ]; then
  echo "xrandr --dpi 168" >> /usr/share/sddm/scripts/Xsetup # Scaling 175%
fi

rm -f 20-intel.conf 30-monitor.conf 90-touch 90-scale 90-rotate wrapper-display.sh
