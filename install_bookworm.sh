#
sudo apt update ;
sudo apt upgrade -y ;
sudo apt full-upgrade -y ;
sudo apt autoremove -y ;
#sudo systemctl reboot ;

#
uname -mr ;
cat /etc/debian_version ;

#
echo $USER ;
sudo cp -v /etc/apt/sources.list /home/$USER/ ;
sudo cp -vr /etc/apt/sources.list.d/ /home/$USER/ ;

#-----------------------------------------------------------------------------------------------------------------------
# update sourcelist
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

#
sudo apt update ;
sudo apt upgrade -y ;
