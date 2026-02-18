#!/usr/bin/env bash
# Zaatar image customization: packages, theme, locale, timezone, branding.
# All comments and project text are in English; the OS supports Arabic and English.
set -eoux pipefail

# Language packs and fonts: Arabic + English (so system handles both scripts and account names in Latin)
rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-kufi-arabic-fonts \
    google-noto-sans-fonts \
    hunspell-ar \
    hunspell-en-us \
    ibus-m17n \
    libreoffice-langpack-ar \
    libreoffice-langpack-en \
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

# Bilingual locale: Arabic (Syria) and English (US). Both available so user can switch in Settings > Region & Language.
# LANG=ar_SY = default display; LANGUAGE lists both so apps can show either. Supports accounts with English letters.
echo "LANG=ar_SY.UTF-8" > /etc/locale.conf
echo "LANGUAGE=ar_SY:ar:en_US:en" >> /etc/locale.conf
echo "LC_ADDRESS=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_MEASUREMENT=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_MONETARY=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_NAME=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_NUMERIC=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_PAPER=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_TELEPHONE=ar_SY.UTF-8" >> /etc/locale.conf
echo "LC_TIME=ar_SY.UTF-8" >> /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Damascus /etc/localtime

# Default input sources: English (US) first, then Arabic – so Latin account names and typing work without switching
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/01-zaatar-input-sources << 'EOF'
[org/gnome/desktop/input-sources]
sources=[('xkb', 'us'), ('ibus', 'm17n:ar:kbd')]
EOF
# Ensure both languages appear in Region & Language for easy switching
cat > /etc/dconf/db/local.d/02-zaatar-region << 'EOF'
[org/gnome/system/locale]
region='ar_SY.UTF-8'
EOF
dconf update

# OS branding (display name stays in Arabic: Zaatar)
sed -i 's/^NAME=.*/NAME="زعتر"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="زعتر 1.0"/' /etc/os-release

ostree container commit