#!/usr/bin/env bash
# Zaatar – قائمة تحقق الأداء (تشغيل على نظام Zaatar/Linux)
set -e

echo "=== Zaatar Performance Check ==="
echo

echo "1. zram:"
if command -v zramctl &>/dev/null; then
  zramctl 2>/dev/null || echo "   (لا يوجد أجهزة zram نشطة)"
else
  echo "   zramctl غير متوفر"
fi

echo
echo "2. swap:"
if command -v swapon &>/dev/null; then
  swapon --show 2>/dev/null || echo "   (لا يوجد swap)"
else
  echo "   swapon غير متوفر"
fi

echo
echo "3. Power profile:"
if command -v tuned-adm &>/dev/null; then
  tuned-adm active 2>/dev/null || echo "   tuned-adm فشل"
else
  echo "   tuned-adm غير متوفر"
fi

echo
echo "4. Services: قائمة الخدمات المفعّلة (مثال):"
if command -v systemctl &>/dev/null; then
  systemctl list-unit-files --state=enabled 2>/dev/null | head -20 || true
fi

echo
echo "--- انتهى ---"
echo "للأداء: Settings → Power → Performance"
echo "للبطارية: Settings → Power → Balanced أو Power Saver"
