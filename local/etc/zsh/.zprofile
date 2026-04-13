set -a

DOTS=$HOME/local
PATH=$PATH:`find "$DOTS/bin" -type d -print | paste -sd ':' -`
EDITOR=nvim
TERMINAL=st
TERMINAL_PROG=st
BROWSER=firefox

: XDG
XDG_CONFIG_HOME=$DOTS/etc
XDG_DATA_HOME=$DOTS/share
XDG_CACHE_HOME=$DOTS/var/cache
XDG_STATE_HOME=$DOTS/var/state

test -f "$XDG_CONFIG_HOME/user-dirs.dirs" && . "$XDG_CONFIG_HOME/user-dirs.dirs"

: Clean-up:
XINITRC=$XDG_CONFIG_HOME/x11/xinitrc
XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority # This line will break some DMs.
NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch-config
GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0
WGETRC=$XDG_CONFIG_HOME/wget/wgetrc
INPUTRC=$XDG_CONFIG_HOME/shell/inputrc
ZDOTDIR=$XDG_CONFIG_HOME/zsh
GNUPGHOME=$XDG_DATA_HOME/gnupg
WINEPREFIX=$XDG_DATA_HOME/wineprefixes/default
KODI_DATA=$XDG_DATA_HOME/kodi
WL=${XDG_VIDEOS_DIR:-$HOME/videos}/Watchlist
PIX=$XDG_DATA_HOME/icons
NOTES_DIR=$XDG_DATA_HOME/notes
NOTES_FILE=$XDG_DATA_HOME/capture
PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
TMUX_TMPDIR=$XDG_RUNTIME_DIR
ANDROID_SDK_HOME=$XDG_CONFIG_HOME/android
CARGO_HOME=$XDG_DATA_HOME/cargo
GOPATH=$XDG_DATA_HOME/go
GOMODCACHE=$XDG_CACHE_HOME/go/mod
ANSIBLE_CONFIG=$XDG_CONFIG_HOME/ansible/ansible.cfg
UNISON=$XDG_DATA_HOME/unison
HISTFILE=$XDG_DATA_HOME/history
MBSYNCRC=$XDG_CONFIG_HOME/mbsync/config
ELECTRUMDIR=$XDG_DATA_HOME/electrum
PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
_JAVA_OPTIONS=-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java

: Other program settings:
TS_SLOTS=3
DICS=/usr/share/stardict/dic/
SUDO_ASKPASS=$DOTS/bin/dmenupass
FZF_DEFAULT_OPTS='--layout=reverse --height 40%'
QT_QPA_PLATFORMTHEME=gtk2		# Have QT use gtk2 theme.
MOZ_USE_XINPUT2=1			# Mozilla smooth scrolling/touchpads.
AWT_TOOLKIT='MToolkit wmname LG3D'	# May have to install wmname
_JAVA_AWT_WM_NONREPARENTING=1		# Fix for Java applications in dwm

shortcuts >/dev/null 2>&1

: Hardware acceleration
MOZ_X11_EGL=1
MOZ_DISABLE_RDD_SANDBOX=1

: Start Xorg after login
test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1 && exec startx "$XINITRC" >/dev/null 2>&1
