# Zaatar (زعتر)

**Zaatar** is an Arabic/English desktop OS image based on [Universal Blue](https://universal-blue.org/) Bluefin. It ships with Arabic and English language support, Syrian locale and timezone (Damascus), Noto Arabic fonts, and a macOS-like GNOME theme (Tahoe).

- **Languages:** Arabic (ar_SY) and English (en_US). Both are installed; you can switch from **Settings → Region & Language** (add English or Arabic and choose the display language). Account names in English (Latin letters) are fully supported.
- **Base:** [ghcr.io/ublue-os/bluefin:stable](https://github.com/ublue-os/bluefin) (bootc).
- **Build:** Single-stage Containerfile + `build_files/build.sh`; CI builds and signs the image and can produce disk/ISO images.

## Switch to Zaatar (from a bootc system)

```bash
sudo bootc switch ghcr.io/<your-username>/zaatar:latest
```

Then reboot.

## Switching between Arabic and English

The system is bilingual. To change the interface language:

1. Open **Settings** (الإعدادات).
2. Go to **Region & Language** (المنطقة واللغة).
3. Under **Language** (اللغة), click **Add Language** (إضافة لغة) and add **English (United States)** or **العربية** if not already there.
4. Select the language you want and move it to the top of the list, or choose it as the display language.

Keyboard: you already have **English (US)** and **Arabic**; switch with the keyboard icon in the top bar or with the shortcut (e.g. Super+Space).

## Download disk image (QCOW2) or installer (ISO)

After **Build disk images** runs in Actions, download from **Artifacts**:

- **disk-qcow2** → download as ZIP → inside: **qcow2/disk.qcow2** (for VM).
- **disk-anaconda-iso** → download as ZIP → inside: **bootiso/install.iso** (for installation).

Full steps and paths: [docs/DOWNLOAD.md](docs/DOWNLOAD.md).

## Build and develop

- **Local image build:** `just build` (requires [just](https://just.systems/) and Podman).
- **VM image and run:** `just build-qcow2` then `just run-vm-qcow2`.
- **Project layout and where to change things:** see [docs/PROJECT.md](docs/PROJECT.md).

## Setup (one-time)

1. **Cosign key** – Create a key pair, add the private key as GitHub secret `SIGNING_SECRET`, and keep `cosign.pub` in the repo. See [Universal Blue image template](https://github.com/ublue-os/image-template) for detailed steps.
2. **Base image** – The Containerfile uses `ghcr.io/ublue-os/bluefin:stable`. Change the `FROM` line if you want another base.
3. **Justfile** – The default image name is `Zaatar`; override with `IMAGE_NAME` if needed.

## Community

- [Universal Blue Forums](https://universal-blue.discourse.group/)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
- [bootc discussions](https://github.com/bootc-dev/bootc/discussions)

## License

Same as the Universal Blue image template (see [LICENSE](LICENSE)).
