#!/bin/sh

# Required for xdg-desktop-portal-gtk to work
systemctl --user import-environment DISPLAY XAUTHORITY XDG_SESSION_TYPE

# For screenlocking with xssstate
xsidle.sh slock &

xset r rate 300 50 &
clipmenud &
numlockx &
setxkbmap -option caps:swapescape &

# Start compositor and dwm
picom -f &
exec dwm
