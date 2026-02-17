#!/usr/bin/env bash
# Zaatar image customization: packages, theme, locale, timezone, branding.
# All comments and project text are in English; the OS supports Arabic and English.
set -eoux pipefail

# Language packs and fonts (Arabic + English), input, LibreOffice, GNOME Tweaks
rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-kufi-arabic-fonts \
    hunspell-ar \
    ibus-m17n \
    libreoffice-langpack-ar \
    gnome-tweaks \
    git curl

# macOS-like GNOME theme (Tahoe). Use HOME=/tmp so install.sh does not touch /root
git clone https://github.com/kayozxo/GNOME-macOS-Tahoe /tmp/Tahoe
cd /tmp/Tahoe
HOME=/tmp ./install.sh -d --color blue -la
HOME=/tmp ./install.sh -w
cd /

# Allow Flatpaks to use host GTK config (theme)
flatpak override --filesystem=xdg-config/gtk-3.0
flatpak override --filesystem=xdg-config/gtk-4.0

# Default locale: Arabic (Syria) with English fallback; timezone Damascus
echo "LANG=ar_SY.UTF-8" > /etc/locale.conf
echo "LANGUAGE=ar_SY:ar:en_US:en" >> /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Damascus /etc/localtime

# Default input sources: US English + Arabic (m17n:ar:kbd) so Arabic keyboard is available without manual setup
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/01-zaatar-input-sources << 'EOF'
[org/gnome/desktop/input-sources]
sources=[('xkb', 'us'), ('ibus', 'm17n:ar:kbd')]
EOF
dconf update

# OS branding (display name stays in Arabic: Zaatar)
sed -i 's/^NAME=.*/NAME="زعتر"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="زعتر 1.0"/' /etc/os-release

ostree container commit