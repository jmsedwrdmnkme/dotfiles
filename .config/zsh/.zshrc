# Enable colors and change prompt:
PS1="%B%F{red}[%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~%F{red}]%f%b$ " # Set prompt
stty stop undef # Disable ctrl-s to freeze terminal.
setopt interactive_comments
unsetopt PROMPT_SP # Removes the % special character from the end of files

# History in state directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
setopt inc_append_history

# Aliases
alias \
  ls="ls -hN --color=auto --group-directories-first" \
  lf="lf-ueberzug" \
  grep="grep --color=auto" \
  dotfiles="git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME" \
  wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"

# nvm: put the newest installed node on $PATH now, load nvm itself on first use
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
typeset -U path
nvm_node=($NVM_DIR/versions/node/*/bin(Nn[-1]))
path=($nvm_node $path)
unset nvm_node
nvm() {
  unset -f nvm
  \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
# Only rebuild the completion dump (and run its security check) once a day
zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
[[ -d ${zcompdump:h} ]] || mkdir -p ${zcompdump:h}
stale_dump=($zcompdump(N.mh+24))
if [[ ! -e $zcompdump ]] || (( $#stale_dump )); then
  compinit -d $zcompdump
else
  compinit -C -d $zcompdump
fi
unset zcompdump stale_dump
_comp_options+=(globdots) # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
  tmp="$(mktemp -uq)"
  # EXIT trap is function-local in zsh; trapping HUP here would stop the
  # shell (and lf/ueberzug) from exiting when the terminal is closed
  trap 'rm -f $tmp >/dev/null 2>&1' EXIT
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}
bindkey -s '^o' '^ulfcd\n'

# gpg-agent holds the ssh key; pinentry prompts on this terminal
export GPG_TTY=$TTY
ssh-preset

# Nuke unneeded dbus session folder
[ -d ~/.dbus ] && rm -rf ~/.dbus
