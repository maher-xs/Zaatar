# Contributing to Zaatar

Thank you for your interest in contributing to Zaatar.

## Quick start

### Prerequisites

- [just](https://just.systems/) – command runner
- [Podman](https://podman.io/) – container runtime

### Local build

```bash
# Build container image
just build
# Or without just: ./scripts/build.sh

# Build QCOW2 disk image (Linux only; requires image built first)
just build-qcow2

# Run VM with QCOW2 (Linux)
just run-vm-qcow2
```

### Testing on macOS

macOS cannot build QCOW2 locally (use GitHub Actions). To test:

1. Download **disk-qcow2** from Actions → Artifacts.
2. Run: `./scripts/run-qcow2.sh disk-qcow2.zip` (or path to `qcow2/disk.qcow2`).

This boots Zaatar directly without the installer. For the full installer: `./scripts/run-iso.sh disk-anaconda-iso.zip`.

### Project layout

- `build_files/build.sh` – main customization script (packages, locale, branding)
- `disk_config/` – disk and ISO configuration
- `Containerfile` – container build definition

See [docs/PROJECT.md](docs/PROJECT.md) for full structure.

## Where to change things

| Change | File |
|--------|------|
| Packages, locale, branding | `build_files/build.sh` |
| Disk layout | `disk_config/disk.toml` |
| ISO branding, kickstart | `disk_config/iso.toml` |
| Base image | `Containerfile` |

## Submitting changes

1. Fork the repository.
2. Create a branch for your change.
3. Make your changes.
4. Open a pull request.

## Testing

- Run `just build` to ensure the container builds.
- Run `just build-qcow2` and `just run-vm-qcow2` to test the disk image locally.
- For CI: push to a branch and open a PR; workflows run on push and PR.

## Questions

- [Universal Blue Forums](https://universal-blue.discourse.group/)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
