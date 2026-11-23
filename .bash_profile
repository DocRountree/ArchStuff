#
# ~/.bash_profile: runs once, at login on the console.
#

# Environment first, so X, dwm, dwmblocks and everything started from them
# (and scripts, which never read .bashrc) get the same PATH.
export PATH="$HOME/.npm-global/bin:$PATH:$HOME/.local/bin"   # ~/.local/bin: pipx, sb-* scripts
. "$HOME/.config/vite-plus/env"                              # Vite+ (https://viteplus.dev)

# Interactive settings
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start X on login (local console only)
if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && $(tty) == /dev/tty1 ]]; then
  exec startx
fi
