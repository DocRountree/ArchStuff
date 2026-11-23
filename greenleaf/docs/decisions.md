# Greenleaf design decisions

The source of truth for what Greenleaf is. Update this file when a decision changes.

## Identity

| Item | Value |
| --- | --- |
| Name | Greenleaf |
| os-release ID | `greenleaf` (`ID_LIKE=arch`) |
| Tagline | A dwm-flavored Arch spin |
| Accent color | `#405c28` |
| Versioning | Date-based rolling, `YYYY.MM.DD` |
| ISO label | `GREENLEAF_YYYYMM` |
| Installer slideshow | Simple text slides about the distro |

## Architecture rule

Anything that must exist on an **installed** system ships inside a Greenleaf package
(`greenleaf-base`, `dwm-greenleaf`, `st-greenleaf`, `dmenu-greenleaf`,
`dwmblocks-greenleaf`). The archiso
`airootfs/` holds **live-only** files (live user, SDDM autologin, installer launcher).

The reason: there are two install modes (copy the live image, or download fresh packages).
Only packages reach a fresh install, so only packages may carry the real configuration.

## Live session

| Item | Decision |
| --- | --- |
| Login | SDDM, autologin as user `live` into the dwm session |
| Installer launch | Autostart on login, dmenu entry, `Alt+Shift+I`, hint in the status bar |
| Screensaver | Not started in the live session |

## Installed system

| Item | Decision |
| --- | --- |
| Login | TTY login, then `startx` (no display manager); SDDM removed after install |
| Session | `~/.xinitrc` runs `greenleaf-session`, which sets up the desktop and execs dwm |
| dwm modifier | Alt (unchanged) |
| Kept personal touches | st transparency 0.8, picom, xscreensaver |
| Status bar | `dwmblocks-greenleaf`: CPU, GPU (NVIDIA only), memory, network down/up speed, volume, and the date and time centred in the bar. Every block is clickable (usage views, mute/scroll volume, addresses, calendar); numbers are fixed-width so the bar never shifts |
| Terminal | st with scrollback (2000 lines; mouse wheel or Shift+PageUp/PageDown, the wheel still reaches less/vim) |
| Frozen-session rescue | `dwm-rescue` service (in `greenleaf-base`, enabled by preset): Ctrl+Alt+Delete restarts dwm in place, windows stay open; a snapshot goes to `/var/log/dwm-rescue/` |
| System tray | dwm systray patch, right side of the bar, follows the selected monitor |
| Dropped | Wallpaper slideshow over `~/Pictures`; sxhkd autostart (package stays installed) |
| Display | Auto-detect (`xrandr --auto`) plus `arandr` for manual layouts |
| Wallpapers | A curated folder supplied by the user → `greenleaf/wallpapers/`; falls back to solid accent color |
| Audio | PipeWire (`pipewire-pulse`, `pipewire-alsa`, `wireplumber`) replaces PulseAudio |
| Network | NetworkManager with `nm-applet` |

## Installer (Calamares)

Screens: Welcome → Location → Keyboard → Partitions → Users → Software → Summary → Install → Finish

| Item | Decision |
| --- | --- |
| Install method | User chooses offline (copy live image) or online (fresh packages) |
| Filesystem | ext4 |
| Swap | zram (`zram-generator`) |
| Bootloader | GRUB |
| GPU drivers | Auto-detect the GPU; if NVIDIA, the user chooses open (nouveau/Mesa) or NVIDIA (`nvidia-open`) |
| Microcode | Auto-pick `intel-ucode` / `amd-ucode` |
| Partitioning | Erase disk, install alongside, manual — all offered |
| Encryption | LUKS offered |
| Dual boot | os-prober enabled |
| User groups | `wheel,audio,video,input,storage` |
| Autologin checkbox | Hidden |
| Root password | Same as user password |
| Mirrors | Ranked with `reflector` before online installs |

### How the install-method choice works

Calamares can't change its install steps partway through a run. So `greenleaf-installer`
shows a small dialog first ("Offline" / "Online") and then starts Calamares with the
matching config directory (`/etc/calamares/offline` or `/etc/calamares/online`). Both use the
same screens and branding. Only the install job sequence differs.

### How the GPU choice works

- ISO boot menu: "Greenleaf (open drivers)" and "Greenleaf (NVIDIA drivers)", so the live
  session itself works on either.
- Calamares: the Software screen includes a "Graphics driver" chooser. A post-install job
  checks `lspci` and only installs `nvidia-open` + `nvidia-utils` when an NVIDIA GPU is
  present and the user picked it.

## Software

The package list is `profile/packages.x86_64`, generated from the package picker (74 of 161
explicit packages, plus distro plumbing). Changes from the picker:

- `pulseaudio` → PipeWire stack
- added: `networkmanager`, `network-manager-applet`, `arandr`, `amd-ucode`, `reflector`,
  installer and live-boot tooling
- `nvidia-open`/`nvidia-utils` stay on the ISO but install only by choice (see above)

AUR packages, built into the local `[greenleaf]` repo: see `packages/aur.list`.

## Notes and open items

- **st:** `st-greenleaf` and `~/st` both build upstream st (688f70a) with the official alpha
  and scrollback patches (`st/` in this repo has the patches, `config.h` and the resulting `st.c`).
- **System tray:** dwm-greenleaf includes the official systray patch (`dwm-systray-6.8.diff`,
  three hunks adapted by hand to sit on top of the fibonacci and gaps patches), so `nm-applet`
  shows in the bar. Settings are the `systray*` lines in `packages/dwm-greenleaf/config.h`.
- **google-earth-pro:** not shipped. Google's terms don't allow redistributing it, and the
  ISO and package repo are public, so users install it from the AUR (`yay -S google-earth-pro`).
