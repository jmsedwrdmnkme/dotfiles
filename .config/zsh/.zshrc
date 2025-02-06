# Enable colors and change prompt:
autoload -U colors && colors # Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b " # Set prompt
stty stop undef # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt inc_append_history

# Aliases
alias \
  ls="ls -hN --color=auto --group-directories-first" \
  grep="grep --color=auto" \
  lf="lf-ueberzug" \
  dotfiles="git --git-dir=$XDG_DATA_HOME/dotfiles/ --work-tree=$HOME" \
  wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts" \
  yarn="HOME=$XDG_DATA_HOME/yarn $XDG_DATA_HOME/pnpm/yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config" \
  ollama="HOME=$XDG_DATA_HOME/ollama ollama" \
  firefox="HOME=$XDG_DATA_HOME/firefox firefox --profile $HOME/.config/firefox/"

# This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

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
  trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}
bindkey -s '^o' '^ulfcd\n'

# Ensure ssh-agent has ssh keyfile for session
ssh-start > /dev/null
if { [ -n "$TMUX" ]; } then
  eval $(tmux show-env -s | grep "^SSH_")
fi

# Nuke unneeded dbus session folder
[ -d ~/.dbus ] && rm -rf ~/.dbus
