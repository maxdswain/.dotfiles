#
# ~/.bashrc
#

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

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# dotfiles management using git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# for gpg signing git commits
export GPG_TTY=$(tty)

alias nv="nvim"
