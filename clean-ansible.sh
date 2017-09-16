#!/bin/bash

# This is an experimental clean script, use at your own risk
# This script is used to clean configuration files of Ansible Playbook for GPD Pocket

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

rm -f /etc/dconf/db/local.d/01scale
rm -f /etc/dconf/db/local.d/02subpixel
rm -f /etc/dconf/db/local.d/03scaling
rm -f /etc/dconf/db/local.d/03scaling
rm -f /etc/dconf/profile/gdm/profile
rm -f /etc/dconf/profile/user/profile
rm -f /etc/X11/Xsession.d/01gpd-rotate
rm -f /etc/X11/xinit/xinitrc.d/01gpd-rotate
rm -f /etc/gpd/rotate.conf
rm -f /usr/local/sbin/gpd-rotate
rm -f /etc/systemd/system/gpd-rotate.service
rm -f /etc/gpdfand.conf
rm -f /etc/X11/Xsession.d/01_touchegg
rm -f /etc/X11/xinit/xinitrc.d/01_touchegg
rm -f /etc/systemd/system/gpdfand.service
rm -f /etc/systemd/system/gpdrotate.service
rm -f /etc/udev/rules.d/99-local-bluetooth.rules
rm -f /etc/X11/xorg.conf.d/30-monitor.conf
rm -f /etc/X11/xorg.conf.d/80-screen.conf
rm -f /etc/X11/xorg.conf.d/89-screen.conf
rm -f /etc/X11/xorg.conf.d/90-monitor.conf
rm -f /etc/X11/xorg.conf.d/90-screen.conf
rm -f /etc/X11/Xsession.d/01gpdrotate
rm -f /etc/X11/Xsession.d/01touchscreen
rm -f /etc/X11/Xsession.d/02gpdrotate
rm -f /etc/X11/Xsession.d/02scale
rm -f /etc/X11/Xsession.d/03scaling
rm -f /etc/X11/Xsession.d/03scrolling
rm -f /etc/X11/Xsession.d/04gpdrotate
rm -f /etc/X11/Xsession.d/98gpdrotate
rm -f /etc/X11/Xsession.d/98touchscreen
rm -f /etc/X11/Xsession.d/99touchscreen
rm -f /lib/systemd/system-sleep/gpdfand
rm -f /root/ansible-gpdpocket
rm -f /usr/local/bin/gpdfand
rm -f /usr/local/bin/ansible-update
rm -f /usr/local/sbin/gpdfand
rm -f /usr/local/sbin/gpdrotate
rm -f /usr/src/linux-gpdpocket
rm -f /var/lib/gdm3/.config/monitors.xml
rm -f /var/lib/lightdm/.config/monitors.xml
rm -f /var/log/gpdfand
