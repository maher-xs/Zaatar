#!/usr/bin/env bash
# Run Zaatar directly from QCOW2 – no installer. For fast testing.
# Usage: ./scripts/run-qcow2.sh [path-to-disk.qcow2 or path-to-disk-qcow2.zip]
# Uses native QEMU (brew install qemu) – works on macOS.
set -e

INPUT="${1:-}"
DISK=""

if [[ -z "$INPUT" ]]; then
  # Default: look for disk in common locations
  if [[ -f "output/qcow2/disk.qcow2" ]]; then
    DISK="$(pwd)/output/qcow2/disk.qcow2"
  elif [[ -f "output/zaatar-disk.qcow2" ]]; then
    DISK="$(pwd)/output/zaatar-disk.qcow2"
  else
    echo "Usage: $0 [path-to-disk.qcow2] or [path-to-disk-qcow2.zip]"
    echo ""
    echo "No QCOW2 found. Options:"
    echo "  1. Download disk-qcow2 from GitHub Actions → Artifacts"
    echo "  2. unzip disk-qcow2.zip"
    echo "  3. Run: $0 path/to/qcow2/disk.qcow2"
    echo ""
    echo "Or place disk.qcow2 in output/qcow2/ or output/zaatar-disk.qcow2"
    exit 1
  fi
elif [[ -f "$INPUT" && "$INPUT" == *.qcow2 ]]; then
  DISK="$(realpath "$INPUT" 2>/dev/null || echo "$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")")"
elif [[ -f "$INPUT" && "$INPUT" == *.zip ]]; then
  TMPDIR=$(mktemp -d)
  trap "rm -rf $TMPDIR" EXIT
  unzip -o -d "$TMPDIR" "$INPUT"
  if [[ -f "$TMPDIR/qcow2/disk.qcow2" ]]; then
    DISK="$TMPDIR/qcow2/disk.qcow2"
  else
    echo "No qcow2/disk.qcow2 in $INPUT"
    exit 1
  fi
else
  echo "File not found: $INPUT"
  exit 1
fi

echo "Starting QEMU (Zaatar – direct boot, no installer)..."
echo "Disk: $DISK"
echo "Install QEMU: brew install qemu"
echo ""

qemu-system-x86_64 \
  -accel tcg \
  -m 4G -smp 2 \
  -drive file="$DISK",format=qcow2,if=virtio \
  -nic user \
  -display default
