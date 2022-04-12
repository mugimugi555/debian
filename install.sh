#!/usr/bin/bash

# wget

# https://blog.klovnin.net/archives/786

#-----------------------------------------------------------------------------------------------------------------------
# add USER sudors
#-----------------------------------------------------------------------------------------------------------------------
su ;
LOGIN_USER=`users | cut -d " " -f1` ;
echo $LOGIN_USER ;
gpasswd -a $LOGIN_USER sudo ;
exit ;

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
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y emacs-nox htop curl git axel samba openssh-server net-tools exfat-fuse exfat-utils ffmpeg ibus-mozc imagemagick lame unar vlc ;

#-----------------------------------------------------------------------------------------------------------------------
# install app
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y wget git curl htop net-tools emacs-nox lame unar axel vlc gedit build-essential ffmpeg imagemagick ;
sudo apt install -y chromium ;
sudo apt install -y openssh-server ;
sudo apt install -y snapd ;
sudo snap install gimp ;

#-----------------------------------------------------------------------------------------------------------------------
# youtube
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y python3-pip ;
sudo -H pip install --upgrade youtube-dl ;

#-----------------------------------------------------------------------------------------------------------------------
# nodejs yarn
#-----------------------------------------------------------------------------------------------------------------------

cd ;
wget https://raw.githubusercontent.com/mugimugi555/ubuntu/main/install_nodejs.sh && bash install_nodejs.sh ;
wget https://raw.githubusercontent.com/mugimugi555/ubuntu/main/install_yarn.sh && bash install_yarn.sh ;

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

#-----------------------------------------------------------------------------------------------------------------------
# add php repository
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y ca-certificates apt-transport-https software-properties-common wget curl lsb-release ;
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x ;

#-----------------------------------------------------------------------------------------------------------------------
# install apache php mysql
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y \
  apache2 \
  php php-cli php-fpm php-mbstring php-mysql php-curl php-gd php-curl php-zip php-xml \
  mariadb-server ;

#-----------------------------------------------------------------------------------------------------------------------
# enable php-fpm
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y libapache2-mod-fcgid ;
sudo a2enmod proxy_fcgi setenvif ;
PHPVERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".") ;
sudo a2enconf php$PHPVERSION-fpm ;
sudo systemctl reload apache2
sudo systemctl stop apache2 ;
sudo systemctl start apache2 ;
#sudo systemctl status php$PHPVERSION-fpm ;

#-----------------------------------------------------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------------------------------------------------
sudo rm /var/www/html/index.html ;
echo "<?php phpinfo(); " | sudo tee /var/www/html/index.php ;
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit => http://$LOCAL_IPADDRESS/" ;
echo "======================================" ;

#-----------------------------------------------------------------------------------------------------------------------
# install lamp
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y \
  apache2 \
  php php-xml php-bcmath php-mbstring php-xml php-zip \
  mariadb-server ;

#-----------------------------------------------------------------------------------------------------------------------
# install composer
#-----------------------------------------------------------------------------------------------------------------------
cd ;
php -r "copy ( 'https://getcomposer.org/installer', 'composer-setup.php' ) ;" ;
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer ;
composer -v ;

#-----------------------------------------------------------------------------------------------------------------------
# install laravel
#-----------------------------------------------------------------------------------------------------------------------
composer global require laravel/installer ;
echo 'PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.profile ;
source .profile ;

#-----------------------------------------------------------------------------------------------------------------------
# create testproject
#-----------------------------------------------------------------------------------------------------------------------
cd ;
mkdir mylaravel ;
cd mylaravel
laravel new testproject ;
sudo chown www-data:www-data -R testproject/storage testproject/bootstrap/cache ;

sudo ln -s /home/$USER/mylaravel/testproject/public/ /var/www/html/testproject

#-----------------------------------------------------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit => http://$LOCAL_IPADDRESS/testproject/" ;
echo "======================================" ;


#-----------------------------------------------------------------------------------------------------------------------
# rails
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y sqlite3 libsqlite3-dev ;
sudo apt install -y git-all ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y yarn ;
sudo apt install -y sqlite3 libsqlite3-dev ;
sudo apt install -y git-all ;

#-----------------------------------------------------------------------------------------------------------------------
# install rbenv
#-----------------------------------------------------------------------------------------------------------------------

# setting rbenv
cd ;
git clone https://github.com/rbenv/rbenv.git ~/.rbenv ;
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile ;
source ~/.profile ;

# setting rbenv selected version
rbenv init ;
echo 'eval "$(rbenv init - bash)"' >> ~/.profile ;
source ~/.profile ;

# create rbenv custom ruby version
mkdir -p ~/.rbenv/plugins ;
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build ;
sudo apt install -y                         \
	autoconf bison build-essential libssl-dev \
	libyaml-dev libreadline6-dev zlib1g-dev   \
	libncurses5-dev libffi-dev libgdbm6 libgdbm-dev ;
rbenv install -l ;
rbenv install $(rbenv install -l | grep -v - | tail -1) ;
rbenv global 3.1.1 ;
rbenv versions ;

#-----------------------------------------------------------------------------------------------------------------------
# install rails
#-----------------------------------------------------------------------------------------------------------------------
gem search -ea rails ;
gem install rails ;
rails -v ;
gem list rails ;

#-----------------------------------------------------------------------------------------------------------------------
# create rails project
#-----------------------------------------------------------------------------------------------------------------------
cd ;
mkdir railsProjects ;
cd railsProjects ;
rails new blog ;
cd blog ;

#-----------------------------------------------------------------------------------------------------------------------
# set service
#-----------------------------------------------------------------------------------------------------------------------
# bin/rails server -b $LOCAL_IPADDRESS -p 3000 ;
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
RAILS_SERVICE=$(cat<<TEXT
[Unit]
Description=RailsBlog
After=network.target
[Service]
Type=simple
Environment="PATH=/home/$USER/.rbenv/shims:/home/$USER/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
WorkingDirectory=/home/$USER/railsProjects/blog
ExecStart=/home/$USER/railsProjects/blog/bin/rails server -b $LOCAL_IPADDRESS -p 3000
Restart=always
[Install]
WantedBy=default.target
TEXT
)
echo "$RAILS_SERVICE" | sudo tee /etc/systemd/system/rails_blog.service ;
sudo systemctl enable rails_blog.service ;
sudo systemctl stop rails_blog.service ;
sudo systemctl start rails_blog.service ;
sudo systemctl status rails_blog.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "=======================================";
echo "visit => http://$LOCAL_IPADDRESS:3000/" ;
echo "=======================================";

sudo apt autoremove -y ;
