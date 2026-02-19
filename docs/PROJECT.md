# Zaatar – Project Structure

Overview of the project layout and where to change things.

## Directory layout

```
Zaatar/
├── .github/
│   ├── dependabot.yml       # Dependabot: GitHub Actions updates
│   ├── renovate.json5       # Renovate: dependency updates
│   └── workflows/
│       ├── build.yml        # Build and push container image
│       └── build-disk.yml   # Build QCOW2 and Anaconda ISO
├── assets/
│   ├── wallpapers/          # Custom Zaatar wallpaper (SVG or PNG)
│   └── README.md
├── build_files/
│   └── build.sh             # Main customization: packages, locale, branding, theme, icons
├── disk_config/
│   ├── disk.toml            # QCOW2/raw disk layout (root, /boot)
│   └── iso.toml             # Anaconda ISO config (kickstart, branding)
├── docs/
│   ├── README.md            # Documentation index
│   ├── CHECKLIST.md         # System readiness – everything included
│   ├── DOWNLOAD.md          # How to download and use artifacts
│   ├── EXTENSIONS.md        # GNOME extensions (pre-installed + recommended)
│   ├── LOCALE.md            # How to change language and region
│   ├── PERFORMANCE.md       # zram, power profile, boot speed
│   ├── PROJECT.md           # This file
│   └── ROADMAP.md           # Development plan
├── scripts/
│   ├── build.sh             # Simple build without just (fallback)
│   ├── run-iso.sh           # Run Anaconda installer ISO in QEMU
│   ├── run-qcow2.sh         # Run QCOW2 directly – no installer (fast testing)
│   └── test-local.sh       # Local checks before push
├── .dockerignore
├── .editorconfig            # Editor consistency (indent, charset)
├── .gitignore
├── Containerfile            # Single-stage: FROM fedora-ostree-desktops/silverblue, run build.sh
├── CONTRIBUTING.md          # How to contribute
├── Justfile                 # Local build commands (just build, just build-qcow2, etc.)
├── LICENSE
├── README.md
├── README.ar.md             # Arabic README
├── SECURITY.md              # Security policy
├── artifacthub-repo.yml     # Artifact Hub metadata (optional)
└── cosign.pub               # Public key for image signing
```

## Naming conventions

| Context | Convention | Example |
|---------|-------------|---------|
| Product name (user-facing) | Title Case | **Zaatar** |
| OCI image, registry, IDs | lowercase | `zaatar`, `ghcr.io/maher-xs/zaatar` |
| File names | lowercase-with-hyphens | `iso.toml`, `run-iso.sh` |
| Docs in `docs/` | UPPERCASE | `CHECKLIST.md`, `PERFORMANCE.md` |
| Root docs | PascalCase | `README.md`, `CONTRIBUTING.md` |

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
| Performance (zram, power, boot) | `build_files/build.sh` + `docs/PERFORMANCE.md` |

## Build flow

1. **build.yml** – Builds container from Containerfile, pushes to ghcr.io.
2. **build-disk.yml** – Runs automatically after build.yml succeeds (workflow_run), or on PR/manual. Produces qcow2 and anaconda-iso.
