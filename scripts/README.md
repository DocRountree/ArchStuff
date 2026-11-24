Personalisation scripts

- `dwm-reload` — rebuild dwm from `~/dwm`, install it and restart the running dwm in place (windows stay open). Put it in `~/.local/bin`.
- `sb-cpu`, `sb-gpu`, `sb-memory`, `sb-network`, `sb-volume`, `sb-clock` — dwmblocks status blocks. Clicks:
  CPU, GPU and memory open usage overviews, network (down/up speed) shows addresses and routes, clock shows a 3-month calendar,
  volume toggles mute (left), changes volume (scroll) or opens `alsamixer` (right).
- All blocks print fixed-width numbers, so the bar never shifts as values change.
- `sb-popup` — opens those click popups as a small floating terminal under the bar.
- `sb-cpu-view` — the CPU popup: overall and per-core usage bars, and the busiest programs
  grouped by name as a share of the whole CPU.
- `sb-gpu-view` — the GPU popup (NVIDIA): usage, video memory, temperature/power/fan, and the
  programs using the GPU with their video memory and load.
- `sb-mem-view` — the memory popup: RAM and swap use, cache, and the biggest programs.
- `sb-view-lib` — shared bar/alignment helpers sourced by the three popups.
- `dwm-rescue` + `dwm-rescue.service` — Ctrl+Alt+Delete unfreezes a stuck dwm session. A small
  root service reads the keyboards directly (X's own shortcuts are stuck in the same queue during
  such a freeze), saves a snapshot of dwm/Xorg state to `/var/log/dwm-rescue/`, and restarts dwm
  in place. Install: `sudo install -Dm755 dwm-rescue /usr/local/bin/dwm-rescue`,
  `sudo install -Dm644 dwm-rescue.service /etc/systemd/system/`, `sudo systemctl enable --now dwm-rescue`.
  It watches the VT Xorg runs on (from Xorg's `vtN` argument).
- `backup` — daily snapshot of the home folder to `/mnt/backup/home/YYYY-MM-DD` with rsync:
  each snapshot is a plain, browsable copy; unchanged files are hard links to the previous one.
  Keeps 14 daily, 8 weekly, 12 monthly. Skips caches, Steam games and makepkg build folders.
  Runs from `systemd-user/backup.timer`; see `system/README.md` for the disk setup.
