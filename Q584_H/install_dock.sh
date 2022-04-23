#!/usr/bin/bash

exit;

chrome https://micheleg.github.io/dash-to-dock/

wget https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v71.shell-extension.zip
unzip dash-to-dock@micxgx.gmail.com.zip -d ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/

git clone https://github.com/micheleg/dash-to-dock.git
make
make install

sudo apt install gnome-tweak-tool
sudo add-apt-repository universe
Now search “Dash to Dock” extension and click on the button to turn it “On”.
GNOME Tweak Tool”, go to the “Extensions”
