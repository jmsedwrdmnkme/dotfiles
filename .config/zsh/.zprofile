# Sourced by zsh login shells (~/.zprofile -> ~/.config/zsh/.zprofile)

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"

# Add ~/.local/bin and all its subdirectories to $PATH as well as pnpm (deduplicated)
typeset -U path
path=(~/.local/bin{,/**/*(N/)} "$PNPM_HOME/bin" $path)

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"

# GNUPG
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Shopify
export SHOPIFY_CLI_NO_ANALYTICS=1
export OPT_OUT_INSTRUMENTATION=true

# FCITX input
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export LC_CTYPE=en_GB.UTF-8

# Start graphical server on tty1 if not already running.
[[ $TTY == /dev/tty1 ]] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC"
