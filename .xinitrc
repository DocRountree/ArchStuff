# Set dimensions and refresh rate
xrandr --output HDMI-0 --mode 3440x1440 --rate 100.00

# Run dwm bar scripts
~/.clock.sh &

# Set background image
~/.slideshow.sh &

# Run programs
sxhkd &
xscreensaver &
picom &

# Run dwm
exec dwm
