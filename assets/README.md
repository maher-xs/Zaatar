# Zaatar Assets

Custom wallpapers and branding assets.

## Wallpapers

Place custom wallpapers in `wallpapers/`:

| File | Purpose |
|------|---------|
| `zaatar-wallpaper.png` | Primary wallpaper (macOS Big Sur–style, 4096×2304). Used by default. |
| `zaatar-wallpaper-ultrawide.png` | Ultrawide variant (6400×2880). Available in Settings → Appearance. |
| `zaatar-wallpaper.svg` | Fallback SVG (gradient + "Zaatar" text) if no PNG exists. |

The build uses PNG first, then SVG. Both PNG files are installed; user can switch in Settings.
