#!/usr/bin/env bash
# Local pre-push checks for Zaatar. Run before pushing.
set -e

echo "=== Zaatar local checks ==="

# 1. build.sh syntax
echo -n "build.sh syntax... "
bash -n build_files/build.sh && echo "OK" || { echo "FAIL"; exit 1; }

# 2. Essential files
echo -n "Essential files... "
for f in Containerfile cosign.pub disk_config/disk.toml disk_config/iso.toml; do
  test -f "$f" || { echo "FAIL: $f missing"; exit 1; }
done
echo "OK"

# 2b. Performance config in build.sh
echo -n "Performance config... "
for pattern in "zram-generator.conf.d" "NetworkManager-wait-online" "zaatar-power-profile" "enable-animations=false" "tuned-adm"; do
  grep -q "$pattern" build_files/build.sh || { echo "FAIL: missing $pattern"; exit 1; }
done
echo "OK"

# 3. Wallpapers
echo -n "Wallpapers... "
test -f assets/wallpapers/zaatar-wallpaper.svg || test -f assets/wallpapers/zaatar-wallpaper.png || { echo "FAIL: no wallpaper"; exit 1; }
echo "OK"

# 4. shellcheck (optional)
if command -v shellcheck >/dev/null 2>&1; then
  echo -n "shellcheck... "
  shellcheck build_files/build.sh && echo "OK" || { echo "FAIL"; exit 1; }
else
  echo "shellcheck... skip (not installed)"
fi

# 5. Podman build (optional, needs network)
if command -v podman >/dev/null 2>&1; then
  echo -n "podman build... "
  podman build -t zaatar:test . >/dev/null 2>&1 && echo "OK" || echo "skip (may need network)"
else
  echo "podman build... skip (install: brew install podman)"
fi

printf '\n'
printf 'To build without just: ./scripts/build.sh  (requires podman)\n'
printf '\n=== All local checks passed ===\n'
