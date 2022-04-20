#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/debian/main/install_jquake.sh && bash install_jquake.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y openjdk-11-jdk ;
sudo apt install -y gtk2-engines-pixbuf ;
sudo apt install -y libcanberra-gtk* ;

#-----------------------------------------------------------------------------------------------------------------------
# install jquake
#-----------------------------------------------------------------------------------------------------------------------
cd ;
mkdir jquake ;
cd jquake ;
wget https://fleneindre.github.io/downloads/JQuake_1.6.2_linux.zip ;
unzip JQuake_1.6.2_linux.zip ;

#-----------------------------------------------------------------------------------------------------------------------
# launch jquake
#-----------------------------------------------------------------------------------------------------------------------
bash JQuake.sh &

#-----------------------------------------------------------------------------------------------------------------------
# create screenshot script
#-----------------------------------------------------------------------------------------------------------------------

# install screenshot library
sudo apt install -y wmctrl ;

# create web directory
sudo mkdir /var/www/html/earthquake/ ;
sudo chown $USER:$USER /var/www/html/earthquake/ ;

# get display number
MY_DISPLAY=`env | grep DISPLAY` ;
echo $MY_DISPLAY ;

# create bash file
MY_SCREENSHOT_JQUAKE=$(cat<<TEXT
#!/usr/bin/bash

export $MY_DISPLAY ;
wmctrl -a "JQuake" ;

gnome-screenshot -w -B -e none -f /var/www/html/earthquake/capture.png ;
#convert /var/www/html/earthquake/capture.png -crop 728x480+10+45 /var/www/html/earthquake/capture_triming.png ;
convert /var/www/html/earthquake/capture.png  /var/www/html/earthquake/capture_triming.png ;

TEXT
)
echo "$MY_SCREENSHOT_JQUAKE" > do_screenshot.sh ;
chmod +x do_screenshot.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# do screenshot
#-----------------------------------------------------------------------------------------------------------------------
./do_screenshot.sh;
