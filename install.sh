su ;
LOGIN_USER=`users | cut -d " " -f1` ;
echo $LOGIN_USER ;
gpasswd -a $LOGIN_USER sudo ;
exit ;


sudo echo ;
sudo cp /etc/apt/sources.list /etc/apt/sources.list.back

MY_REPOSITORY=$(cat<<TEXT
deb http://deb.debian.org/debian bullseye main
deb-src http://deb.debian.org/debian bullseye main

deb http://deb.debian.org/debian-security/ bullseye-security main
deb-src http://deb.debian.org/debian-security/ bullseye-security main

deb http://deb.debian.org/debian bullseye-updates main
deb-src http://deb.debian.org/debian bullseye-updates main
TEXT
)

echo "$MY_REPOSITORY" | sudo tee /etc/apt/sources.list
