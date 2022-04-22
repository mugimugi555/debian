#!/usr/bin/bash

# wget

#-----------------------------------------------------------------------------------------------------------------------
# add USER sudors
#-----------------------------------------------------------------------------------------------------------------------
su ;
LOGIN_USER=`users | cut -d " " -f1` ;
echo $LOGIN_USER ;
gpasswd -a $LOGIN_USER sudo ;
exit ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo ;

#-----------------------------------------------------------------------------------------------------------------------
# replace repository
#-----------------------------------------------------------------------------------------------------------------------

# https://wiki.debian.org/SourcesList

sudo echo ;
sudo cp /etc/apt/sources.list /etc/apt/sources.list.back ;

#
MY_REPOSITORY=$(cat<<TEXT
deb http://deb.debian.org/debian bullseye main
deb-src http://deb.debian.org/debian bullseye main
deb http://deb.debian.org/debian-security/ bullseye-security main
deb-src http://deb.debian.org/debian-security/ bullseye-security main
deb http://deb.debian.org/debian bullseye-updates main
deb-src http://deb.debian.org/debian bullseye-updates main
TEXT
)
echo "$MY_REPOSITORY" | sudo tee /etc/apt/sources.list ;

MY_REPOSITORY=$(cat<<TEXT
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free
TEXT
)
echo "$MY_REPOSITORY" | sudo tee /etc/apt/sources.list ;

#
sudo apt update ;
sudo apt upgrade -y ;

#-----------------------------------------------------------------------------------------------------------------------
# set locale
#-----------------------------------------------------------------------------------------------------------------------
sudo echo Asia/Tokyo | sudo tee /etc/timezone ;
sudo dpkg-reconfigure -f noninteractive tzdata ;
LANG=C xdg-user-dirs-gtk-update ;

#-----------------------------------------------------------------------------------------------------------------------
# settings
#-----------------------------------------------------------------------------------------------------------------------
gsettings set org.gnome.desktop.interface enable-animations false           ;
gsettings set org.gnome.desktop.session idle-delay 0                        ;
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false        ;

#-----------------------------------------------------------------------------------------------------------------------
# wall paper
#-----------------------------------------------------------------------------------------------------------------------
wget http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O /home/$USER/Pictures/1.jpg ;
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/1.jpg" ;

#-----------------------------------------------------------------------------------------------------------------------
# software
#-----------------------------------------------------------------------------------------------------------------------
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections ;
echo "samba-common samba-common/dhcp boolean true"           | sudo debconf-set-selections ;
echo "samba-common samba-common/do_debconf boolean true"     | sudo debconf-set-selections ;
sudo apt install -y wget unar gedit build-essential \
  emacs-nox htop curl git axel samba openssh-server \
  net-tools exfat-fuse exfat-utils ffmpeg ibus-mozc imagemagick lame unar vlc ;

#-----------------------------------------------------------------------------------------------------------------------
# install app
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y snapd ;
sudo snap install gimp ;

#-----------------------------------------------------------------------------------------------------------------------
# chrome
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y chromium chromium-l10n ;
echo "alias chrome='chromium'" >> ~/.profile ;
source ~/.profile ;

#-----------------------------------------------------------------------------------------------------------------------
# youtube
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y python3-pip ;
sudo -H pip install --upgrade youtube-dl ;

#-----------------------------------------------------------------------------------------------------------------------
# nodejs yarn
#-----------------------------------------------------------------------------------------------------------------------

cd ;
wget https://raw.githubusercontent.com/mugimugi555/ubuntu/main/install_yarn.sh && bash install_yarn.sh ;
wget https://raw.githubusercontent.com/mugimugi555/ubuntu/main/install_nodejs.sh && bash install_nodejs.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# caps to ctrl
#-----------------------------------------------------------------------------------------------------------------------
cat /etc/default/keyboard
CAPS2CTRL=$(cat<<TEXT
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
TEXT
)
sudo echo "$CAPS2CTRL" | sudo tee /etc/default/keyboard
MYKEYBOARD=$(cat<<TEXT
<component>
  <version>2.23.2815.102+dfsg-8ubuntu1</version>
  <name>com.google.IBus.Mozc</name>
  <license>New BSD</license>
  <exec>/usr/lib/ibus-mozc/ibus-engine-mozc --ibus</exec>
  <textdomain>ibus-mozc</textdomain>
  <author>Google Inc.</author>
  <homepage>https://github.com/google/mozc</homepage>
  <description>Mozc Component</description>
<engines>
<engine>
  <description>Mozc (Japanese Input Method)</description>
  <language>ja</language>
  <symbol>&#x3042;</symbol>
  <rank>80</rank>
  <icon_prop_key>InputMode</icon_prop_key>
  <icon>/usr/share/ibus-mozc/product_icon.png</icon>
  <setup>/usr/lib/mozc/mozc_tool --mode=config_dialog</setup>
  <layout>jp</layout>
  <name>mozc-jp</name>
  <longname>Mozc</longname>
</engine>
</engines>
</component>
TEXT
)
sudo echo "$MYKEYBOARD" | sudo tee /usr/share/ibus/component/mozc.xml ;

sudo apt autoremove -y ;
