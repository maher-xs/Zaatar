# زعتر (Zaatar)

**زعتر** نظام تشغيل سطح مكتب عربي/إنجليزي مبني على [Universal Blue](https://universal-blue.org/) Bluefin. النظام معرّف باسم **Zaatar** في كل مكان: المثبّت، شاشة تسجيل الدخول، والإعدادات.

- **اللغات:** العربية (ar_SY) والإنجليزية (en_US). يمكنك التبديل من **الإعدادات → المنطقة واللغة**.
- **القاعدة:** [ghcr.io/ublue-os/bluefin:stable](https://github.com/ublue-os/bluefin) (bootc).

## التبديل إلى زعتر (من نظام bootc)

```bash
sudo bootc switch ghcr.io/maher-xs/zaatar:latest
```

ثم أعد التشغيل.

## التبديل بين العربية والإنجليزية

1. **الإعدادات** → **المنطقة واللغة**.
2. تحت **اللغة**، أضف العربية أو الإنجليزية واختر لغة العرض.
3. لوحة المفاتيح: Super+Space للتبديل.

## تحميل صورة القرص أو ISO

من **Actions** → **Build disk images** → **Artifacts**:

- **disk-qcow2** → داخل ZIP: **qcow2/disk.qcow2** (للمحاكي الافتراضي).
- **disk-anaconda-iso** → داخل ZIP: **bootiso/install.iso** (مثبّت Anaconda).

التفاصيل الكاملة: [docs/DOWNLOAD.md](docs/DOWNLOAD.md).

## توثيق إضافي

- [دليل التحميل والتشغيل](docs/DOWNLOAD.md)
- [تغيير اللغة والمنطقة](docs/LOCALE.md)
- [النسخة الإنجليزية](README.md)
