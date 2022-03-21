#!/bin/bash

echo "
1) This script will install the next software:

ARCH REPOS
-------------------------
zsh
bash-completion
alacritty
firefox
gnome-disk-utility
gimp
rclone
gamemode
lib32-gamemode
libreoffice-fresh
discord
thunderbird
arc-gtk-theme
downgrade
lutris
terminus-font
code
virt-manager
qemu
qemu-arch-extra
docker
docker-compose
sysstat
argyllcms
ttf-font-awesome
noto-fonts-emoji
fd
gvim
ranger
yarn
atool
ctags
pandoc
unrar
zip
gitui
trash-cli
weechat
lynx
v4l2loopback-dkms
the_silver_searcher
transmission-gtk
python-pip
vdirsyncer
xorg-xhost
spice-vdagent (enable copy paste between wayland and xorg)
xdg-desktop-portal-wlr (Allows screen sharing on firefox)
flatpak
nvm (node version manager)
keychain
fzf
tmux
vlc
radeontop
neofetch
foot
foot-terminfo
waybar
wl-clipboard
pcmanfm-gtk3
mako
blueberry
cronie
khal
ncompress
xorg-xwayland
reflector
qt5-wayland
pavucontrol
pulsemixer
unzip
dnsmasq
polkit-gnome
man
zathura-pdf-poppler
xdg-user-dirs  (Required for swayshot)
cups           (printing service)
avahi          (printer wifi discovery)
nss-mdns       (hostname resolution for avahi)
ghostscript    (converts pdf to cmky)
colord         (install CCI color profiles under /usr/share/color/icc/colord/)
foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds (printer drivers)
man-pages
playerctl
nmtui

aur
-------------------------
sway-img
antimicrox
franz-bin
google-chrome
stremio
rclone-browser
steam-native-runtime
numix-frost-themes
pop-xfwm-theme
numix-icon-theme-git
numix-square-icon-theme-git
numix-circle-icon-theme-git
nerd-fonts-dejavu-complete
nerd-fonts-roboto-mono
ttf-ms-fonts
ttf-iosevka
mangohud
skypeforlinux-stable-bin
ttf-font-awesome-4
open-fuse-iso
nerd-fonts-ibm-plex-mono
gitui
mutt-wizard
pam-gnupg
wofi
wofi-emoji
swayr
psensor
corectrl
sway-audio-idle-inhibit
lsd-git
gdu
pamac
downgrade
pamac-nosnap
wob
swaylock-effects
xcursor-breeze
wlsunset
zeit-git
flashfocus
svp
vi
systemd-boot-pacman-hook
obs-hevc-vaapi-git
amf-amdgpu-pro
epson-inkjet-printer-escpr (not needed anymore, just in case)
epson-printer-utility      (not needed anymore, just in case)

FLATPAK
-------------------------
Zoom
"

# START → Installing personal software
echo
read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
if [ "$USER_AGREEMENT" == "y" ]; then
  echo
  echo
  echo "Appliying pacman settings..."
  sudo sed -i '/#ParallelDownloads = 5/c\ParallelDownloads = 32' /etc/pacman.conf
  sudo sed -i '/#Color/c\Color' /etc/pacman.conf
  # This line uncomments both the header and the mirrorlist
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
  echo


  echo "========================================================================"
  echo "INSTALLING PERSONAL SOFTWARE"
  echo "========================================================================"
  sudo pacman -Syyu
  paru -S --needed alacritty firefox gnome-disk-utility gimp rclone \
  gamemode lib32-gamemode libreoffice-fresh discord thunderbird arc-gtk-theme \
  terminus-font code virt-manager dnsmasq qemu qemu-arch-extra docker \
  docker-compose sysstat argyllcms ttf-font-awesome noto-fonts-emoji \
  fd gvim yarn ctags pandoc unrar zip gitui trash-cli weechat lynx \
  v4l2loopback-dkms the_silver_searcher transmission-gtk python-pip vdirsyncer \
  xorg-xhost spice-vdagent keychain fzf psensor tmux vlc radeontop neofetch \
  waybar wl-clipboard pcmanfm-gtk3 zsh mako blueberry cronie khal ncompress \
  xorg-xwayland reflector qt5-wayland pavucontrol pulsemixer unzip polkit-gnome \
  man xdg-user-dirs vi bash-completion cups avahi \
  foomatic-db-engine foomatic-db foomatic-db-ppds nss-mdns ghostscript \
  foomatic-db-nonfree foomatic-db-nonfree-ppds man-pages playerctl nmtui \
  # International support packages:
  adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts
fi
echo "/n"
# END → Installing personal software
