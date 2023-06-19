#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias sudo="sudo "
alias nv="nvim"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias shutdown="shutdown --no-wall"
alias reboot="reboot --no-wall"
alias code="code --ozone-platform-hint=auto" # for wayland

# dotfiles management using git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR="nvim"
export GPG_TTY=$(tty) # for gpg signing git commmits
export PATH=$PATH:$HOME/OneDrive/Documents/Programming/Shell-Scripts
export CM_LAUNCHER=rofi

# organising dotfiles
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export HISTFILE="$XDG_STATE_HOME"/bash/history
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority

# cd using ctrl+o with lf script
LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
bind '"\C-o":"lfcd\C-m"'
bind 'TAB:menu-complete'

# custom bash prompt
eval "$(starship init bash)"
