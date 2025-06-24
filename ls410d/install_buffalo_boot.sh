#!/bin/bash

# ===========================
# Buffalo用 initrd/uImage インストーラー
# - 対話式デバイス選択
# - 自動マウントポイント生成
# - GitHubからファイル取得
# ===========================

DL_BASE="https://raw.githubusercontent.com/1000001101000/Debian_on_Buffalo/master/Bookworm/installer_images/armhf_devices"
INITRD="initrd.buffalo"
UIMAGE_SRC="uImage.buffalo.ls410d"
UIMAGE_DST="uImage.buffalo"

# ---------------------------
# 必要なパッケージの確認とインストール
# ---------------------------
echo "🔧 必要なパッケージをインストール中..."
sudo apt update
sudo apt install -y parted wget

# ---------------------------
# /dev/sd* デバイス一覧取得
# ---------------------------
echo "🔍 接続中の /dev/sd* デバイス一覧："
mapfile -t DEVICES < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}')

if [ ${#DEVICES[@]} -eq 0 ]; then
  echo "❌ デバイスが見つかりません。"
  exit 1
fi

# ---------------------------
# 対話式に選択
# ---------------------------
select DEVICE in "${DEVICES[@]}"; do
  if [[ -n "$DEVICE" ]]; then
    echo "✅ 選択されたデバイス: $DEVICE"
    break
  else
    echo "❌ 無効な選択です。"
  fi
done

# ---------------------------
# 初期化前の確認（1回のみ）
# ---------------------------
lsblk "$DEVICE"
echo "⚠️ 上記デバイスを初期化し、Debian用の uImage.buffalo と initrd.buffalo をインストールします。続行しますか？ (yes/no)"
read -r CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "❌ 中止しました。"
  exit 1
fi

# ---------------------------
# 自動マウントポイント生成
# 例: /mnt/work_sdb1
# ---------------------------
DEV_NAME=$(basename "$DEVICE")
MOUNTPOINT="/mnt/work_${DEV_NAME}1"
echo "📁 マウントポイント: $MOUNTPOINT"

# ---------------------------
# パーティション作成（GPT）
# ---------------------------
echo "🛠 パーティションを作成します..."
sudo parted -s "$DEVICE" mklabel gpt \
  mkpart boot 2048s 2099200s \
  mkpart root 2101248s 18874464s \
  mkpart swap 18880512s 19929088s \
  mkpart home 19931136s 100%

# ---------------------------
# パーティション フォーマット
# ---------------------------
echo "💽 フォーマット中..."
sudo mkfs.ext3 "${DEVICE}1"
sudo mkfs.ext4 "${DEVICE}2"
sudo mkswap     "${DEVICE}3"
sudo mkfs.ext4 "${DEVICE}4"

# ---------------------------
# GitHub からファイルをダウンロード
# ---------------------------
echo "🌐 GitHubからファイルを取得中..."
wget -q --show-progress "$DL_BASE/$INITRD" -O "$INITRD"
wget -q --show-progress "$DL_BASE/$UIMAGE_SRC" -O "$UIMAGE_SRC"

if [[ ! -f "$INITRD" || ! -f "$UIMAGE_SRC" ]]; then
  echo "❌ ダウンロードに失敗しました。"
  exit 1
fi

# ---------------------------
# マウントしてファイルコピー
# ---------------------------
echo "📦 ファイルをコピー中..."
sudo mkdir -p "$MOUNTPOINT"
sudo mount "${DEVICE}1" "$MOUNTPOINT"

sudo cp "$INITRD" "$MOUNTPOINT/"
sudo cp "$UIMAGE_SRC" "$MOUNTPOINT/$UIMAGE_DST"

sync
sudo umount "$MOUNTPOINT"
sudo rmdir "$MOUNTPOINT"

# ---------------------------
# 完了表示と今後の案内
# ---------------------------
echo "✅ 書き込みが完了しました。以下が現在の状態です："
lsblk "$DEVICE"

echo
echo "📦 USB書き込みは完了しました。次の手順に進んでください："
echo
echo "============================ 次のステップ ============================"
echo "1. 対象のHDD/SSDを取り外して、本来のBuffalo NASに接続します。"
echo "2. NASの電源を入れて起動してください（約1～2分待機）。"
echo "3. NASはDHCPでIPアドレスを取得します。以下の方法で確認できます："
echo
echo "   ▶ arp-scan を使う（要インストール）："
echo "      sudo apt install arp-scan"
echo "      sudo arp-scan --localnet | grep -i buffalo"
echo
echo "   ▶ もしくはルーターのDHCPリース一覧を確認してください。"
echo
echo "4. IPがわかったらSSHでログインできます："
echo "      ssh installer@<NASのIPアドレス>"
echo "      パスワード: install"
echo
echo "========================================================================"
echo
echo "🚀 準備は完了です。NASの電源を入れて、インストール作業を進めましょう。"
