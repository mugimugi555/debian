#!/bin/bash
set -e

# ======================= 基本設定と初期化 =======================

# ホームディレクトリ名を英語に
echo "🔹 ホームディレクトリ名を英語に変更します。"
LANG=C xdg-user-dirs-update --force

# GNOME の基本設定（Debianでgnome-coreインストール済みが前提）
echo "🔹 GNOME 設定を適用します。"
gsettings set org.gnome.desktop.interface enable-animations false || true
gsettings set org.gnome.desktop.session idle-delay 0 || true
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false || true

# sudo タイムアウト延長
echo "🔹 sudo のタイムアウトを延長します。"
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo

# 壁紙変更
echo "🔹 壁紙をダウンロードして設定します。"
wget http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O "$HOME/Pictures/1.jpg"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/1.jpg" || true

# ======================= EULA/ウィザード抑制 =======================
echo "🔹 フォントと Postfix のウィザードを回避設定します。"
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
echo "postfix postfix/mailname string localhost" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type string 'No configuration'" | sudo debconf-set-selections
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections

# ======================= 基本ソフトウェア =======================
echo "🔹 基本ソフトウェアをインストールします。"
sudo apt update && sudo apt upgrade -y

# システムユーティリティ
sudo apt install -y unzip curl htop git axel samba openssh-server net-tools exfat-fuse unar

# エディタ
sudo apt install -y emacs-nox gedit

# メディア関連ツール
sudo apt install -y ffmpeg imagemagick lame vlc

# その他アプリ
sudo apt install -y wget git curl htop net-tools emacs-nox lame unar axel vlc gedit build-essential ffmpeg imagemagick chromium openssh-server yt-dlp

# ======================= ブラウザインストール（アーキテクチャ依存） =======================
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" == "amd64" ]]; then
  echo "🔹 Braveブラウザをインストールします。"
  sudo apt install -y curl
  type apt-key &>/dev/null || sudo apt install -y gnupg
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave.com/signing-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
    sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update && sudo apt install -y brave-browser

  echo "🔹 Google Chrome をインストールします。"
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
  sudo apt install -y ./chrome.deb
else
  echo "⚠️ BraveとGoogle Chromeはi386には対応していないため、Chromiumをインストールします。"
  sudo apt install -y chromium
fi

# ======================= dash-to-dock拡張をブラウザで開く =======================
echo "🌐 dash-to-dock 拡張をインストールするためにブラウザを起動します..."
x-www-browser https://extensions.gnome.org/extension/307/dash-to-dock/ &

# ======================= ロケール・日本語設定 =======================
echo "🔹 日本語環境をインストールします。"
sudo apt install -y ibus-mozc manpages-ja manpages-ja-dev gnome-tweaks ttf-mscorefonts-installer fonts-takao-gothic fonts-takao-mincho
sudo update-locale LANG=ja_JP.UTF8
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ======================= システム設定 =======================
echo "🔹 NTP 設定やフォント設定します。"
sudo sed -i 's/#NTP=/NTP=ntp.nict.jp/g' /etc/systemd/timesyncd.conf || true

gsettings set org.gnome.desktop.interface font-name 'Noto Sans CJK JP 11' || true
gsettings set org.gnome.mutter auto-maximize false || true
gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'gedit.desktop', 'gnome-control-center.desktop']" || true

# ======================= 日本語入力 Mozc 設定 =======================
echo "🔹 日本語入力 Mozc の設定します。"
cat <<EOF | sudo tee /etc/default/keyboard
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
EOF

cat <<EOF | sudo tee /usr/share/ibus/component/mozc.xml
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
EOF

# ======================= エイリアス追加 =======================
echo "🔹 エイリアスを追加します。"
cat <<EOF >> ~/.bashrc

# myalias
alias a="axel -a -n 10"
alias u='unar'
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
EOF

# ======================= 終了処理 =======================
echo "🔹 不要なパッケージを削除します。"
sudo apt autoremove -y

echo "🔄 再起動します..."
sudo reboot now
