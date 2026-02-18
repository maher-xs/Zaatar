# تحميل صورة القرص وملف ISO – الطريقة الكاملة

## أين تحصل على الملفات

1. افتح مستودع زعتر على GitHub.
2. اضغط **Actions**.
3. من القائمة اليسرى اختر **Build disk images**.
4. اضغط على آخر تشغيل ناجح (علامة خضراء).
5. انزل إلى قسم **Artifacts** في أسفل الصفحة.

ستجد artifact واحد أو اثنين حسب نجاح البناء:

| الاسم الذي يظهر | الصيغة التي تحمّلها | المحتوى بعد فك الضغط |
|-----------------|----------------------|----------------------|
| **disk-qcow2**  | `disk-qcow2.zip`     | مجلد فيه ملف **qcow2/disk.qcow2** (صورة جهاز افتراضي) |
| **disk-anaconda-iso** | `disk-anaconda-iso.zip` | مجلد فيه ملف **bootiso/install.iso** (قرص تثبيت) |

---

## الصيغة الكاملة للملفات بعد التحميل

### 1) صورة القرص للجهاز الافتراضي (QCOW2)

- **ما تحمّله من GitHub:** ملف واحد باسم **disk-qcow2** → يحمَّل كـ **disk-qcow2.zip**.
- **بعد فك الضغط (unzip):**
  - المسار الكامل لملف القرص:
    ```
    disk-qcow2.zip
    └── qcow2/
        └── disk.qcow2
    ```
  - الملف الجاهز للاستخدام: **qcow2/disk.qcow2**.

**أمر فك الضغط (مثال):**
```bash
unzip disk-qcow2.zip
# الناتج: مجلد فيه qcow2/disk.qcow2
```

**استخدام الملف:**
- في QEMU/KVM أو VirtualBox: اختر **qcow2/disk.qcow2** كقرص للجهاز الافتراضي.

---

### 2) قرص التثبيت (ISO)

- **ما تحمّله من GitHub:** ملف واحد باسم **disk-anaconda-iso** → يحمَّل كـ **disk-anaconda-iso.zip**.
- **بعد فك الضغط (unzip):**
  - المسار الكامل لملف ISO:
    ```
    disk-anaconda-iso.zip
    └── bootiso/
        └── install.iso
    ```
  - الملف الجاهز للحرق أو التشغيل: **bootiso/install.iso**.

**أمر فك الضغط (مثال):**
```bash
unzip disk-anaconda-iso.zip
# الناتج: مجلد فيه bootiso/install.iso
```

**استخدام الملف:**
- احرق **bootiso/install.iso** على USB (مثلاً بـ Rufus أو `dd`) أو شغّله كقرص في جهاز افتراضي لتثبيت زعتر على جهاز حقيقي.

---

## ملخص سريع

| المطلوب        | من GitHub تحمّل      | بعد فك الـ ZIP الملف الجاهز      |
|----------------|---------------------|-----------------------------------|
| جهاز افتراضي  | **disk-qcow2**      | **qcow2/disk.qcow2**              |
| تثبيت (ISO)   | **disk-anaconda-iso** | **bootiso/install.iso**         |

كل شيء يأتيك كـ **ZIP** من GitHub؛ الملف الفعلي الذي تستخدمه (.qcow2 أو .iso) يكون **داخل** الـ ZIP في المسارات أعلاه.

---

## ليش بصيغة ZIP؟

GitHub يضغط كل **Artifact** تلقائياً ويحمّلك إياه كـ **.zip**. ما في طريقة تحميل الملف الخام (.qcow2 أو .iso) مباشرة من صفحة Artifacts. الخطوة الأولى دائماً: حمّل الـ ZIP ثم **فك الضغط** واستخدم الملف من جوا.

---

## كيف تشغّل وتختبر كل نظام

### اختبار 1: صورة القرص (QCOW2) – جهاز افتراضي جاهز

هذي صورة قرص كاملة: فتحها = تشغيل زعتر مباشرة بدون تثبيت.

1. **حمّل** من Artifacts: **disk-qcow2** (يحمّل كـ `disk-qcow2.zip`).
2. **فك الضغط:**
   ```bash
   unzip disk-qcow2.zip
   ```
3. **شغّل الجهاز الافتراضي:**

   **على لينكس (QEMU/KVM):**
   ```bash
   qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 \
     -drive file=qcow2/disk.qcow2,format=qcow2 \
     -bios /usr/share/edk2/ovmf/OVMF_CODE.fd
   ```
   أو إذا عندك **Virt-Manager**: New VM → Import existing disk → اختر **qcow2/disk.qcow2**.

   **على macOS (Apple Silicon):** الصورة x86_64 فتُشغّل بمحاكاة برمجية (TCG). استخدم UEFI عبر **pflash** (حزمة Homebrew لا تضم ملف vars لـ x86_64 فاستخدم code فقط):
   ```bash
   QEMU_SHARE="/opt/homebrew/Cellar/qemu/10.2.1/share/qemu"
   qemu-system-x86_64 -accel tcg -m 4096 -smp 2 \
     -drive if=pflash,format=raw,readonly=on,file="$QEMU_SHARE/edk2-x86_64-code.fd" \
     -drive file=qcow2/disk.qcow2,format=qcow2
   ```
   إن إصدار QEMU عندك غير 10.2.1 غيّر المسار: `ls /opt/homebrew/Cellar/qemu/`. أو استخدم **UTM** وافتح الملف من الواجهة.

   **على ويندوز:** استخدم VirtualBox أو VMware: New VM → استخدم القرص الموجود → اختر **qcow2/disk.qcow2**.

بعد التشغيل يقلع زعتر مثل جهاز حقيقي وتقدر تختبر الواجهة واللغة.

---

### اختبار 2: قرص التثبيت (ISO) – تثبيت على جهاز أو VM

هذا قرص تثبيت: يقلع منه الجهاز ثم يثبّت زعتر على القرص.

1. **حمّل** من Artifacts: **disk-anaconda-iso** (يحمّل كـ `disk-anaconda-iso.zip`).
2. **فك الضغط:**
   ```bash
   unzip disk-anaconda-iso.zip
   ```
3. **تشغيل ISO:**

   **في جهاز افتراضي (للتجربة):**
   ```bash
   qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -cdrom bootiso/install.iso \
     -drive file=./disk.raw,format=raw,size=20G \
     -bios /usr/share/edk2/ovmf/OVMF_CODE.fd
   ```
   أو في VirtualBox: New VM → عند إعداد القرص اختر "Boot from ISO" واختر **bootiso/install.iso**.

   **على جهاز حقيقي:** اكتب **bootiso/install.iso** على فلاشة (Rufus أو `dd`) ثم شغّل الجهاز من الفلاشة واتبع خطوات التثبيت.

بعد انتهاء التثبيت يقلع النظام زعتر من القرص.

---

## ملخص: من ZIP إلى التشغيل

| النظام           | تحميل من GitHub | بعد فك ZIP        | كيف تشغّله |
|------------------|-----------------|-------------------|------------|
| جهاز جاهز (VM)  | disk-qcow2      | qcow2/disk.qcow2  | QEMU أو VirtualBox أو Virt-Manager |
| تثبيت (ISO)     | disk-anaconda-iso | bootiso/install.iso | QEMU/VirtualBox كـ CD، أو فلاشة لجهاز حقيقي |
