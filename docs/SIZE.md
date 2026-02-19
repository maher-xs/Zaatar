# تقليل حجم صورة زعتر

الصورة الحالية ~3.9 GB. معظم الحجم من القاعدة (Bluefin) نفسها.

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
| ~~قاعدة Silverblue بدل Bluefin~~ | تم التطبيق | |
| **WhiteSur من COPR** | يوفر حزم البناء | حزمة WhiteSur-gtk-theme في COPR قد تكون قديمة. |
| **إزالة إضافات GNOME غير الأساسية** | ~5 MB | Magic Lamp، Logo Menu — المستخدم يثبّتها يدوياً. |

## القاعدة

**القاعدة:** Fedora Silverblue الرسمي (`ghcr.io/fedora-ostree-desktops/silverblue:42`) — بدون Universal Blue كوسيط. إذا فشل سحب الصورة من ghcr.io، جرّب `quay.io/fedora-ostree-desktops/silverblue:42` بدلاً.
