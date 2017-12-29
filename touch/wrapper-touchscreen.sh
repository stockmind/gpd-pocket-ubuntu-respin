#!/bin/bash

cd /usr/local/bin

# copy touchscreen service files
cp goodix-resume.service /etc/systemd/system/goodix-resume.service
cp goodix-sleep.service /etc/systemd/system/goodix-sleep.service


# set permissionss
chmod 0644 /etc/systemd/system/goodix-resume.service
chmod 0644 /etc/systemd/system/goodix-sleep.service

# enable and start touchscreen services
systemctl enable goodix-resume.service
systemctl enable goodix-sleep.service

rm -f goodix-resume.service goodix-sleep.service
