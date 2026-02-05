#!/bin/sh
# shellcheck disable=SC2155

# Profile file, runs on login. Environmental variables are set here.

# Add all directories in `~/local/bin` to $PATH
export PATH="$PATH:$(find ~/local/bin -type d | paste -sd ':' -)"

unsetopt PROMPT_SP 2>/dev/null

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export TERMINAL_PROG="st"
export BROWSER="firefox"

# Change the default crypto/weather monitor sites.
# export CRYPTOURL="rate.sx"
# export WTTRURL="wttr.in"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/local/etc"
export XDG_DATA_HOME="$HOME/local/share"
export XDG_CACHE_HOME="$HOME/local/var/cache"
export XDG_STATE_HOME="$HOME/local/var/state"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export KODI_DATA="$XDG_DATA_HOME/kodi"
export PIX="$XDG_DATA_HOME/icons"
export NOTES_DIR="$XDG_DATA_HOME/notes"
export NOTES_FILE="$XDG_DATA_HOME/capture"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export UNISON="$XDG_DATA_HOME/unison"
export HISTFILE="$XDG_DATA_HOME/history"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# Other program settings:
#export OPENSSL_CONF=/dev/null
export TS_SLOTS="3"
export DICS="/usr/share/stardict/dic/"
export SUDO_ASKPASS="$HOME/local/bin/dmenupass"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export QT_QPA_PLATFORMTHEME="gtk2"        # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2=1                  # Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D" # May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1      # Fix for Java applications in dwm

[ ! -f "$XDG_CONFIG_HOME/shell/shortcutrc" ] && setsid -f shortcuts >/dev/null 2>&1

# Hardware acceleration
export MOZ_X11_EGL=1
export MOZ_DISABLE_RDD_SANDBOX=1

# Start Xorg after login
[ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && exec startx "$XINITRC" >/dev/null 2>&1
