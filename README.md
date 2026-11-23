# ArchStuff
Configuration files and scripts for my personalised Arch Linux experience

I doubt these files will be of any use to anybody except me, but I'm making them public anyway.

Files for suckless utilities fall under the respective licenses for those utilities; the rest of the repo is in the public domain per the Creative Commons Zero license.

## Greenleaf

`greenleaf/` turns this setup into **Greenleaf**, a dwm-flavored Arch spin with a Calamares
installer. Design decisions live in [greenleaf/docs/decisions.md](greenleaf/docs/decisions.md).

| Path | What it is |
| --- | --- |
| `greenleaf/packages/` | PKGBUILDs for dwm, st, dmenu and `greenleaf-base`, plus `aur.list` |
| `greenleaf/profile/` | archiso profile overrides (packages, boot menus, live-only files) |
| `greenleaf/wallpapers/` | Curated wallpapers shipped with the distro |
| `greenleaf/tools/` | `build-repo.sh`, `build-iso.sh`, `check-secrets.sh` |

Build:

```bash
sudo pacman -S --needed archiso base-devel git qemu-desktop
greenleaf/tools/build-repo.sh        # as your user: builds the local [greenleaf] repo
sudo greenleaf/tools/build-iso.sh    # builds the ISO into greenleaf/build/out/
run_archiso -u -i greenleaf/build/out/greenleaf-*.iso
```
