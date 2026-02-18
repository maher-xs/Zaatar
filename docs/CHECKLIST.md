# Zaatar – System Readiness Checklist

Everything included in the image for a complete, ready-to-use system.

## ✅ Language & Input

| Item | Status |
|------|--------|
| Arabic (ar_SY) + English (en_US) | Both installed, switch in Settings |
| Arabic keyboard (m17n) | Super+Space to switch |
| Noto Arabic fonts | Installed |
| Hunspell (ar, en-US) | Spellcheck in apps |

## ✅ Appearance

| Item | Status |
|------|--------|
| Tahoe theme (macOS-like) | Dark + blue accent + libadwaita |
| Zaatar wallpaper | macOS Big Sur–style, set by default |
| Ultrawide wallpaper | Available in Settings → Appearance |
| Papirus icons | Default icon theme |
| Flatpak theme override | Apps use system theme |

## ✅ Extensions (enabled on first boot)

| Extension | Status |
|-----------|--------|
| Dash to Dock | Bottom dock, enabled |
| Blur my Shell | Panel/dash blur, enabled |

## ✅ Branding

| Location | Shows |
|----------|-------|
| Settings → About | Zaatar 1.0 |
| Login (GDM) | Zaatar |
| Console / SSH | Zaatar 1.0 |
| hostnamectl | Zaatar |

## ✅ Build & CI

| Flow | Status |
|------|--------|
| build.yml | Lint → Build → Push → Sign |
| build-disk.yml | Auto after build, or PR/manual |
| qcow2 + anaconda-iso | Both produced |

## ✅ Documentation

| Doc | Purpose |
|-----|---------|
| README.md | Overview, switch, download |
| README.ar.md | Arabic version |
| docs/DOWNLOAD.md | Full download steps |
| docs/LOCALE.md | Change language/region |
| docs/EXTENSIONS.md | GNOME extensions |
| docs/PROJECT.md | Project structure |
| CONTRIBUTING.md | How to contribute |
| SECURITY.md | Security policy |

## One-time setup (before first push)

1. **SIGNING_SECRET** – Add Cosign private key as GitHub secret.
2. **cosign.pub** – Already in repo.
3. **logo.png** – Optional, for Artifact Hub (add to repo root, remove from .gitignore).
