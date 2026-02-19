#!/usr/bin/env bash
# Run Zaatar directly from QCOW2 – no installer. For fast testing.
# Usage: ./scripts/run-qcow2.sh [path-to-disk.qcow2 or path-to-disk-qcow2.zip]
# Uses native QEMU (brew install qemu) – works on macOS.
# Auto-detects RAM/CPU on macOS. Override: QEMU_RAM=4G QEMU_CPUS=4
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

# Auto-detect RAM/CPU on macOS (leave headroom for host)
if [[ -z "${QEMU_RAM:-}" ]] && [[ "$(uname -s)" == "Darwin" ]]; then
  SYS_RAM_GB=$(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1024 / 1024 / 1024))
  if [[ "$SYS_RAM_GB" -le 8 ]]; then
    QEMU_RAM="4G"
    QEMU_CPUS="${QEMU_CPUS:-4}"
  elif [[ "$SYS_RAM_GB" -le 16 ]]; then
    QEMU_RAM="6G"
    QEMU_CPUS="${QEMU_CPUS:-4}"
  else
    QEMU_RAM="8G"
    QEMU_CPUS="${QEMU_CPUS:-6}"
  fi
fi
RAM="${QEMU_RAM:-8G}"
CPUS="${QEMU_CPUS:-4}"

echo "Starting QEMU (Zaatar – direct boot, no installer)..."
echo "Disk: $DISK"
echo "RAM: $RAM | CPUs: $CPUS (auto for macOS; override: QEMU_RAM=4G QEMU_CPUS=4)"
echo "Install QEMU: brew install qemu"
echo ""

qemu-system-x86_64 \
  -accel tcg \
  -m "$RAM" -smp "$CPUS" \
  -drive file="$DISK",format=qcow2,if=virtio \
  -nic user \
  -display default
