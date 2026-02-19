# تقرير شامل – نظام زعتر (Zaatar)

**تاريخ التقرير:** فبراير 2025  
**الإصدار:** Zaatar 1.0  
**المستودع:** https://github.com/maher-xs/Zaatar

---

## 1. نظرة عامة

**زعتر (Zaatar)** نظام تشغيل سطح مكتب عربي/إنجليزي مبني على [Universal Blue Bluefin](https://github.com/ublue-os/bluefin) بتقنية bootc. النظام معرّف باسم **Zaatar** في كل مكان: المثبّت، شاشة تسجيل الدخول، الإعدادات، وحتى GRUB.

| البند | الوصف |
|-------|--------|
| **القاعدة** | ghcr.io/ublue-os/bluefin:stable |
| **التقنية** | bootc (ostree containers) |
| **سطح المكتب** | GNOME مع ثيم Tahoe (مستوحى من macOS) |
| **اللغات** | العربية (ar_SY) والإنجليزية (en_US) |
| **المنطقة** | سوريا (دمشق) |

---

## 2. المكونات والوظائف

### 2.1 اللغة والإدخال

| المكون | الحالة |
|--------|--------|
| العربية (ar_SY) | مُثبتة، التبديل من الإعدادات |
| الإنجليزية (en_US) | مُثبتة |
| لوحة مفاتيح عربية (ibus-m17n) | Super+Space للتبديل |
| خطوط Noto العربية | مُثبتة |
| Hunspell (إملاء عربي وإنجليزي) | مُثبت |

### 2.2 المظهر (macOS-like)

| المكون | الوصف |
|--------|--------|
| ثيم Tahoe | داكن، لون أزرق، libadwaita |
| أيقونات WhiteSur | macOS Big Sur–style |
| خلفية زعتر | مخصصة (PNG/SVG)، افتراضية |
| خلفية Ultrawide | متوفرة في الإعدادات |
| أزرار النافذة | يسار (أحمر/أصفر/أخضر) |
| الحركات | مفعّلة |
| الزوايا الساخنة | مفعّلة |
| Flatpak | يستخدم ثيم النظام |

### 2.3 إضافات GNOME (مفعّلة افتراضياً)

| الإضافة | الوظيفة |
|---------|----------|
| Dash to Dock | شريط سفلي، أسفل الشاشة |
| Blur my Shell | ضبابية للوحة والـ dash |

### 2.4 العلامة التجارية (Branding)

| المكان | ما يظهر |
|--------|---------|
| الإعدادات → حول | Zaatar 1.0 |
| شاشة تسجيل الدخول (GDM) | Zaatar |
| الطرفية / SSH | Zaatar 1.0 |
| hostnamectl | Zaatar |
| GRUB | Zaatar 1.0 |

### 2.5 مستخدم التجربة (Demo)

| المستخدم | كلمة المرور | الغرض |
|----------|-------------|--------|
| **demo** | **zaatar** | تجربة سريعة بدون إنشاء حساب |

### 2.6 التطبيقات

| المصدر | الاستخدام |
|--------|-----------|
| الصورة الأساسية | Firefox، تطبيقات GNOME |
| Flathub | تثبيت المزيد من **البرامج** |
| Ulauncher | Spotlight-like (Super)، تشغيل تلقائي |
| Sushi | Quick Look – Space في Nautilus |

---

## 3. الحزم المثبتة (أساسية فقط)

| الحزمة | الغرض |
|--------|--------|
| langpacks-ar, langpacks-en | حزم اللغة |
| google-noto-sans-arabic-fonts | خطوط عربية |
| google-noto-kufi-arabic-fonts | خط كوفي |
| google-noto-sans-fonts | خطوط لاتينية |
| hunspell-ar, hunspell-en-US | الإملاء |
| ibus-m17n | إدخال عربي |
| sushi | Quick Look (معاينة سريعة) |
| gnome-shell-extension-dash-to-dock | إضافة الشريط |
| gnome-shell-extension-blur-my-shell | إضافة الضبابية |
| gnome-extensions-app | إدارة الإضافات |

---

## 4. الأداء

| الإعداد | القيمة |
|--------|--------|
| zram | حتى 16 GB |
| ملف طاقة | throughput-performance (tuned) |
| إقلاع أسرع | تعطيل انتظار الشبكة |
| حركات | معطّلة (enable-animations=false) |

---

## 5. هيكل المشروع

```
Zaatar/
├── .github/workflows/     # build.yml, build-disk.yml
├── assets/wallpapers/     # خلفيات مخصصة
├── build_files/build.sh   # التخصيص الرئيسي
├── disk_config/           # disk.toml, iso.toml
├── docs/                  # التوثيق
├── scripts/              # run-qcow2.sh, run-iso.sh, build.sh
├── Containerfile          # بناء الصورة
├── Justfile               # أوامر البناء
└── cosign.pub             # مفتاح التوقيع
```

---

## 6. سير البناء (CI/CD)

| المرحلة | الوظيفة |
|---------|----------|
| **build.yml** | Lint → Build → Push → Sign |
| **build-disk.yml** | يبدأ بعد build.yml، يُنتج qcow2 و anaconda-iso |

### المخرجات

| المخرج | المحتوى |
|--------|---------|
| **disk-qcow2** | qcow2/disk.qcow2 – جهاز افتراضي جاهز، بدون تثبيت |
| **disk-anaconda-iso** | bootiso/install.iso – مثبّت Anaconda كامل |

---

## 7. التثبيت والاستخدام

### من نظام bootc

```bash
sudo bootc switch ghcr.io/maher-xs/zaatar:latest
```

ثم أعد التشغيل.

### تحميل صورة القرص (للتجربة)

1. GitHub → Actions → Build disk images → Artifacts
2. حمّل **disk-qcow2**
3. فك الضغط ثم: `./scripts/run-qcow2.sh disk-qcow2.zip`
4. سجّل دخول: **demo** / **zaatar**

---

## 8. التكوينات الرئيسية

### disk_config/disk.toml (QCOW2)

- `/boot`: 512 MiB
- `/`: 10 GiB
- المستخدم demo من الصورة

### disk_config/iso.toml (مثبّت Anaconda)

- volume_id: Zaatar
- application_id: Zaatar 1.0
- kickstart: bootc switch + إنشاء مستخدم demo
- وحدات معطّلة: Network, Security, Services, Users, Subscription, Timezone

---

## 9. التوثيق

| الملف | الغرض |
|-------|--------|
| README.md | نظرة عامة |
| README.ar.md | النسخة العربية |
| docs/CHECKLIST.md | قائمة الجاهزية |
| docs/DOWNLOAD.md | التحميل والتشغيل |
| docs/LOCALE.md | اللغة والمنطقة |
| docs/EXTENSIONS.md | إضافات GNOME |
| docs/PERFORMANCE.md | الأداء |
| docs/PROJECT.md | هيكل المشروع |
| docs/ROADMAP.md | خطة التطوير |

---

## 10. الإعداد المسبق (قبل أول push)

1. **SIGNING_SECRET** – مفتاح Cosign الخاص كـ GitHub secret
2. **cosign.pub** – موجود في المستودع
3. **logo.png** – اختياري، لـ Artifact Hub

---

## 11. روابط

| الرابط |
|--------|
| المستودع: https://github.com/maher-xs/Zaatar |
| الصورة: ghcr.io/maher-xs/zaatar:latest |
| Universal Blue: https://universal-blue.org/ |
| bootc: https://github.com/bootc-dev/bootc |

---

*تم إعداد هذا التقرير تلقائياً من هيكل المشروع وتوثيقه.*
