# Zaatar – System Readiness Checklist

Everything included in the image for a complete, ready-to-use system.

## ✅ Language & Input

| Item | Status |
|------|--------|
| Arabic (ar_SY) + English (en_US) | Both installed, switch in Settings |
| Arabic keyboard (m17n) | Super+Space to switch |
| Noto Arabic fonts | Installed |
| Hunspell (ar, en-US) | Spellcheck in apps |

## ✅ Appearance (macOS-like)

| Item | Status |
|------|--------|
| WhiteSur theme | GTK, GNOME Shell, libadwaita, GDM |
| WhiteSur icons | macOS Big Sur–style icon theme |
| Zaatar wallpaper | Set by default |
| Ultrawide wallpaper | Available in Settings → Appearance |
| Window buttons | Left (close, minimize, maximize) |
| Animations | Enabled |
| Hot corners | Enabled |
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

## ✅ Apps

| Source | Use |
|--------|-----|
| Base image | Firefox, GNOME apps |
| Flathub | المستخدم يثبّت من **Software** (Pika Backup، Steam، GSConnect، إلخ) |
| Sushi | Quick Look – Space في Nautilus |

## ✅ Build & CI

| Flow | Status |
|------|--------|
| build.yml | Lint → Build → Push → Sign |
| build-disk.yml | Auto after build, or PR/manual |
| qcow2 + anaconda-iso | Both produced |

## ✅ Performance (macOS-like)

| Item | Status |
|------|--------|
| Apps stay in RAM when switching | ✓ (Linux default) |
| zram (memory compression) | ✓ (Fedora default, max 16GB) |
| Power profile: Performance | ✓ (zaatar-power-profile.service) |
| Faster boot (no network wait) | ✓ (NetworkManager-wait-online override) |
| Animations | ✓ (enable-animations=true) |
| Docs: [PERFORMANCE.md](PERFORMANCE.md) | Tuning, zram, power profile |

## ✅ Documentation

| Doc | Purpose |
|-----|---------|
| README.md | Overview, switch, download |
| README.ar.md | Arabic version |
| CONTRIBUTING.md | How to contribute |
| SECURITY.md | Security policy |
| docs/README.md | Documentation index |
| docs/REPORT.md | Full system report (Arabic) |
| docs/CHECKLIST.md | This file – system readiness |
| docs/DOWNLOAD.md | Full download steps |
| docs/EXTENSIONS.md | GNOME extensions |
| docs/LOCALE.md | Change language/region |
| docs/PERFORMANCE.md | zram, power profile, boot speed |
| docs/PROJECT.md | Project structure |
| docs/ROADMAP.md | Development plan |

## One-time setup (before first push)

1. **SIGNING_SECRET** – Add Cosign private key as GitHub secret.
2. **cosign.pub** – Already in repo.
3. **logo.png** – Optional, for Artifact Hub (add to repo root, remove from .gitignore).
