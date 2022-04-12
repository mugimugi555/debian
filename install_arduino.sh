#!/usr/bin/bash

#
cd ;
wget https://downloads.arduino.cc/arduino-1.8.19-linux32.tar.xz
tar xvf arduino-1.8.19-linux32.tar.xz ;
cd arduino-1.8.19 ;

#
./arduino-linux-setup.sh $USER ;

#
./arduino &
