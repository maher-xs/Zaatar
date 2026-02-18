#!/usr/bin/env bash
# Zaatar image customization: locale, timezone, branding.
# Arabic + English – user can switch between both in Settings > Region & Language.
set -eoux pipefail

# Language packs and input: Arabic + English (user switches in Settings > Region & Language)
rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-kufi-arabic-fonts \
    ibus-m17n

# Bilingual locale: Arabic (Syria) and English (US). Both available so user can switch.
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