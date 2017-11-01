#!/bin/bash

mkdir -p update-kernel
cd update-kernel

if [ ! -f gpdpocket-kernel-4.14rc4-noatomisp-fixaudio_v2.zip ]; then
	 echo "Downloading kernel files...."
	 wget https://bitbucket.org/simone_nunzi/gpdpocket-kernel/downloads/gpdpocket-kernel-4.14rc4-noatomisp-fixaudio_v2.zip
fi

echo "Extracting kernel files..."
unzip -o gpdpocket-kernel-4.14rc4-noatomisp-fixaudio_v2.zip

echo "Installing kernel..."
sudo dpkg -i *.deb

echo "Update grub..."
sudo update-grub

rm *.deb
cd ..
rm -rfd update-kernel
