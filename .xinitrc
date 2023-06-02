#!/bin/sh

while true; do
	xsetroot -name "$(date)"
	sleep 1
done &

# For screenlocking with xssstate
xset s 180 &
xsidle.sh slock &

~/.fehbg &
xset r rate 300 50 &
numlockx &
setxkbmap -option caps:swapescape &

# Start compositor and dwm
picom -f &
exec dwm
