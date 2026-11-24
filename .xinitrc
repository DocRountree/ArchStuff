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
systemctl --user restart redshift.service   # evening colours (~/.config/redshift/redshift.conf; edits apply on save)
gnome-keyring &
gnome-keyring-daemon &
(sleep 5; signal-desktop --start-in-tray) &   # after dwm, so its system tray exists

# Run dwm
exec dwm

