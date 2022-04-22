#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/debian/main/Q584_H/install_vnc_viewer.sh && bash install_vnc_viewer.sh ;

echo 'deb http://ftp.debian.org/debian stretch-backports main' | sudo tee --append /etc/apt/sources.list.d/stretch-backports.list >> /dev/null ;
sudo apt update ;
sudo apt install -t stretch-backports remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice ;
