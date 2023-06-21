#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ "$XDG_SESSION_TYPE" = "wayland" ] && export MOZ_ENABLE_WAYLAND=1

[[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
