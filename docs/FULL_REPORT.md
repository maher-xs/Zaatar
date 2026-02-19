# التقرير الشامل – نظام زعتر (Zaatar)

**تاريخ التقرير:** فبراير 2025  
**الإصدار:** Zaatar 1.0  
**المستودع:** https://github.com/maher-xs/Zaatar

---

## 1. نظرة عامة

**زعتر (Zaatar)** نظام تشغيل سطح مكتب ثنائي اللغة (عربي/إنجليزي) مبني على [Universal Blue Bluefin](https://github.com/ublue-os/bluefin) بتقنية bootc و ostree. النظام مصمّم لتجربة مطابقة لـ macOS مع دعم كامل للعربية.

| البند | الوصف |
|-------|--------|
| **القاعدة** | ghcr.io/ublue-os/bluefin:stable |
| **التقنية** | bootc (ostree containers) |
| **سطح المكتب** | GNOME مع ثيم WhiteSur (مطابق لـ macOS) |
| **اللغات** | العربية (ar_SY) والإنجليزية (en_US) |
| **المنطقة** | سوريا (دمشق) |
| **العلامة التجارية** | زعتر (عربي) / Zaatar (إنجليزي) – يتغير حسب لغة النظام |

---

## 2. هيكل المشروع والملفات

```
Zaatar/
├── .github/
│   ├── workflows/
│   │   ├── build.yml          # بناء الصورة، Lint، Push، Sign
│   │   └── build-disk.yml      # بناء QCOW2 و ISO
│   ├── renovate.json5         # تحديث التبعيات
│   └── dependabot.yml          # أمان التبعيات
├── assets/
│   ├── wallpapers/            # خلفيات مخصصة
│   │   ├── zaatar-wallpaper.png
│   │   ├── zaatar-wallpaper.svg
│   │   └── zaatar-wallpaper-ultrawide.png
│   └── README.md
├── build_files/
│   └── build.sh               # سكربت التخصيص الرئيسي (378 سطر)
├── disk_config/
│   ├── disk.toml              # إعداد QCOW2
│   └── iso.toml               # إعداد Anaconda ISO
├── docs/
│   ├── FULL_REPORT.md         # هذا التقرير
│   ├── REPORT.md
│   ├── PERFORMANCE.md
│   ├── EXTENSIONS.md
│   ├── CHECKLIST.md
│   ├── DOWNLOAD.md
│   ├── LOCALE.md
│   ├── PROJECT.md
│   ├── ROADMAP.md
│   └── README.md
├── scripts/
│   ├── build.sh              # بناء محلي
│   ├── check-performance.sh  # فحص الأداء
│   ├── run-qcow2.sh          # تشغيل QCOW2 مباشرة
│   ├── run-iso.sh            # تشغيل ISO في QEMU
│   └── test-local.sh
├── Containerfile             # بناء الصورة
├── Justfile                  # أوامر البناء
├── cosign.pub                # مفتاح التوقيع العام
├── SECURITY.md               # سياسة الأمان
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── README.ar.md
└── artifacthub-repo.yml      # إعداد Artifact Hub
```

---

## 3. الحزم المثبتة (rpm-ostree)

| الحزمة | الغرض |
|--------|--------|
| langpacks-ar, langpacks-en | حزم اللغة العربية والإنجليزية |
| google-noto-sans-arabic-fonts | خطوط عربية |
| google-noto-kufi-arabic-fonts | خط كوفي |
| google-noto-sans-fonts | خطوط لاتينية |
| hunspell-ar, hunspell-en-US | الإملاء |
| ibus-m17n | إدخال عربي |
| rsms-inter-fonts | خط Inter (بديل SF Pro) |
| fira-code-fonts | خط أحادي |
| gnome-shell-extension-blur-my-shell | ضبابية للوحة |
| gnome-shell-extension-user-theme | ثيم GNOME Shell |
| gnome-extensions-app | إدارة الإضافات |
| sushi | Quick Look (Space في Nautilus) |
| sassc | بناء WhiteSur GTK |
| glib2-devel, libxml2 | تبعيات WhiteSur |
| irqbalance | توزيع المقاطعات على CPU |
| earlyoom | تمنع تجميد النظام عند امتلاء الذاكرة |

---

## 4. التطبيقات (Flatpak)

| التطبيق | المصدر | الغرض |
|---------|--------|-------|
| Pika Backup | Flathub | نسخ احتياطي تلقائي (مثل Time Machine) |

---

## 5. إضافات GNOME (من extensions.gnome.org)

| الإضافة | UUID | الإصدار | الوظيفة |
|---------|------|---------|---------|
| Dash2Dock Animated | dash2dock-lite@icedman.github.com | v86 | Dock مع zoom و bounce و autohide |
| Search Light | search-light@icedman.github.com | v42 | Spotlight (Super+Space) |
| Tasks in Panel | tasks-in-panel@fthx | v54 | اسم التطبيق في الشريط العلوي |
| Quick Settings Tweaks | quick-settings-tweaks@qwreey | v30 | Media Controls، Volume Mixer، DND |
| Rounded Window Corners Reborn | rounded-window-corners-reborn@flexagoon | v14 | زوايا مدورة للنوافذ |
| No Titlebar When Maximized | no-titlebar-when-maximized@alec.ninja | v19 | إخفاء شريط العنوان عند التكبير |
| Magic Lamp | compiz-alike-magic-lamp-effect@hermes83.github.com | v22 | تأثير Genie عند التصغير |
| Logo Menu | logomenu@aryan_k | v21 | قائمة أبل في الشريط العلوي |
| Blur my Shell | blur-my-shell@aunetx | RPM | ضبابية للوحة والـ dash |
| User Theme | user-theme@gnome-shell-extensions.gcampax.github.com | RPM | ثيم WhiteSur على GNOME Shell |

---

## 6. الثيمات والأيقونات (من GitHub)

| المكون | المصدر | الوصف |
|--------|--------|-------|
| WhiteSur GTK | vinceliuice/WhiteSur-gtk-theme | GTK3, GTK4, GNOME Shell, libadwaita, GDM |
| WhiteSur Icons | vinceliuice/WhiteSur-icon-theme | أيقونات WhiteSur-dark |
| WhiteSur Cursors | vinceliuice/WhiteSur-cursors | مؤشرات شبيهة بـ macOS |

---

## 7. إعدادات dconf الكاملة

### 01-zaatar-input-sources
```ini
[org/gnome/desktop/input-sources]
sources=[('xkb', 'us'), ('ibus', 'm17n:ar:kbd')]
```

### 02-zaatar-region
```ini
[org/gnome/system/locale]
region='ar_SY.UTF-8'
```

### 03-zaatar-appearance
```ini
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
```

### 04-zaatar-extensions
```ini
[org/gnome/shell]
enabled-extensions=['dash2dock-lite@icedman.github.com', 'search-light@icedman.github.com', 'tasks-in-panel@fthx', 'quick-settings-tweaks@qwreey', 'rounded-window-corners-reborn@flexagoon', 'no-titlebar-when-maximized@alec.ninja', 'blur-my-shell@aunetx', 'compiz-alike-magic-lamp-effect@hermes83.github.com', 'logomenu@aryan_k', 'user-theme@gnome-shell-extensions.gcampax.github.com']
favorite-apps=['org.gnome.Nautilus.desktop', 'org.mozilla.firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop']

[org/gnome/shell/extensions/dash2dock-lite]
icon-size=48, icon-effect=1, animate-icons=true, animate-icons-unmute=true
running-indicator-style=2, dock-location=3, autohide-dash=true, autohide-dodge=true
peek-hidden-icons=true, trash-icon=false, mounted-icon=false

[org/gnome/shell/extensions/search-light]
shortcut-search=['<Super>space'], show-panel-icon=false, blur-background=true, border-radius=12

[org/gnome/shell/extensions/tasks-in-panel]
show-task-for-focused-window-only=true, move-tasks-to-center=true
show-activities-indicator=false, move-date-menu-button-to-right=true

[org/gnome/shell/extensions/quick-settings-tweaks]
add-dnd-quick-toggle-enabled=true, media-control-enabled=true, volume-mixer-enabled=true

[org/gnome/shell/extensions/rounded-window-corners-reborn]
border-radius=12

[org/gnome/shell/extensions/blur-my-shell]
blur-dash=true, blur-panel=true, blur-overview=true

[org/gnome/shell/extensions/Logo-menu]
menu-button-icon-image=23
```

### 05-zaatar-nightlight-touchpad
```ini
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true, night-light-schedule-automatic=true, night-light-temperature=3700

[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true, two-finger-scrolling-enabled=true, natural-scroll=true, speed=0.2
```

---

## 8. إعدادات الأداء

### zram-generator (10-zaatar-performance.conf)
```ini
[zram0]
zram-size = min(ram, 16384)
compression-algorithm = zstd
```

### sysctl (99-zaatar-performance.conf)
```
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_background_ratio=5
vm.dirty_ratio=10
vm.page-cluster=0
```

### الخدمات
| الخدمة | الإجراء |
|--------|---------|
| irqbalance | enable |
| earlyoom | enable |
| fstrim.timer | enable |
| NetworkManager-wait-online | override → ExecStart=/bin/true |
| plymouth-quit-wait | disable |
| zaatar-power-profile | enable (throughput-performance) |

---

## 9. العلامة التجارية واسم النظام

### السكربت: `/usr/libexec/zaatar/update-os-name-by-locale.sh`
- يقرأ `LANG` ويحدّث os-release و machine-info و issue
- عربي → زعتر / زعتر 1.0
- إنجليزي → Zaatar / Zaatar 1.0

### التشغيل
- **عند الإقلاع:** zaatar-os-name-boot.service (يقرأ LANG من locale.conf)
- **عند تسجيل الدخول:** zaatar-os-name.desktop (autostart)

### sudoers
```
ALL ALL=(ALL) NOPASSWD: /usr/libexec/zaatar/update-os-name-by-locale.sh
```

### الملفات المعدّلة
- /etc/os-release, /usr/lib/os-release
- /etc/machine-info
- /etc/issue, /etc/issue.net
- /etc/system-release
- GRUB_DISTRIBUTOR

---

## 10. الأمان والحماية

### 10.1 سياسة الإبلاغ (SECURITY.md)
- دعم التصحيحات للإصدار المستقر
- الإبلاغ عن الثغرات عبر البريد (عدم فتح issue عام)
- الالتزام بالاستجابة والتعاون

### 10.2 توقيع الصورة (Cosign)
- توقيع الصورة بـ Cosign قبل النشر
- المفتاح العام: cosign.pub في المستودع
- المفتاح الخاص: SIGNING_SECRET في GitHub Secrets

### 10.3 مستخدم التجربة (demo)
- **المستخدم:** demo
- **كلمة المرور:** zaatar
- **الغرض:** تجربة سريعة – **يجب تغيير كلمة المرور أو حذف الحساب في الإنتاج**

### 10.4 صلاحيات sudo
- السكربت `update-os-name-by-locale.sh` فقط مُستثنى من كلمة مرور sudo
- الصلاحية محدودة بهذا السكربت فقط (لا يسمح بتنفيذ أوامر أخرى)

### 10.5 Flatpak
- التطبيقات من Flathub تعمل في sandbox
- Pika Backup: صلاحيات محدودة حسب الحاجة

### 10.6 ostree
- نظام الملفات ثابت (immutable) – التحديثات عبر طبقات
- يقلّل سطح الهجوم

### 10.7 Flatpak و GTK Theme
- override: `--filesystem=xdg-config/gtk-3.0:ro` و `gtk-4.0:ro`
- `--env=GTK_THEME=WhiteSur-Dark` لتطبيق WhiteSur على تطبيقات Flatpak

---

## 11. Containerfile

```dockerfile
FROM ghcr.io/ublue-os/bluefin:stable

COPY build_files/build.sh /tmp/build.sh
COPY assets/ /tmp/zaatar-assets/
RUN bash /tmp/build.sh
```

---

## 12. إعدادات القرص (disk_config)

### disk.toml (QCOW2)
```toml
[[customizations.filesystem]]
mountpoint = "/boot"
minsize = "512 MiB"

[[customizations.filesystem]]
mountpoint = "/"
minsize = "10 GiB"
```

### iso.toml (Anaconda)
- volume_id: Zaatar
- application_id: Zaatar 1.0
- kickstart: bootc switch + useradd demo
- وحدات معطّلة: Network, Security, Services, Users, Subscription, Timezone

---

## 13. سير العمل (CI/CD)

### build.yml
1. Lint (ShellCheck على build.sh)
2. Build (Buildah)
3. Push إلى ghcr.io
4. Sign (Cosign)

### build-disk.yml
- يُشغّل بعد نجاح build.yml
- يبني: qcow2 و anaconda-iso
- يرفع Artifacts (14 يوم)

---

## 14. السكربتات

### check-performance.sh
- يفحص: zram, swap, power profile, services
- للتشغيل على نظام Zaatar

### run-qcow2.sh
- تشغيل QCOW2 مباشرة (بدون تثبيت)
- يدعم: مسار مباشر أو ملف ZIP
- كشف تلقائي لـ RAM/CPU على macOS

### run-iso.sh
- تشغيل ISO في QEMU
- ينشئ قرص 64G إن لم يكن موجوداً

---

## 15. المتطلبات قبل النشر

| المطلوب | الوصف |
|---------|--------|
| SIGNING_SECRET | مفتاح Cosign الخاص (GitHub Secret) |
| cosign.pub | موجود في المستودع |
| logo.png | اختياري – لـ Artifact Hub |

---

## 16. ما لا يمكن تحقيقه أو غير متوفر

| البند | السبب |
|-------|--------|
| **ananicy-cpp** | آخر build في COPR فاشل – غير متوفر حالياً للتثبيت التلقائي |
| **Dynamic Wallpaper** | غير مضاف – يمكن للمستخدم تثبيت `gnome-shell-extension-dynamic-wallpaper` أو إضافة يدوية |
| **Dynamic Island / Apple Silicon** | تقنيات خاصة بـ Apple |
| **AirDrop / Handoff / iPhone Mirroring** | بروتوكولات Apple مغلقة |
| **SF Pro Font** | مرخص لـ Apple فقط |
| **iCloud** | خدمة Apple مغلقة |

---

## 17. الروابط

| الرابط |
|--------|
| المستودع: https://github.com/maher-xs/Zaatar |
| الصورة: ghcr.io/maher-xs/zaatar:latest |
| Universal Blue: https://universal-blue.org/ |
| bootc: https://github.com/bootc-dev/bootc |
| WhiteSur GTK: https://github.com/vinceliuice/WhiteSur-gtk-theme |
| Flathub: https://flathub.org/ |

---

*تم إعداد هذا التقرير من جميع ملفات المشروع وأكواده.*
