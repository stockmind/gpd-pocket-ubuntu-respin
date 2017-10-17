#!/bin/bash
set -e -u

if [ "$1" = "jack/headphone" -a "$2" = "HEADPHONE" ]; then
    case "$3" in
        plug)
            sink="[Out] Headphones"
            ;;
        *)
            sink="[Out] Speaker"
            ;;
    esac
    for userdir in /run/user/*; do
        uid="$(basename $userdir)"
        user="$(id -un $uid)"
        if [ -f "$userdir/pulse/pid" ]; then
            su "$user" -c "pacmd set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645__sink $sink"
        fi
    done
fi