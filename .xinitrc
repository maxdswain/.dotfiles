#!/bin/sh

# For screenlocking with xssstate
xsidle.sh slock &

~/.fehbg &
xset r rate 300 50 &
clipmenud &
numlockx &
setxkbmap -option caps:swapescape &

# Start compositor and dwm
picom -f &
exec dwm
