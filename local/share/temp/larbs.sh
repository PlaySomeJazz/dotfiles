#!/bin/sh
# Forked from Luke Smith's LARBS under the GNU GPLv3

trap 'stty echo; rm -f /etc/sudoers.d/temp-nopasswd; exit' 0 1 2 3 15

dotfilesrepo=https://github.com/PlaySomeJazz/dotfiles

### USERNAME AND PASSWORD ###

echo "Username for the new account:"
read -r name
while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
	echo "Invalid username, use lowercase letters/digits/-/_, starting with a letter or _:"
	read -r name
done

stty -echo
while :; do
	echo "Password for $name:"
	read -r pass1; echo
	echo "Retype password:"
	read -r pass2; echo
	if [ -z "$pass1" -o "$pass1" != "$pass2" ]; then
		echo "Passwords must match and can't be empty, try again."
	else
		break
	fi
done
stty echo

### EVERYTHING BELOW IS UNATTENDED ###

echo "Refreshing Arch keyring..."
pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1

for x in curl ca-certificates base-devel git ntp zsh dash; do
	echo "Installing \`$x\`..."
	pacman --noconfirm --needed -S "$x" >/dev/null 2>&1
done

echo "Synchronizing system clock..."
ntpd -q -g >/dev/null 2>&1

echo "Adding user $name..."
useradd -D -b /usr
home=/usr/$name
if ! useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1; then
	usermod -a -G wheel "$name"
	mkdir -p "$home"
	chown "$name":wheel "$home"
fi
DOTS=$home/local
repodir=$DOTS/src
config=$DOTS/etc
mkdir -p "$repodir"
chown -R "$name":wheel "$DOTS"
echo "$name:$pass1" | chpasswd
unset pass1 pass2

test -f /etc/sudoers.pacnew && cp /etc/sudoers.pacnew /etc/sudoers

# Passwordless sudo for the rest of the install (AUR builds need this).
echo "%wheel ALL=(ALL) NOPASSWD: ALL
Defaults:%wheel,root runcwd=*" >/etc/sudoers.d/temp-nopasswd

grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf
sed -i "s/-j2/-j`nproc`/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

# yay and the -git xorg packages aren't in the repos/AUR-helper yet, build by hand.
for pkg in yay xorg-server-git xf86-input-libinput-git; do
	pacman -Qq "$pkg" >/dev/null 2>&1 && continue
	echo "Building $pkg from the AUR..."
	sudo -u "$name" mkdir -p "$repodir/$pkg"
	sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch --no-tags -q \
		"https://aur.archlinux.org/$pkg.git" "$repodir/$pkg" 2>/dev/null ||
		sudo -u "$name" git -C "$repodir/$pkg" pull --force origin master
	(cd "$repodir/$pkg" && sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1)
done
if ! pacman -Qq yay >/dev/null 2>&1; then
	echo "Failed to install yay." 1>&2
	exit 1
fi

sudo -u "$name" yay -Y --save --devel >/dev/null 2>&1

### INSTALL PROGRAMS ###

echo "Installing pacman packages..."
pacman -S --needed --noconfirm - <<\PACMAN_PKGS >/dev/null 2>&1
arandr
aria2
bc
bluetui
bluez
bluez-utils
brightnessctl
deno
dma
dosfstools
dunst
ed
emby-server
exfat-utils
ffmpeg
ffmpegthumbnailer
firefox
fzf
gnome-keyring
gnome-themes-extra
hdparm
intel-compute-runtime
intel-media-driver
intel-ucode
keyd
lf
libnotify
libva-intel-driver
maim
man-db
mesa
mpc
mpd
mpv
ncmpcpp
neovim
newsboat
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
nsxiv
ntfs-3g
ocl-icd
otf-libertinus
pacman-contrib
pipewire-pulse
poppler
pulsemixer
python-qdarkstyle
s-nail
tesseract
tesseract-data-eng
transmission-cli
ttf-dejavu
ttf-nerd-fonts-symbols
ueberzugpp
unclutter
unrar
unzip
vulkan-intel
wireplumber
woff2-font-awesome
xclip
xdotool
xorg-xinit
xorg-xset
xorg-xsetroot
xwallpaper
yt-dlp
zathura
zathura-pdf-mupdf
zip
PACMAN_PKGS

echo "Installing yay packages..."
sudo -u "$name" yay -S --needed --noconfirm >/dev/null 2>&1 \
	gallery-dl htop-vim simple-mtpfs \
	task-spooler zsh-fast-syntax-highlighting-git

: '
echo "Installing pipx packages..."
while read -r program; do
	sudo -u "$name" pipx install "$program" >/dev/null 2>&1
done <<\PIPX_PKGS
gallery-dl
PIPX_PKGS
'

echo "Installing git packages..."
while read -r repo; do
	progname=${repo##*/}
	progname=${progname%.git}
	dir=$repodir/$progname
	sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch --no-tags -q "$repo" "$dir" 2>/dev/null ||
		sudo -u "$name" git -C "$dir" pull --force origin master
	(cd "$dir" && make >/dev/null 2>&1 && make install >/dev/null 2>&1)
done <<\GIT_PKGS
https://github.com/PlaySomeJazz/dmenu.git
https://github.com/PlaySomeJazz/dwm.git
https://github.com/PlaySomeJazz/st.git
GIT_PKGS

### DOTFILES ###

echo "Installing dotfiles..."
dir=`mktemp -d`
chown "$name":wheel "$dir"
sudo -u "$name" git clone --depth 1 --single-branch --no-tags -q --recursive \
	-b master --recurse-submodules "$dotfilesrepo" "$dir"
sudo -u "$name" cp -rfT "$dir" "$home"
rm -rf "$home/.git" "$home/README.md" "$home/LICENSE" "$home/FUNDING.yml"

if [ ! -f "$config/nvim/autoload/plug.vim" ]; then
	echo "Installing neovim plugins..."
	mkdir -p "$config/nvim/autoload"
	curl -Ls "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" >"$config/nvim/autoload/plug.vim"
	chown -R "$name:wheel" "$config/nvim"
	sudo -u "$name" nvim -c "PlugInstall|q|q"
fi

### SYSTEM TWEAKS ###

echo "kernel.core_pattern=|/bin/false" >/etc/sysctl.d/50-coredump.conf

echo 'ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sda", RUN+="/usr/bin/hdparm -B 254 -S 0 /dev/sda"' >/etc/udev/rules.d/69-hdparm.rules

sed -i 's/^#Storage=auto$/Storage=none/' /etc/systemd/journald.conf

sed -i '/export FREETYPE_PROPERTIES="truetype:interpreter-version=40"/s/^#//' /etc/profile.d/freetype2.sh

test ! -f /etc/X11/xorg.conf.d/40-libinput.conf && echo 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
EndSection' >/etc/X11/xorg.conf.d/40-libinput.conf

echo "e  $DOTS/var/cache/lf/ - - - 7d
e  $DOTS/var/cache/ueberzugpp/ - - - 7d" >/etc/tmpfiles.d/cleanup-previews.conf

chsh -s /bin/zsh "$name" >/dev/null 2>&1
sudo -u "$name" mkdir -p "$DOTS/var/cache/zsh/"
sudo -u "$name" mkdir -p "$config/mpd/playlists/"

ln -sfT dash /usr/bin/sh >/dev/null 2>&1

# Place some config files
mkdir -p /etc/firefox/policies /etc/pacman.d/hooks /usr/local/lib
mv "$DOTS/share/temp/cleanup-packages" /usr/local/lib/cleanup-packages
chown root:root /usr/local/lib/cleanup-packages
chmod 755 /usr/local/lib/cleanup-packages
mv "$DOTS/bin/tordone" /usr/local/bin/tordone
chown "$name":wheel /usr/local/bin/tordone
mv "$DOTS/share/temp/keyd_config" /etc/keyd/default.conf
mv "$DOTS/share/temp/60-ioschedulers.rules" /etc/udev/rules.d/60-ioschedulers.rules
mv "$DOTS/share/temp/policies.json" /etc/firefox/policies/policies.json
mv "$DOTS/share/temp/package_cleanup.hook" /etc/pacman.d/hooks/package_cleanup.hook
mv "$DOTS/share/temp/relink_dash.hook" /etc/pacman.d/hooks/relink_dash.hook
mv "$DOTS/share/temp/95-systemd-boot.hook" /etc/pacman.d/hooks/95-systemd-boot.hook
mv "$DOTS/share/temp/99-sysctl.conf" /etc/sysctl.d/99-sysctl.conf
mv "$DOTS/share/temp/blacklist.conf" /etc/modprobe.d/blacklist.conf
mv "$DOTS/share/temp/jsh" /bin/jsh
rm -rf "$DOTS/share/temp"
systemctl enable keyd

# Configure Emby
media=/srv/media
mkdir -p "$media/movies" "$media/tv" "$media/torrents"
mkdir -p /etc/systemd/system/emby-server.service.d
groupadd media 2>/dev/null
usermod -aG media "$name"
chgrp -R media "$media"
find "$media" -type f -exec chmod 664 {} +
find "$media" -type d -exec chmod 775 {} +
find "$media" -type d -exec chmod g+s {} +
echo "[Service]
SupplementaryGroups=media
ReadWritePaths=$media
UMask=0002" >/etc/systemd/system/emby-server.service.d/write-permissions.conf

# Fix yt-dlp throttling
cd "$config/mpv/scripts/ytrangefix" || exit 1
sudo -u "$name" openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -passout pass:"third-wheel" -subj "/C=US/ST=private/L=province/O=city/CN=hostname.example.com" >/dev/null 2>&1
cd /tmp || exit 1

### FIREFOX ###

echo "Setting up Firefox..."
browserdir=$config/mozilla/firefox
profilesini=$browserdir/profiles.ini

sudo -u "$name" firefox --headless >/dev/null 2>&1 &
until [ -f "$profilesini" ]; do
	sleep 1
done
profile=`sed -n "/Default=.*\.default-release/ s/.*=//p" "$profilesini"`
pdir=$browserdir/$profile

t=/tmp/f$$
curl -sL -o "$t" "https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/user.js"
cat "$config/firefox/custom.js" "$t" >"$config/firefox/user.js"
sudo -u "$name" ln -sf "$config/firefox/user.js" "$pdir/user.js"
rm -f "$t"
pkill -u "$name" firefox

### SERVICES / NETWORK ###

systemctl enable bluetooth
rfkill unblock bluetooth
sed -i 's/^#AutoEnable=false/AutoEnable=false/' /etc/bluetooth/main.conf
sed -i 's/^AutoEnable=true/AutoEnable=false/' /etc/bluetooth/main.conf

sudo -u "$name" systemctl --user enable pipewire

awk '{if ($3 == "ext4") print $1" "$2"\t"$3"\t"$4",commit=60 "$5"\t"$6; else print}' /etc/fstab >/etc/fstab.new
mv /etc/fstab.new /etc/fstab

printf "nameserver 1.1.1.1\nnameserver 1.0.0.1\n" >/etc/resolv.conf.manually-configured
rm -f /etc/resolv.conf
ln -s /etc/resolv.conf.manually-configured /etc/resolv.conf

echo "%wheel ALL=(ALL:ALL) ALL" >/etc/sudoers.d/00-wheel-can-sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/01-cmds-without-password
echo "Defaults editor=/usr/bin/nvim" >/etc/sudoers.d/02-visudo-editor

mkdir -p /etc/sysctl.d
echo "kernel.dmesg_restrict = 0" >/etc/sysctl.d/dmesg.conf

mkdir -p /etc/systemd/timesyncd.conf.d
echo "[Time]
RootDistanceMaxSec=0.1
PollIntervalMinSec=1d
PollIntervalMaxSec=4w
SaveIntervalSec=infinity" >/etc/systemd/timesyncd.conf.d/local.conf
timedatectl set-ntp true

### DONE ###

echo "Done. Log out and back in as $name, then run startx."
