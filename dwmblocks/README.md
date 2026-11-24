My dwmblocks-async status bar config

Built from https://github.com/UtkarshVerma/dwmblocks-async (cloned to `~/dwmblocks`).

- `config.h` — the blocks: CPU, GPU, memory, network, volume and clock (centred by dwm), each a script in
  `scripts/` (`sb-*`, installed to `~/.local/bin`). Every block is clickable through
  dwm's statuscmd patch.
- `unblock-signals.patch` — small fix so programs started from block click actions
  (popups, `top`, `alsamixer`) don't inherit dwmblocks' blocked signals and can be
  closed normally.

Build: `cd ~/dwmblocks && patch -p1 < ~/ArchStuff/dwmblocks/unblock-signals.patch && cp ~/ArchStuff/dwmblocks/config.h . && sudo make install`,
then start `dwmblocks &` from `.xinitrc`.
