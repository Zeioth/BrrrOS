#!/bin/bash

# → START of installing AUR packages
echo "========================================================================"
echo "INSTALLING EXTERNAL PACKAGES (YOU NEED TO CONFIRM MANUALLY ONE BY ONE)"
echo "========================================================================"
read -p "DO YOU WANT TO INSTALL AUR PACKAGES? (Y/n): " -n 1 -i "y" USER_AGREEMENT
if [ "$USER_AGREEMENT" == "y" ]; then

  echo "/n/nPackages need to be approved one by one."
  paru -S ranger-git
  paru -S xcursor-breeze
  paru -S franz-bin
  paru -S google-chrome
  paru -S stremio
  paru -S rclone-browser
  paru -S steam-native-runtime
  paru -S numix-frost-themes
  paru -S numix-icon-theme-git
  paru -S numix-square-icon-theme-git
  paru -S numix-circle-icon-theme-git
  paru -S nerd-fonts-dejavu-complete
  paru -S nerd-fonts-roboto-mono
  paru -S ttf-ms-fonts
  paru -S ttf-iosevka
  paru -S mangohud
  paru -S open-fuse-iso
  paru -S ttf-font-awesome-4
  paru -S nerd-fonts-ibm-plex-mono
  paru -S mutt-wizard
  paru -S pam-gnupg
  paru -S vkbasalt
  paru -S reshade-shaders-git
  paru -S docker-rootless-extras-bin
  paru -S wofi
  paru -S jq wofi-emoji
  paru -S wofi-calc
  gpg --keyserver keyserver.ubuntu.com --recv-key 3552E46F58F5FEC69A2CD85A5B4E2D0DD7F62B21
  paru -S abook
  paru -S swayr
  paru -S corectrl
  paru -S sway-audio-idle-inhibit-git
  paru -S lsd-git
  paru -S gdu
  paru -S pamac-nosnap
  paru -S downgrade
  paru -S wob
  paru -S swaylock-effects-git
  paru -S wlsunset
  paru -S atool
  paru -S flashfocus
  paru -S zathura-pdf-poppler
  paru -S systemd-boot-pacman-hook
  paru -S xdg-desktop-portal-wlr amf-amdgpu-pro obs-hevc-vaapi-git amf-amdgpu-pro
  paru -S amf-amdgpu-pro # Adds amf codec support
  paru -S obs-streamfx # Enables amf for streaming
  paru -S obs-vkcapture-git # Adds gamecapture source, which improves performance.
  # Plugin for 60 fps in vlc + mpv for transcoding + amd gpu acceleration
  paru -S rsound spirv-cross mpv-full qt5-base qt5-declarative qt5-svg \
         libmediainfo lsof vapoursynth mpv-vapoursynth mkvtoolnix-cli hsa-rocr svp
  paru -S swayimg
  paru -S cliphist
  paru -S nwg-wrapper

  # LEGACY
  # paru -S antimicrox
  # paru -S epson-inkjet-printer-escpr
  # paru -S epson-printer-utility
  # paru -S rgb2cmyk
  # paru -S xpadneo-dkms-git    # Ya no es necesario. Rompe los maps de Steam.
  # paru -S redshift-gtk-git
  # paru -S rofi-shortcuts
  # paru -S rofi-zeal
  # paru -S ffmpeg-libfdk_aac 	# ffmpeg with libfdk_aa
  # paru -S cpu-g-bzr
  echo ""

  echo "flatpak packages"
  # flatpak install us.zoom.Zoom #  We don't want it until works fine.

  echo "Python pip global packages"
  # Necessary for vdirsyncer
  pip3 install requests-oauthlib

  echo "Adding potentially unsafe packages to IgnorePkg"
  sudo sed -i 's/#IgnorePkg.*/IgnorePkg = ranger-git xcursor-breeze antimicrox franz-bin google-chrome stremio rclone-browser steam-native-runtime numix-frost-themes numix-icon-theme-git numix-square-icon-theme-git numix-circle-icon-theme-git nerd-fonts-dejavu-complete nerd-fonts-roboto-mono ttf-ms-fonts ttf-iosevka mangohud open-fuse-iso ttf-font-awesome-4 nerd-fonts-ibm-plex-mono mutt-wizard vkbasalt reshade-shaders-git docker-rootless-extras-bin wofi jq wofi-emoji wofi-calc abook swayr corectrl sway-audio-idle-inhibit-git lsd-git gdu pamac-nosnap wob swaylock-effects-git wlsunset zeit-git systemd-boot-pacman-hook xdg-desktop-portal-wlr amf-amdgpu-pro obs-hevc-vaapi-git amf-amdgpu-pro obs-streamfx obs-vkcapture-git rsound spirv-cross mpv-full vlc-luajit waybar-git greetd greetd-tuigreet-bin/' /etc/pacman.conf

fi # → END of instalilng AUR packages
echo
echo
