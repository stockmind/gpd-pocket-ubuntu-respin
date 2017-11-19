#!/bin/bash
# Run this as normal user

alsactl restore -P
rm -rfd ~/.config/pulse/*
pulseaudio --kill && pulseaudio --start
