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
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh
#source liquidprompt

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

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
