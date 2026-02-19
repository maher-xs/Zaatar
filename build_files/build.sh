#!/usr/bin/env bash
# Zaatar image customization: locale, timezone, branding.
# Arabic + English – user can switch between both in Settings > Region & Language.
set -eoux pipefail

# تفعيل Flathub (Silverblue لا يفعّله تلقائياً)
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Essential packages – language, fonts, input, spellcheck. WhiteSur from GitHub. sushi = Quick Look.
# user-theme: required for WhiteSur GNOME Shell theme. sassc: for WhiteSur GTK build.
rpm-ostree install \
    langpacks-ar langpacks-en \
    google-noto-sans-arabic-fonts \
    google-noto-sans-fonts \
    hunspell-ar \
    hunspell-en-US \
    ibus-m17n \
    rsms-inter-fonts \
    fira-code-fonts \
    gnome-shell-extension-blur-my-shell \
    gnome-shell-extension-user-theme \
    sushi \
    sassc \
    glib2-devel \
    libxml2 \
    irqbalance \
    earlyoom

# RPM Fusion + codecs (تشغيل وسائط)
FEDORA_VER=$(rpm -E %fedora 2>/dev/null || echo "42")
rpm-ostree install \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm" \
    2>/dev/null || true
rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-ugly 2>/dev/null || true

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

# WhiteSur GTK theme (full macOS-like: GTK3, GTK4, GNOME Shell, libadwaita, Flatpak)
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme /tmp/WhiteSur-gtk
cd /tmp/WhiteSur-gtk
./install.sh -c dark -m -l --silent-mode -d /usr/share/themes 2>/dev/null || true
# libadwaita (gtk-4.0) for system – run as root for /etc
./install.sh -l -c dark -m --silent-mode 2>/dev/null || true
# GDM theme (login screen)
./tweaks.sh -g -c dark -m 2>/dev/null || true
cd /
rm -rf /tmp/WhiteSur-gtk

# إزالة حزم البناء (لا تُحتاج بعد تثبيت WhiteSur) — تقليل حجم الصورة
rpm-ostree uninstall sassc glib2-devel libxml2 2>/dev/null || true

# WhiteSur icon theme (macOS Big Sur style)
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme /tmp/WhiteSur-icons
cd /tmp/WhiteSur-icons
./install.sh -d /usr/share/icons
cd /
rm -rf /tmp/WhiteSur-icons

# WhiteSur cursors (macOS-style)
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-cursors /tmp/WhiteSur-cursors
if [ -d /tmp/WhiteSur-cursors/dist/WhiteSur-cursors ]; then
    cp -r /tmp/WhiteSur-cursors/dist/WhiteSur-cursors /usr/share/icons/
elif [ -d /tmp/WhiteSur-cursors/WhiteSur-cursors ]; then
    cp -r /tmp/WhiteSur-cursors/WhiteSur-cursors /usr/share/icons/
fi
rm -rf /tmp/WhiteSur-cursors

# GNOME extensions: Dash2Dock, Search Light, Tasks in Panel, Quick Settings, Rounded Corners, No Titlebar, Magic Lamp, Logo Menu
DASH2DOCK_UUID="dash2dock-lite@icedman.github.com"
SEARCH_LIGHT_UUID="search-light@icedman.github.com"
TASKS_PANEL_UUID="tasks-in-panel@fthx"
QS_TWEAKS_UUID="quick-settings-tweaks@qwreey"
ROUNDED_UUID="rounded-window-corners-reborn@flexagoon"
NOTITLEBAR_UUID="no-titlebar-when-maximized@alec.ninja"
MAGIC_LAMP_UUID="compiz-alike-magic-lamp-effect@hermes83.github.com"
LOGOMENU_UUID="logomenu@aryan_k"
for uuid in "${DASH2DOCK_UUID}" "${SEARCH_LIGHT_UUID}" "${TASKS_PANEL_UUID}" "${QS_TWEAKS_UUID}" "${ROUNDED_UUID}" "${NOTITLEBAR_UUID}" "${MAGIC_LAMP_UUID}" "${LOGOMENU_UUID}"; do
  mkdir -p /usr/share/gnome-shell/extensions/${uuid}
done
# Dash2Dock Animated (v86) – icon zoom, bounce, macOS-like dock
curl -sL "https://extensions.gnome.org/extension-data/dash2dock-liteicedman.github.com.v86.shell-extension.zip" -o /tmp/dash2dock.zip 2>/dev/null || true
# Search Light (v42) – Spotlight-like floating search
curl -sL "https://extensions.gnome.org/extension-data/search-lighticedman.github.com.v42.shell-extension.zip" -o /tmp/search-light.zip 2>/dev/null || \
  curl -sL "https://extensions.gnome.org/extension-data/search-lighticedman.github.com.v26.shell-extension.zip" -o /tmp/search-light.zip 2>/dev/null || true
# Tasks in Panel (v54) – focused app name in center of top bar (مثل macOS)
curl -sL "https://extensions.gnome.org/extension-data/tasks-in-panelfthx.v54.shell-extension.zip" -o /tmp/tasks-panel.zip 2>/dev/null || true
# Quick Settings Tweaks – Media Controls, Volume Mixer, DND (مثل macOS Control Center)
curl -sL "https://extensions.gnome.org/extension-data/quick-settings-tweaksqwreey.v30.shell-extension.zip" -o /tmp/qs-tweaks.zip 2>/dev/null || \
  curl -sL "https://extensions.gnome.org/extension-data/quick-settings-tweaksqwreey.v29.shell-extension.zip" -o /tmp/qs-tweaks.zip 2>/dev/null || true
# Rounded Window Corners (زوايا مدورة مثل macOS) – Reborn for GNOME 45+
curl -sL "https://extensions.gnome.org/extension-data/rounded-window-corners-rebornflexagoon.v14.shell-extension.zip" -o /tmp/rounded.zip 2>/dev/null || true
# No Titlebar When Maximized (إخفاء شريط العنوان عند التكبير مثل macOS)
curl -sL "https://extensions.gnome.org/extension-data/no-titlebar-when-maximizedalecdotninja.v19.shell-extension.zip" -o /tmp/no-titlebar.zip 2>/dev/null || true
curl -sL "https://extensions.gnome.org/extension-data/compiz-alike-magic-lamp-effecthermes83.github.com.v22.shell-extension.zip" -o /tmp/magic-lamp.zip 2>/dev/null || true
curl -sL "https://extensions.gnome.org/extension-data/logomenuaryan_k.v21.shell-extension.zip" -o /tmp/logomenu.zip 2>/dev/null || true
if [ -f /tmp/dash2dock.zip ]; then
    unzip -o -q /tmp/dash2dock.zip -d /usr/share/gnome-shell/extensions/${DASH2DOCK_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/search-light.zip ]; then
    unzip -o -q /tmp/search-light.zip -d /usr/share/gnome-shell/extensions/${SEARCH_LIGHT_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/tasks-panel.zip ]; then
    unzip -o -q /tmp/tasks-panel.zip -d /usr/share/gnome-shell/extensions/${TASKS_PANEL_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/qs-tweaks.zip ]; then
    unzip -o -q /tmp/qs-tweaks.zip -d /usr/share/gnome-shell/extensions/${QS_TWEAKS_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/rounded.zip ]; then
    unzip -o -q /tmp/rounded.zip -d /usr/share/gnome-shell/extensions/${ROUNDED_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/no-titlebar.zip ]; then
    unzip -o -q /tmp/no-titlebar.zip -d /usr/share/gnome-shell/extensions/${NOTITLEBAR_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/magic-lamp.zip ]; then
    unzip -o -q /tmp/magic-lamp.zip -d /usr/share/gnome-shell/extensions/${MAGIC_LAMP_UUID}/ 2>/dev/null || true
fi
if [ -f /tmp/logomenu.zip ]; then
    unzip -o -q /tmp/logomenu.zip -d /usr/share/gnome-shell/extensions/${LOGOMENU_UUID}/ 2>/dev/null || true
fi
rm -f /tmp/dash2dock.zip /tmp/search-light.zip /tmp/tasks-panel.zip /tmp/qs-tweaks.zip /tmp/rounded.zip /tmp/no-titlebar.zip /tmp/magic-lamp.zip /tmp/logomenu.zip

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
if [ -f /tmp/zaatar-assets/wallpapers/zaatar-wallpaper-ultrawide.png ]; then
    cp /tmp/zaatar-assets/wallpapers/zaatar-wallpaper-ultrawide.png /usr/share/backgrounds/zaatar/
fi

# macOS-like appearance: WhiteSur full theme, Inter font, window buttons left
mkdir -p /etc/dconf/profile
echo -e 'user-db:user\nsystem-db:local' > /etc/dconf/profile/user
cat > /etc/dconf/db/local.d/03-zaatar-appearance << 'APPEAR'
[org/gnome/desktop/interface]
gtk-theme='WhiteSur-Dark'
icon-theme='WhiteSur-dark'
cursor-theme='WhiteSur-cursors'
cursor-size=24
font-name='Inter 11'
document-font-name='Inter 11'
monospace-font-name='Fira Code 10'
enable-animations=true
enable-hot-corners=true
show-battery-percentage=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
theme='WhiteSur-Dark'
focus-mode='click'

[org/gnome/shell/extensions/user-theme]
name='WhiteSur-Dark'
APPEAR
if [ -n "$WALLPAPER_URI" ]; then
  cat >> /etc/dconf/db/local.d/03-zaatar-appearance << EOF

[org/gnome/desktop/background]
picture-uri='$WALLPAPER_URI'
picture-uri-dark='$WALLPAPER_URI'
picture-options='zoom'
EOF
fi

# Extensions: Dash2Dock, Search Light, Tasks in Panel, Blur, Magic Lamp, Logo Menu, User Theme
cat > /etc/dconf/db/local.d/04-zaatar-extensions << 'EXT'
[org/gnome/shell]
enabled-extensions=['dash2dock-lite@icedman.github.com', 'search-light@icedman.github.com', 'tasks-in-panel@fthx', 'quick-settings-tweaks@qwreey', 'rounded-window-corners-reborn@flexagoon', 'no-titlebar-when-maximized@alec.ninja', 'blur-my-shell@aunetx', 'compiz-alike-magic-lamp-effect@hermes83.github.com', 'logomenu@aryan_k', 'user-theme@gnome-shell-extensions.gcampax.github.com']
favorite-apps=['org.gnome.Nautilus.desktop', 'org.mozilla.firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop']

[org/gnome/shell/extensions/dash2dock-lite]
icon-size=48
icon-effect=1
animate-icons=true
animate-icons-unmute=true
running-indicator-style=2
dock-location=3
autohide-dash=true
autohide-dodge=true
peek-hidden-icons=true
trash-icon=false
mounted-icon=false

[org/gnome/shell/extensions/search-light]
shortcut-search=['<Super>space']
show-panel-icon=false
blur-background=true
border-radius=12

[org/gnome/shell/extensions/tasks-in-panel]
show-task-for-focused-window-only=true
move-tasks-to-center=true
show-activities-indicator=false
move-date-menu-button-to-right=true

[org/gnome/shell/extensions/quick-settings-tweaks]
add-dnd-quick-toggle-enabled=true
media-control-enabled=true
volume-mixer-enabled=true

[org/gnome/shell/extensions/rounded-window-corners-reborn]
border-radius=12

[org/gnome/shell/extensions/blur-my-shell]
blur-dash=true
blur-panel=true
blur-overview=true

[org/gnome/shell/extensions/Logo-menu]
menu-button-icon-image=23
EXT

# Night Light (مثل Night Shift في macOS) + Touchpad (مطابق لماك)
cat > /etc/dconf/db/local.d/05-zaatar-nightlight-touchpad << 'NIGHT'
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=true
night-light-temperature=3700

[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true
two-finger-scrolling-enabled=true
natural-scroll=true
speed=0.2
NIGHT

# Flatpak: تطبيق WhiteSur على تطبيقات Flatpak (مثل macOS)
flatpak override --filesystem=xdg-config/gtk-3.0:ro --system 2>/dev/null || true
flatpak override --filesystem=xdg-config/gtk-4.0:ro --system 2>/dev/null || true
flatpak override --env=GTK_THEME=WhiteSur-Dark --system 2>/dev/null || true

# Performance: zram (zstd, max 16GB), sysctl (مثل macOS), irqbalance, fstrim
mkdir -p /etc/systemd/zram-generator.conf.d
cat > /etc/systemd/zram-generator.conf.d/10-zaatar-performance.conf << 'EOF'
[zram0]
zram-size = min(ram, 16384)
compression-algorithm = zstd
EOF
# vm tuning: swappiness=10 (تأخير swap), vfs_cache_pressure=50 (مثل macOS)
mkdir -p /etc/sysctl.d
cat > /etc/sysctl.d/99-zaatar-performance.conf << 'EOF'
# مثل macOS: يؤخر swap ويحافظ على cache
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_background_ratio=5
vm.dirty_ratio=10
vm.page-cluster=0
EOF
# irqbalance: توزيع المقاطعات على أنوية CPU
systemctl enable irqbalance 2>/dev/null || true
# earlyoom: تمنع تجميد النظام عند امتلاء الذاكرة (مثل macOS)
systemctl enable earlyoom 2>/dev/null || true
# fstrim.timer: TRIM تلقائي للـ SSD
systemctl enable fstrim.timer 2>/dev/null || true
# إقلاع أسرع: عدم انتظار الشبكة + plymouth-quit-wait
mkdir -p /etc/systemd/system/NetworkManager-wait-online.service.d
cat > /etc/systemd/system/NetworkManager-wait-online.service.d/zaatar-boot.conf << 'EOF'
[Service]
ExecStart=
ExecStart=/bin/true
EOF
systemctl disable plymouth-quit-wait.service 2>/dev/null || true
mkdir -p /etc/systemd/system
cat > /etc/systemd/system/zaatar-power-profile.service << 'EOF'
[Unit]
Description=Zaatar default power profile (performance)
After=tuned.service
Wants=tuned.service
ConditionPathExists=/usr/sbin/tuned-adm
[Service]
Type=oneshot
ExecStart=-/usr/sbin/tuned-adm profile throughput-performance
RemainAfterExit=yes
[Install]
WantedBy=graphical.target
EOF
mkdir -p /etc/systemd/system/graphical.target.wants
ln -sf ../zaatar-power-profile.service /etc/systemd/system/graphical.target.wants/zaatar-power-profile.service

dconf update

# OS branding: "Zaatar" / "زعتر" – localized by user language (عربي → زعتر، English → Zaatar)
# Script runs at login to set NAME/PRETTY_NAME based on LANG
mkdir -p /usr/libexec/zaatar
cat > /usr/libexec/zaatar/update-os-name-by-locale.sh << 'OSSCRIPT'
#!/usr/bin/env bash
# Set OS name by LANG: ar → زعتر، else → Zaatar (Settings > About, GDM, etc.)
LANG="${LANG:-en_US.UTF-8}"
if [[ "$LANG" == ar* ]]; then
  NAME='زعتر'
  PRETTY='زعتر 1.0'
else
  NAME='Zaatar'
  PRETTY='Zaatar 1.0'
fi
for f in /etc/os-release /usr/lib/os-release; do
  [ -f "$f" ] || continue
  sed -i "s/^NAME=.*/NAME=\"$NAME\"/" "$f"
  sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"$PRETTY\"/" "$f"
done
# machine-info (hostnamectl) + issue/issue.net (console)
printf 'PRETTY_HOSTNAME=%s\nCHASSIS=desktop\n' "$NAME" > /etc/machine-info 2>/dev/null || true
echo "$PRETTY" > /etc/issue 2>/dev/null || true
echo "$PRETTY" > /etc/issue.net 2>/dev/null || true
OSSCRIPT
chmod +x /usr/libexec/zaatar/update-os-name-by-locale.sh
# Sudoers: allow any user to run the script (for locale-based os-release update)
mkdir -p /etc/sudoers.d
echo 'ALL ALL=(ALL) NOPASSWD: /usr/libexec/zaatar/update-os-name-by-locale.sh' > /etc/sudoers.d/zaatar-os-name
chmod 440 /etc/sudoers.d/zaatar-os-name
# Autostart: run at login to apply locale (عربي → زعتر، English → Zaatar)
cat > /etc/xdg/autostart/zaatar-os-name.desktop << 'OSDESKTOP'
[Desktop Entry]
Type=Application
Name=Zaatar OS Name
Exec=/bin/bash -c 'sudo LANG="$LANG" /usr/libexec/zaatar/update-os-name-by-locale.sh'
Hidden=true
NoDisplay=true
X-GNOME-Autostart-enabled=true
OSDESKTOP

# At boot: apply default LANG from locale.conf (for GDM, login screen)
mkdir -p /etc/systemd/system
cat > /etc/systemd/system/zaatar-os-name-boot.service << 'OSBOOT'
[Unit]
Description=Zaatar OS name by locale (boot)
After=local-fs.target
Before=display-manager.service
[Service]
Type=oneshot
ExecStart=/bin/bash -c 'source /etc/locale.conf 2>/dev/null; export LANG; /usr/libexec/zaatar/update-os-name-by-locale.sh'
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
OSBOOT
ln -sf /etc/systemd/system/zaatar-os-name-boot.service /etc/systemd/system/multi-user.target.wants/zaatar-os-name-boot.service 2>/dev/null || true

# 1) os-release – base values (script updates by LANG at boot + login)
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

# 2) issue, issue.net, machine-info – initial values (script updates by LANG at boot + login)
echo 'Zaatar 1.0' > /etc/issue
echo 'Zaatar 1.0' > /etc/issue.net
mkdir -p /etc && printf 'PRETTY_HOSTNAME=Zaatar\nCHASSIS=desktop\n' > /etc/machine-info

# 3) Message of the day (e.g. after SSH login or console)
echo 'Welcome to Zaatar 1.0 – Arabic/English desktop.' > /etc/motd

# 4) Single place that always says what this system is (for scripts/docs)
echo 'Zaatar 1.0 - Arabic/English desktop.' > /etc/zaatar-release 2>/dev/null || true

# 5) GRUB boot menu – show "Zaatar 1.0" instead of "Zaatar 42"
# GRUB_DISTRIBUTOR is used by grub2-mkconfig for menuentry titles; bootc-image-builder may also
# read /etc/system-release. Both are set so the boot menu displays "Zaatar 1.0" for the user.
echo 'Zaatar 1.0' > /etc/system-release 2>/dev/null || true
if [ -f /etc/default/grub ]; then
  if grep -q '^GRUB_DISTRIBUTOR=' /etc/default/grub; then
    sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Zaatar 1.0"/' /etc/default/grub
  else
    echo 'GRUB_DISTRIBUTOR="Zaatar 1.0"' >> /etc/default/grub
  fi
fi

ostree container commit