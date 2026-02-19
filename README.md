# Zaatar (زعتر)

**Zaatar** is an Arabic/English desktop OS image based on [Universal Blue Silverblue](https://github.com/ublue-os/main). The system is branded as **Zaatar** (in Latin script) everywhere: installer, first boot, login screen, and OS name. It ships with Arabic and English language support, Syrian locale and timezone (Damascus), Noto Arabic fonts, WhiteSur theme (macOS-like GTK + GNOME Shell), WhiteSur icons and cursors, custom Zaatar wallpaper, Search Light (Spotlight-like, Super+Space), Dash2Dock Animated, and Quick Look (Sushi).

- **Languages:** Arabic (ar_SY) and English (en_US). Both are installed; you can switch from **Settings → Region & Language** (add English or Arabic and choose the display language). Account names in English (Latin letters) are fully supported.
- **Base:** [ghcr.io/ublue-os/silverblue:stable](https://github.com/ublue-os/main) (bootc).
- **Build:** Single-stage Containerfile + `build_files/build.sh`; CI builds and signs the image and can produce disk/ISO images.

## Switch to Zaatar (from a bootc system)

```bash
sudo bootc switch ghcr.io/maher-xs/zaatar:latest
```

Then reboot. (If you use a fork, replace `maher-xs` with your GitHub username.)

## Switching between Arabic and English

The system is bilingual. To change the interface language:

1. Open **Settings** (الإعدادات).
2. Go to **Region & Language** (المنطقة واللغة).
3. Under **Language** (اللغة), click **Add Language** (إضافة لغة) and add **English (United States)** or **العربية** if not already there.
4. Select the language you want and move it to the top of the list, or choose it as the display language.

Keyboard: you already have **English (US)** and **Arabic**; switch with the keyboard icon in the top bar or with the shortcut (e.g. Super+Space). **Search Light** uses Super+Space for Spotlight-like search; if you need a different shortcut for input switching, change it in Settings → Keyboard.

## Download disk image (QCOW2) or installer (ISO)

After **Build disk images** runs in Actions, download from **Artifacts**:

- **disk-qcow2** → download as ZIP → inside: **qcow2/disk.qcow2** (ready-to-boot VM, **no installation**).
- **disk-anaconda-iso** → download as ZIP → inside: **bootiso/install.iso** (full Anaconda installer).

**For fast testing:** use **disk-qcow2** – it boots directly into Zaatar. No installer step.

```bash
unzip disk-qcow2.zip
./scripts/run-qcow2.sh qcow2/disk.qcow2   # or: ./scripts/run-qcow2.sh disk-qcow2.zip
```

Full steps and paths: [docs/DOWNLOAD.md](docs/DOWNLOAD.md).

## Build and develop

- **Local image build:** `just build` (requires [just](https://just.systems/) and Podman).
- **Without just:** `./scripts/build.sh` or `podman build -t zaatar:latest .` (requires [Podman](https://podman.io/)).
- **VM image and run:** `just build-qcow2` then `just run-vm-qcow2`.
- **Project layout:** see [docs/PROJECT.md](docs/PROJECT.md) for structure and where to change things.

## Setup (one-time)

1. **Cosign key** – Create a key pair, add the private key as GitHub secret `SIGNING_SECRET`, and keep `cosign.pub` in the repo. See [Universal Blue image template](https://github.com/ublue-os/image-template) for detailed steps.
2. **Base image** – The Containerfile uses `ghcr.io/ublue-os/silverblue:stable`. Change the `FROM` line if you want another base.
3. **Justfile** – The default image name is `zaatar` (lowercase for OCI); override with `IMAGE_NAME` if needed.
4. **macOS:** Install Podman: `brew install podman`; install just: `brew install just`. For `just build-qcow2`, you need rootful Podman and the rootful connection as default: `podman machine set --rootful` then `podman machine stop; podman machine start`, then `podman system connection default podman-machine-default-root` (or the rootful connection name from `podman system connection list`).

## Documentation

- [docs/](docs/README.md) – Full documentation index
- [System checklist](docs/CHECKLIST.md) – everything included, ready to use
- [Arabic README](README.ar.md)
- [Change language/region](docs/LOCALE.md)
- [GNOME extensions](docs/EXTENSIONS.md) – Dash to Dock, Blur my Shell, etc.
- [Performance & app behavior](docs/PERFORMANCE.md) – zram, power profile, boot speed

## Community

- [Universal Blue Forums](https://universal-blue.discourse.group/)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
- [bootc discussions](https://github.com/bootc-dev/bootc/discussions)

## License

Same as the Universal Blue image template (see [LICENSE](LICENSE)).
