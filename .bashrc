#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ "$XDG_SESSION_TYPE" = "wayland" ] && cb_copy="wl-copy" || cb_copy="xclip -sel c"

# Aliases
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias shutdown="shutdown --no-wall"
alias reboot="reboot --no-wall"
alias gpath="find -type f | fzf | tr -d '\n' | $cb_copy"
alias hst="history | cut -c 8- | sort | uniq | fzf | tr -d '\n' | $cb_copy"
alias pn="paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias pr="paru -Qq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro sudo paru -Rns"

gc() { git commit -m "$*" ; }
fcd() { cd "$(find -type d | fzf)" ; }
hist() {
	local selected="$(history | cut -c 8- | sort | uniq | fzf | tr -d '\n')"
	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
gbr () { git for-each-ref refs/heads refs/remotes --format='%(refname:short)' | sed 's#origin/##' | sort -u | fzf --height=20% --reverse --info=inline | xargs -r git switch ; }
open() { xdg-open "$(find -type f | fzf)" ; }

# dotfiles management using git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR="nvim"
export GPG_TTY=$(tty) # for gpg signing git commmits

# organising dotfiles
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export HISTFILE="$XDG_STATE_HOME"/bash/history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export PATH="$GOPATH/bin:$NPM_CONFIG_PREFIX/bin:$PATH:$HOME/.local/bin"

# bash history
export HISTCONTROL=erasedups
export HISTSIZE=
export HISTFILESIZE=

# cd using ctrl+o with lf script
LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
[ -f "$LFCD" ] && source "$LFCD"

if [ -t 1 ]; then
	bind '"\C-o":"lfcd\C-m"'
	bind -x '"\C-h":hist'
	bind -x '"\C-b":gbr'
	bind -x '"\C-t":tmux'
	bind -x '"\C-k":pi'
	bind 'TAB:menu-complete'
fi

# custom bash prompt
eval "$(starship init bash)"

__first_prompt_fix() {
  local ec=$?
  if [ -z "${__prompt_shown-}" ]; then
    __prompt_shown=1
    ec=0
  fi
  return $ec
}
PROMPT_COMMAND="__first_prompt_fix; $PROMPT_COMMAND"
