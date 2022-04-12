#!/usr/bin/bash

#
sudo apt install -y openjdk-11-jdk ;

#
mkdir jquake ;
cd jquake ;
wget https://fleneindre.github.io/downloads/JQuake_1.6.2_linux.zip ;
unzip JQuake_1.6.2_linux.zip ;

#
sudo apt install -y gtk2-engines-pixbuf ;
sudo apt install -y libcanberra-gtk* ;

#
bash JQuake.sh & ;

#
sudo mkdir /var/www/html/earthquake/ ;
sudo chown $USER:$USER /var/www/html/earthquake/ ;
sudo apt install -y wmctrl ;

env | grep DISPLAY

#!/usr/bin/bash

export DISPLAY=:0 ;
wmctrl -a "JQuake" ;
gnome-screenshot -w -B -e none -f /var/www/html/earthquake/capture.png ;
#convert /var/www/html/earthquake/capture.png -crop 728x480+10+45 /var/www/html/earthquake/capture_triming.png ;
convert /var/www/html/earthquake/capture.png  /var/www/html/earthquake/capture_triming.png ;
