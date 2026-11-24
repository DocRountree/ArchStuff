System files (outside the home folder)

| File | Installed as | What it does |
| --- | --- | --- |
| `nftables.conf` | `/etc/nftables.conf` | Firewall: blocks incoming connections except replies, ping and Transmission's peer port (51413). `systemctl enable --now nftables` |
| `earlyoom` | `/etc/default/earlyoom` | earlyoom settings: when RAM and swap are nearly full, kill the biggest process (compilers first), never Xorg/dwm/audio. `systemctl enable --now earlyoom` |
| `blacklist-ucsi_ccg.conf` | `/etc/modprobe.d/` | Stops the RTX card's unused USB-C controller driver logging i2c errors at boot |
| `makepkg-local.conf` | `/etc/makepkg.conf.d/local.conf` | makepkg builds with every core and makes no `-debug` packages |
| `fstab-sda.txt` | appended to `/etc/fstab` | Mounts the 1 TB disk: old Windows NTFS partition at `/mnt/windows`, backup partition at `/mnt/backup` |
| (one line) | `/etc/default/grub` | `GRUB_TIMEOUT=1` instead of 5: the menu still shows for a second. Apply with `grub-mkconfig -o /boot/grub/grub.cfg` |
| (package) | `pacman-contrib` | `systemctl enable --now paccache.timer`: weekly, keeps the last 3 versions of each package in the pacman cache |

Backups: `scripts/backup` + `systemd-user/backup.{service,timer}` (in `~/.config/systemd/user/`,
`systemctl --user enable --now backup.timer`) snapshot the home folder daily to
`/mnt/backup/home/YYYY-MM-DD`.
