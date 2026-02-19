#!/usr/bin/env bash
# Run Zaatar install ISO in QEMU. Usage: ./scripts/run-iso.sh [path-to-disk-anaconda-iso.zip]
# Uses native QEMU (brew install qemu) – works on macOS with HVF acceleration.
set -e

ZIP="${1:-disk-anaconda-iso.zip}"
if [[ ! -f "$ZIP" ]]; then
  echo "Usage: $0 [path-to-disk-anaconda-iso.zip]"
  echo "Example: $0 ~/Downloads/disk-anaconda-iso.zip"
  exit 1
fi

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT
unzip -o -d "$TMPDIR" "$ZIP"
ISO="$TMPDIR/bootiso/install.iso"
[[ -f "$ISO" ]] || { echo "No install.iso in $ZIP"; exit 1; }

DISK="$(pwd)/output/zaatar-disk.qcow2"
mkdir -p output
[[ -f "$DISK" ]] || qemu-img create -f qcow2 "$DISK" 64G

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

echo "Starting QEMU VM (Zaatar installer)..."
echo "Disk: $DISK | RAM: $RAM | CPUs: $CPUS"
echo "Install QEMU: brew install qemu"
echo ""

qemu-system-x86_64 \
  -accel tcg \
  -m "$RAM" -smp "$CPUS" \
  -cdrom "$ISO" \
  -drive file="$DISK",format=qcow2,if=virtio \
  -nic user \
  -display default
