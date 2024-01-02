#!/bin/sh

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch main bar
screens=$(xrandr --query | grep " connected" | cut -d" " -f1)
primary=$(xrandr --query | grep primary | cut -d" " -f1)

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
if [ "$(echo "$screens" | wc -l)" -eq 1 ]; then
    MONITOR=$primary polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
else
    xrandr --output HDMI-1-1 --auto --right-of eDP-1
    xrandr --output HDMI-1-1 --primary
    primary=$(xrandr --query | grep primary | cut -d" " -f1)
    for m in $screens; do
        if [ $m = $primary ]; then
            MONITOR=$m polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
        else
            MONITOR=$m polybar secondary 2>&1 | tee -a /tmp/polybar2.log & disown
        fi
    done
fi

echo "Bars launched..."
feh --no-fehbg --bg-scale "$XDG_CONFIG_HOME"/wallpaper.jpg &
