#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias sudo='sudo '
alias nv="nvim"
alias ls='ls --color=auto'

# custom bash prompt
source liquidprompt

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
bind 'TAB:menu-complete'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# change to cd using lf ctrl+o script
LFCD="/home/max/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
bind '"\C-o":"lfcd\C-m"'

[ -f "/home/max/.ghcup/env" ] && source "/home/max/.ghcup/env" # ghcup-env

[ -e "/home/max/.bashrc.casino" ] && source "/home/max/.bashrc.casino"

# dotfiles management using git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDTIOR="nvim"
export GPG_TTY=$(tty) # for gpg signing git commmits

# organise dotfiles
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export KDEHOME="$XDG_CONFIG_HOME"/kde
