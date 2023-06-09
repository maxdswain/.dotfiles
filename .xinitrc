#!/bin/sh

# For screenlocking with xssstate
xsidle.sh slock &

feh --no-fehbg --bg-scale "$XDG_CONFIG_HOME"/wallpaper.jpg &
xset r rate 300 50 &
clipmenud &
numlockx &
setxkbmap -option caps:swapescape &

# Start compositor and dwm
picom -f &
exec dwm
