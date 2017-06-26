# Respin ISO for GPD Pocket
Collection of scripts and tweaks to adapt Ubuntu and Linux Mint ISO images to let them run smoothly on GPD Pocket.

All informations, tips and tricks was gathered from:
https://www.reddit.com/r/GPDPocket/comments/6idnia/linux_on_gpd_pocket/ - Amazing collection of tips and tricks to get all up and running
http://linuxiumcomau.blogspot.com/ - Respin script and info
http://hansdegoede.livejournal.com/ - Kernel patches and amazing work on Bay Trail and Cherry Trail devices

# Build iso image with tweaks

Build iso running this:

    ./isorespin.sh -i <ubuntu-iso-file> -l "*.deb" -p "libproc-daemon-perl libproc-pid-file-perl liblog-dispatch-perl thermald" -f 90x11-rotate_and_scale -f HiFi.conf -f chtrt5645.conf -f brcmfmac4356-pcie.txt -f wrapper-fix-sound-wifi.sh -f wrapper-rotate-and-scale.sh -f gpdfand -f gpdfand.service -f wrapper-gpd-fan-control.sh -f monitors.xml -f adduser.local -c wrapper-rotate-and-scale.sh -c wrapper-fix-sound-wifi.sh -c wrapper-gpd-fan-control.sh -g "i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable"
