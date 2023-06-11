#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/debian/main/install_bookworm.sh && bash install_bookworm.sh ;

# https://www.debugpoint.com/upgrade-debian-12-from-debian-11/

#-----------------------------------------------------------------------------------------------------------------------
# update
#-----------------------------------------------------------------------------------------------------------------------
sudo echo ;
sudo apt update ;
sudo apt upgrade -y ;
sudo apt full-upgrade -y ;
sudo apt autoremove -y ;
sudo apt autoclean -y ;
#sudo systemctl reboot ;

#-----------------------------------------------------------------------------------------------------------------------
# show version
#-----------------------------------------------------------------------------------------------------------------------
uname -mr ;
cat /etc/debian_version ;

#-----------------------------------------------------------------------------------------------------------------------
# backup sourcelist
#-----------------------------------------------------------------------------------------------------------------------
echo $USER ;
sudo cp -v /etc/apt/sources.list /home/$USER/ ;
sudo cp -vr /etc/apt/sources.list.d/ /home/$USER/ ;

#-----------------------------------------------------------------------------------------------------------------------
# update sourcelist file
#-----------------------------------------------------------------------------------------------------------------------
NEWSOURCE=$(cat<<TEXT
deb http://deb.debian.org/debian/ bookworm main
deb-src http://deb.debian.org/debian/ bookworm main

deb http://security.debian.org/debian-security bookworm-security main
deb-src http://security.debian.org/debian-security bookworm-security main

deb http://deb.debian.org/debian/ bookworm-updates main
deb-src http://deb.debian.org/debian/ bookworm-updates main

deb http://deb.debian.org/debian bookworm non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm non-free non-free-firmware

deb http://deb.debian.org/debian-security bookworm-security non-free non-free-firmware
deb-src http://deb.debian.org/debian-security bookworm-security non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-updates non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates non-free non-free-firmware
TEXT
)
sudo echo "$NEWSOURCE" | sudo tee /etc/apt/sources.list ;

#-----------------------------------------------------------------------------------------------------------------------
# upgrade to bookworm
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt full-upgrade -y ;
sudo apt autoremove -y ;
sudo apt autoclean -y ;

#-----------------------------------------------------------------------------------------------------------------------
# show version
#-----------------------------------------------------------------------------------------------------------------------
uname -mr ;
cat /etc/debian_version ;
