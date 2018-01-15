#!/usr/bin/env bash

wget https://raw.githubusercontent.com/jwrdegoede/linux-sunxi/master/.config -O jwrdegoede-config
wget https://raw.githubusercontent.com/stockmind/gpd-pocket-ubuntu-respin/master/kernel/.config -O stockmind-config
wget https://raw.githubusercontent.com/petrmatula190/gpd-pocket-kernel/master/.config -O petrmatula190-config

# Compare config to check new flags that may be missing 
diff -u stockmind-config jwrdegoede-config > config-stockmind.patch
diff -u petrmatula190-config stockmind-config > config-petrmatula190.patch