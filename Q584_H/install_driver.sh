#!/usr/bin/bash

#

# gpu
sudo apt install -y i965-va-driver-shaders ;
sudo apt install -y vainfo ;

# video
sudo apt purge -y xserver-xorg-video-intel ;
sudo apt install -y firmware-intel-sound ;

# wifi
#wget https://raw.githubusercontent.com/jfwells/linux-asus-t100ta/master/nvram/lib/firmware/brcm/brcmfmac43241b4-sdio.txt ;
#sudo mkdir -p /lib/firmware/brcm/ ;
#sudo cp lib/firmware/brcm/brcmfmac43241b4-sdio.txt /lib/firmware/brcm/brcmfmac43241b4-sdio.txt ;

#
wget http://ftp.jp.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-brcm80211_20210818-1_all.deb ;
sudo dpkg -i firmware-brcm80211_20210818-1_all.deb ;
