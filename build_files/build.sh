#!/usr/bin/env bash
# Zaatar image customization: locale, timezone, branding.
# Arabic + English – user can switch between both in Settings > Region & Language.
set -eoux pipefail

# Language packs, fonts, input, spellcheck, icons: Arabic + English (user switches in Settings > Region & Language)
rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-kufi-arabic-fonts \
    google-noto-sans-fonts \
    hunspell-ar \
    hunspell-en-US \
    ibus-m17n \
    papirus-icon-theme \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-blur-my-shell \
    gnome-extensions-app \
    git

# Bilingual locale: Arabic (Syria) and English (US). Both available so user can switch.
{
  echo "LANG=ar_SY.UTF-8"
  echo "LANGUAGE=ar_SY:ar:en_US:en"
  echo "LC_ADDRESS=ar_SY.UTF-8"
  echo "LC_MEASUREMENT=ar_SY.UTF-8"
  echo "LC_MONETARY=ar_SY.UTF-8"
  echo "LC_NAME=ar_SY.UTF-8"
  echo "LC_NUMERIC=ar_SY.UTF-8"
  echo "LC_PAPER=ar_SY.UTF-8"
  echo "LC_TELEPHONE=ar_SY.UTF-8"
  echo "LC_TIME=ar_SY.UTF-8"
} > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Damascus /etc/localtime

# Input sources: English (US) and Arabic – user switches with Super+Space or from Region & Language
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/01-zaatar-input-sources << 'EOF'
[org/gnome/desktop/input-sources]
sources=[('xkb', 'us'), ('ibus', 'm17n:ar:kbd')]
EOF
cat > /etc/dconf/db/local.d/02-zaatar-region << 'EOF'
[org/gnome/system/locale]
region='ar_SY.UTF-8'
EOF

# Tahoe theme (macOS-like GNOME): dark + blue accent + libadwaita + wallpapers. Use HOME=/tmp so install.sh does not touch /root.
git clone --depth 1 https://github.com/kayozxo/GNOME-macOS-Tahoe /tmp/Tahoe
cd /tmp/Tahoe
HOME=/tmp ./install.sh -d --color blue -la
HOME=/tmp ./install.sh -w
cd /

# Zaatar custom wallpaper: install to system backgrounds and set as default (PNG preferred over SVG)
mkdir -p /usr/share/backgrounds/zaatar
WALLPAPER_URI=""
if [ -f /tmp/zaatar-assets/wallpapers/zaatar-wallpaper.png ]; then
  cp /tmp/zaatar-assets/wallpapers/zaatar-wallpaper.png /usr/share/backgrounds/zaatar/
  WALLPAPER_URI="file:///usr/share/backgrounds/zaatar/zaatar-wallpaper.png"
elif [ -f /tmp/zaatar-assets/wallpapers/zaatar-wallpaper.svg ]; then
  cp /tmp/zaatar-assets/wallpapers/zaatar-wallpaper.svg /usr/share/backgrounds/zaatar/
  WALLPAPER_URI="file:///usr/share/backgrounds/zaatar/zaatar-wallpaper.svg"
fi
# Also install ultrawide variant if present (user can select from Settings > Appearance)
[ -f /tmp/zaatar-assets/wallpapers/zaatar-wallpaper-ultrawide.png ] && \
  cp /tmp/zaatar-assets/wallpapers/zaatar-wallpaper-ultrawide.png /usr/share/backgrounds/zaatar/

# Default appearance: Zaatar wallpaper (if present) + Papirus icons
cat > /etc/dconf/db/local.d/03-zaatar-appearance << EOF
[org/gnome/desktop/interface]
icon-theme='Papirus'
EOF
if [ -n "$WALLPAPER_URI" ]; then
  cat >> /etc/dconf/db/local.d/03-zaatar-appearance << EOF

[org/gnome/desktop/background]
picture-uri='$WALLPAPER_URI'
picture-uri-dark='$WALLPAPER_URI'
picture-options='zoom'
EOF
fi

# Enable Dash to Dock and Blur my Shell by default for all users (system-wide)
mkdir -p /etc/dconf/profile
echo -e 'user-db:user\nsystem-db:local' > /etc/dconf/profile/user
cat > /etc/dconf/db/local.d/04-zaatar-extensions << 'EOF'
[org/gnome/shell]
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx']
EOF
# Dash to Dock: bottom, icon size, show on all monitors
mkdir -p /etc/dconf/db/local.d
cat >> /etc/dconf/db/local.d/04-zaatar-extensions << 'EOF'

[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
extend-height=false
dock-fixed=true
show-apps-at-top=false
show-mounts=false
show-trash=false
apply-custom-theme=false
EOF

# Allow Flatpaks to use host GTK config (theme)
flatpak override --filesystem=xdg-config/gtk-3.0 2>/dev/null || true
flatpak override --filesystem=xdg-config/gtk-4.0 2>/dev/null || true

dconf update

# OS branding: "Zaatar" only – no Bluefin or other base names visible to user
# Every place that can show OS name or system info shows Zaatar (Latin)

# 1) os-release – main OS identity (Settings > About, installer, scripts, GDM)
# ID and VERSION_ID must stay fedora/42 so bootc-image-builder finds fedora-42 def (anaconda-iso).
# Override NAME/PRETTY_NAME to Zaatar – that's what users see; ID is internal for build tools.
sed -i 's/^ID=.*/ID=fedora/' /etc/os-release
sed -i 's/^VERSION_ID=.*/VERSION_ID="42"/' /etc/os-release
sed -i 's/^NAME=.*/NAME="Zaatar"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Zaatar 1.0"/' /etc/os-release
sed -i 's/^VARIANT_ID=.*/VARIANT_ID=zaatar/' /etc/os-release 2>/dev/null || true
sed -i 's/^ID_LIKE=.*/ID_LIKE="fedora"/' /etc/os-release 2>/dev/null || true
sed -i 's/^VARIANT=.*/VARIANT="zaatar"/' /etc/os-release 2>/dev/null || true
sed -i 's/^IMAGE_ID=.*/IMAGE_ID=zaatar/' /etc/os-release 2>/dev/null || true
# If /usr/lib/os-release exists separately, keep it in sync
if [ -f /usr/lib/os-release ] && [ ! -L /etc/os-release ]; then
  cp /etc/os-release /usr/lib/os-release 2>/dev/null || true
fi

# 2) Login and console – first thing user sees
echo 'Zaatar 1.0' > /etc/issue
echo 'Zaatar 1.0' > /etc/issue.net

# 3) machine-info – pretty hostname (hostnamectl, some UIs)
mkdir -p /etc
printf 'PRETTY_HOSTNAME=Zaatar\nCHASSIS=desktop\n' > /etc/machine-info

# 4) Message of the day (e.g. after SSH login or console)
echo 'Welcome to Zaatar 1.0 – Arabic/English desktop.' > /etc/motd

# 5) Single place that always says what this system is (for scripts/docs)
echo 'Zaatar 1.0 - Arabic/English desktop.' > /etc/zaatar-release 2>/dev/null || true

ostree container commit