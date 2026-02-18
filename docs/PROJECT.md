# Zaatar – Project Structure

Overview of the project layout and where to change things.

## Directory layout

```
Zaatar/
├── assets/
│   ├── wallpapers/       # Custom Zaatar wallpaper (SVG or PNG)
│   └── README.md
├── build_files/
│   └── build.sh          # Main customization: packages, locale, branding, theme, icons
├── disk_config/
│   ├── disk.toml         # QCOW2/raw disk layout (root, /boot)
│   ├── iso.toml          # Anaconda ISO config (kickstart, branding)
│   ├── iso-gnome.toml    # Alternative ISO config (template)
│   └── iso-kde.toml      # Alternative ISO config (template)
├── docs/
│   ├── CHECKLIST.md      # System readiness – everything included
│   ├── DOWNLOAD.md       # How to download and use artifacts
│   ├── EXTENSIONS.md     # GNOME extensions (pre-installed + recommended)
│   ├── LOCALE.md         # How to change language and region
│   ├── PROJECT.md        # This file
│   └── ROADMAP.md        # Development plan
├── .github/workflows/
│   ├── build.yml         # Build and push container image
│   └── build-disk.yml    # Build QCOW2 and Anaconda ISO
├── Containerfile        # Single-stage: FROM bluefin, run build.sh
├── artifacthub-repo.yml  # Artifact Hub metadata (optional)
├── cosign.pub           # Public key for image signing
├── Justfile             # Local build commands (just build, just build-qcow2, etc.)
└── README.md
```

## Where to change what

| What to change | File |
|----------------|------|
| Packages, locale, branding, input sources | `build_files/build.sh` |
| Disk layout (partitions, sizes) | `disk_config/disk.toml` |
| ISO branding, kickstart, Anaconda modules | `disk_config/iso.toml` |
| Base image | `Containerfile` (FROM line) |
| Image name, registry, tags | `.github/workflows/build.yml` (env) |
| Disk build types (qcow2, anaconda-iso) | `.github/workflows/build-disk.yml` (matrix) |
| Artifact Hub listing | `artifacthub-repo.yml` |

## Build flow

1. **build.yml** – Builds container from Containerfile, pushes to ghcr.io.
2. **build-disk.yml** – Runs automatically after build.yml succeeds (workflow_run), or on PR/manual. Produces qcow2 and anaconda-iso.
