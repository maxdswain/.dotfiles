#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias sudo="sudo "
alias nv="nvim"
alias ls="ls --color=auto"
alias shutdown="shutdown --no-wall"
alias reboot="reboot --no-wall"

# custom bash prompt
source liquidprompt

# change to cd using lf ctrl+o script
LFCD="/home/max/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
bind '"\C-o":"lfcd\C-m"'

bind 'TAB:menu-complete'

# dotfiles management using git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR="nvim"
export GPG_TTY=$(tty) # for gpg signing git commmits
export PATH=$PATH:$HOME/OneDrive/Documents/Programming/Shell-Scripts

