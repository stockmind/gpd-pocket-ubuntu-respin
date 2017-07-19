#!/usr/bin/env bash

cp gpdtouch.sh /usr/local/sbin/gpdtouch
chmod +x /usr/local/sbin/gpdtouch

cp gpdtouch.service /etc/systemd/system/gpdtouch.service
chmod 0644 /etc/systemd/system/gpdtouch.service

systemctl enable gpdtouch.service
