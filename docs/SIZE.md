# تقليل حجم صورة زعتر

الصورة الحالية ~3.9 GB. معظم الحجم من القاعدة (Silverblue) نفسها.

## ما تم تطبيقه

| الإجراء | التوفير التقريبي |
|---------|-------------------|
| إزالة sassc, glib2-devel, libxml2 بعد بناء WhiteSur | ~80 MB |
| إزالة gnome-extensions-app (المستخدم يثبّت من Software) | ~15 MB |
| إزالة google-noto-kufi-arabic-fonts (noto-sans يكفي) | ~20 MB |
| WhiteSur icons بدون -a (بدون alternative) | ~30 MB |

## خيارات إضافية (للمستقبل)

| الخيار | التأثير | الملاحظات |
|--------|---------|-----------|
| **WhiteSur من COPR** | يوفر حزم البناء | حزمة WhiteSur-gtk-theme في COPR قد تكون قديمة. |
| **إزالة إضافات GNOME غير الأساسية** | ~5 MB | Magic Lamp، Logo Menu — المستخدم يثبّتها يدوياً. |

## القاعدة

**القاعدة:** `ghcr.io/ublue-os/silverblue:stable` (Universal Blue Silverblue).
