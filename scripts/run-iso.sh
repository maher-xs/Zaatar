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

echo "Starting QEMU VM (Zaatar installer)..."
echo "Disk: $DISK"
echo "Install QEMU: brew install qemu"
echo ""

qemu-system-x86_64 \
  -accel tcg \
  -m 4G -smp 2 \
  -cdrom "$ISO" \
  -drive file="$DISK",format=qcow2,if=virtio \
  -nic user \
  -display default
