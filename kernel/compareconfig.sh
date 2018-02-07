#!/usr/bin/env bash

curl https://raw.githubusercontent.com/jwrdegoede/linux-sunxi/master/.config -o jwrdegoede-config
curl https://raw.githubusercontent.com/stockmind/gpd-pocket-ubuntu-respin/master/kernel/.config -o stockmind-config
curl https://raw.githubusercontent.com/petrmatula190/gpd-pocket-kernel/master/.config -o petrmatula190-config

# Compare config to check new flags that may be missing 
diff -u stockmind-config jwrdegoede-config > config-stockmind.patch
diff -u petrmatula190-config stockmind-config > config-petrmatula190.patch