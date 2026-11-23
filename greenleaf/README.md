# Greenleaf

A dwm-flavored Arch Linux spin: suckless tools, a clickable status bar, and a Calamares
installer. Green accent `#405c28`.

> **Work in progress.** The packages build and the ISO boots into the live desktop, but the
> installer (Calamares configuration and the archinstall path) isn't finished, so the ISO
> **can't install yet**. Don't use it on a machine you care about.

## What you get

- **dwm** 6.8 with gaps, fibonacci/spiral layouts, a system tray, clickable status text, and
  in-place restart (Alt+Ctrl+Shift+Q keeps every window open)
- **Status bar** (`dwmblocks-greenleaf`): CPU, GPU (NVIDIA), memory, network down/up speed,
  volume, and the clock centred in the bar. Click a block for a usage view; scroll the volume
- **dmenu**: centred launcher over a blurred background, fuzzy and tag search
  ("notes" finds Mousepad), apps first and developer tools on a second row
- **st** with transparency and scrollback
- **Ctrl+Alt+Delete** rescues a frozen dwm session (restarts dwm in place)
- PipeWire, NetworkManager, zram swap, picom, xscreensaver

Design decisions and their reasons: [docs/decisions.md](docs/decisions.md).

## Downloads

[Releases](../../releases) have the ISO and every package (pre-releases while Greenleaf is a
work in progress).

The ISO is bigger than GitHub's 2 GiB limit per file, so it comes in two parts. Join them and
check the result:

```bash
cat greenleaf-*-x86_64.iso.part0 greenleaf-*-x86_64.iso.part1 > greenleaf.iso
sha256sum greenleaf.iso   # compare with the .iso line in SHA256SUMS
```

The packages also work as a pacman repo (unsigned, for now) on an existing Arch install:

```ini
# /etc/pacman.conf
[greenleaf]
SigLevel = Optional TrustAll
Server = https://github.com/DocRountree/Greenleaf/releases/download/2026.11.23
```

## Layout

| Path | What it is |
| --- | --- |
| `packages/` | PKGBUILDs for `dwm-greenleaf`, `st-greenleaf`, `dmenu-greenleaf`, `dwmblocks-greenleaf` and `greenleaf-base`, plus `aur.list` (AUR packages built into the repo) |
| `profile/` | archiso profile overrides (package list, boot menus, live-only files) |
| `wallpapers/` | Curated wallpapers shipped with the distro |
| `tools/` | `build-repo.sh`, `build-iso.sh`, `check-secrets.sh` |

## Build

```bash
sudo pacman -S --needed archiso base-devel git qemu-desktop
tools/build-repo.sh        # as your user: builds the local [greenleaf] repo into build/repo/
sudo tools/build-iso.sh    # builds the ISO into build/out/
run_archiso -u -i build/out/greenleaf-*.iso
```

## License

Greenleaf's own files are public domain ([CC0](LICENSE)). The suckless programs and patches
keep their upstream MIT/X licenses, and each package carries its own license.

Not included: Google Earth Pro (its terms don't allow redistribution; `yay -S google-earth-pro`).
