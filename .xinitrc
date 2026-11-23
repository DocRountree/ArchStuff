# Set dimensions and refresh rate
xrandr --output HDMI-0 --mode 3440x1440 --rate 100.00

# Fix xdg-desktop-portal-gtk "cannot open display" error
if [ -n "$DISPLAY" ]; then
    systemctl --user import-environment DISPLAY XAUTHORITY
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
fi

# Run dwm bar scripts
dwmblocks &   # status bar (blocks: ~/.local/bin/sb-*, config: ~/dwmblocks/config.h)

# Set background image
~/.slideshow.sh &

# Run programs
sxhkd &
xscreensaver &
picom &
gnome-keyring &
gnome-keyring-daemon &

# Run dwm
exec dwm

