# Zaatar – الأداء وسلوك التطبيقات (مثل macOS)

دليل لجعل زعتر سريعاً وسلوك التطبيقات قريباً من macOS: التطبيقات تبقى في الذاكرة ولا تُقتل عند التبديل، مع استهلاك فعّال للموارد.

---

## 1. سلوك التطبيقات: Linux vs macOS

| السلوك | macOS | Linux (GNOME) |
|--------|-------|---------------|
| التطبيق يبقى في الذاكرة عند التبديل | ✓ | ✓ (نفس الشيء) |
| ضغط الذاكرة عند الامتلاء | ✓ (Memory compression) | ✓ (zram – Fedora مفعّل افتراضياً) |
| إيقاف التطبيقات الخلفية تلقائياً | App Nap | Linux يقلّل أولوية CPU للخلفية تلقائياً |
| Swap سريع | ✓ | ✓ (zram أسرع من swap على القرص) |

**الخلاصة:** Fedora/Silverblue يأتي مع zram مفعّلاً. التطبيقات تبقى في الذاكرة ولا تُقتل عند التبديل – مثل macOS. عند امتلاء الذاكرة، يستخدم النظام zram (ضغط في الذاكرة) بدل swap على القرص، وهذا أسرع بكثير.

---

## 2. ما هو مفعّل مسبقاً (لا تحتاج تعديله)

- **zram** – Fedora 33+ يفعّل zram-generator افتراضياً. تحقق: `zramctl` و `swapon`.
- **CFS (Completely Fair Scheduler)** – Linux يقلّل أولوية CPU للتطبيقات في الخلفية تلقائياً.
- **GNOME** – التطبيقات تبقى resident في الذاكرة عند التبديل؛ لا يوجد "قتل" تلقائي كما في بعض أنظمة الموبايل.

---

## 3. اقتراحات لتحسين الأداء

### 3.1 ملف تعريف الطاقة (Power Profile)

Silverblue يستخدم tuned-ppd. للأجهزة المكتبية أو عند الرغبة بأقصى أداء:

```bash
# اختيار "Performance" من Settings → Power
# أو عبر الطرفية:
tuned-adm profile throughput-performance
```

للحفاظ على البطارية: `tuned-adm profile balanced` أو `tuned-adm profile powersave`.

### 3.2 الحركات (مفعّلة افتراضياً)

زعتر يفعّل الحركات افتراضياً (مثل macOS). لتعطيلها لواجهة أسرع:

```bash
gsettings set org.gnome.desktop.interface enable-animations false
```

أو من Settings → Accessibility → Seeing → Reduce animation (فعّلها).

### 3.3 zram (مفعّل في زعتر حتى 16GB)

زعتر يضبط `max-zram-size = 16384` (16GB) افتراضياً. للتحقق بعد الإقلاع:

```bash
zramctl
swapon
```

### 3.4 إيقاف خدمات غير مستخدمة

```bash
# عرض الخدمات المفعّلة
systemctl list-unit-files --state=enabled

# مثال: إيقاف Bluetooth إن لم تستخدمه
sudo systemctl disable bluetooth
```

---

## 4. ما تم إضافته في build.sh (مفعّل افتراضياً)

| الإضافة | الغرض |
|---------|-------|
| `zram-generator.conf.d/10-zaatar-performance.conf` | zram حتى 16GB، ضغط zstd |
| `sysctl.d/99-zaatar-performance.conf` | vm.swappiness=10، vfs_cache_pressure=50 (مثل macOS) |
| `NetworkManager-wait-online.service.d/zaatar-boot.conf` | عدم انتظار الشبكة عند الإقلاع → إقلاع أسرع |
| `zaatar-power-profile.service` | ملف الطاقة الافتراضي: throughput-performance |
| `irqbalance` | توزيع المقاطعات على أنوية CPU |
| `earlyoom` | تمنع تجميد النظام عند امتلاء الذاكرة (مثل macOS) |
| `fstrim.timer` | TRIM تلقائي للـ SSD |
| `plymouth-quit-wait.service` | معطّل (إقلاع أسرع) |
| `dconf 03-zaatar-appearance` | `enable-animations=true` افتراضياً (مثل macOS) |

**ملاحظات:**
- على أجهزة اللابتوب: تغيير ملف الطاقة من Settings → Power إلى Balanced أو Power Saver لتوفير البطارية.
- على الـ VM أو بعض المعالجات: قد لا يتوفر "performance" – الخدمة تتجاهل الفشل ولا تؤثر على الإقلاع.
- **ananicy-cpp** (أولوية CPU تلقائية مثل App Nap): غير متوفر في مستودعات Fedora الرسمية – يتطلب COPR (مثلاً `bieszczaders/kernel-cachyos-addons`).

---

## 5. قائمة تحقق سريعة

تشغيل السكربت على نظام Zaatar:

```bash
./scripts/check-performance.sh
```

أو يدوياً:

- [ ] التحقق من zram: `zramctl` و `swapon`
- [ ] التحقق من ملف الطاقة: `tuned-adm active` (يجب أن يكون throughput-performance)
- [ ] اختيار Power Profile: Settings → Power → Performance (للأداء) أو Balanced (للتوازن)
- [ ] إيقاف الخدمات غير المستخدمة

---

## 6. مراجع

- [Fedora SwapOnZRAM](https://fedoraproject.org/wiki/Changes/SwapOnZRAM)
- [zram-generator](https://github.com/systemd/zram-generator)
