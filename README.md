# Respin ISO for GPD Pocket
Collection of scripts and tweaks to adapt Debian, Ubuntu and Linux Mint ISO images and let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
 - https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Base project files and amazing collection of tips and tricks to get all up and running
 - http://linuxiumcomau.blogspot.com/ - Respin script and info
 - http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices
 
 Kudos and all the credits go to them! 

to make work:<br>
chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/bin/gpdfand<br>

apt-get -y install libproc-daemon-perl libproc-pid-file-perl liblog-dispatch-perl<br>

    ./build.sh <iso filenamme>
    
# Post install

Commands that should be run after first boot

## GRUB

Those commands will update your grub boot options to optimize the boot process for your intel Atom processor

    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
    sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable\"/" /etc/default/grub

    sudo update-grub
    
## GPDFAND

Check where *temp2_input, temp3_input, temp4_input, temp5_input* are located and update gdpfand service as needed.

    ls /sys/class/hwmon/hwmon0/ && \
    ls /sys/class/hwmon/hwmon1/ && \
    ls /sys/class/hwmon/hwmon2/ && \
    ls /sys/class/hwmon/hwmon3/ && \
    ls /sys/class/hwmon/hwmon4/
    
Mine for example are inside */sys/class/hwmon/hwmon3/* so i use this command to update the service:

    sed -i "s/\/sys\/class\/hwmon\/hwmon4\//\/sys\/class\/hwmon\/hwmon3\//" /usr/local/sbin/gpdfand
    
Then restart it

    systemctl stop gpdfand.service
    systemctl start gpdfand.service
    
Check status

    systemctl status gpdfand.service

# Download ISO

Download an already respinned ISO for GPD Pocket

https://mega.nz/#F!8WpQRZrD!0XHgajeG-QVZTp1Jbjndgw

