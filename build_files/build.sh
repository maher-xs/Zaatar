#!/usr/bin/env bash
set -eoux pipefail

rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-kufi-arabic-fonts \
    hunspell-ar \
    ibus-m17n \
    libreoffice-langpack-ar \
    gnome-tweaks \
    git curl
    
git clone https://github.com/kayozxo/GNOME-macOS-Tahoe /tmp/Tahoe
cd /tmp/Tahoe
./install.sh -d --color blue -la
./install.sh -w
cd /

flatpak override --filesystem=xdg-config/gtk-3.0
flatpak override --filesystem=xdg-config/gtk-4.0

echo "LANG=ar_SY.UTF-8" > /etc/locale.conf
echo "LANGUAGE=ar_SY:ar:en_US:en" >> /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Damascus /etc/localtime

sed -i 's/^NAME=.*/NAME="زعتر"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="زعتر 1.0"/' /etc/os-release

ostree container commit