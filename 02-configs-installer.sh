#!/bin/bash

# START → Applying custom settings
echo
read -p "2) DO YOU WANT TO APPLY CONFIGURATIONS? (Y/n): " -n 1 -i "y" USER_AGREEMENT
if [ "$USER_AGREEMENT" == "y" ]; then

  echo "========================================================================"
  echo "APLYING CUSTOM SETTINGS"
  echo "========================================================================"

  echo "/n/n2.0) Installing PARU."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    git clone https://aur.archlinux.org/paru.git /tmp
    cd /tmp/paru; makepkg -si; cd ~
  fi


  echo "/n/n2.1) Adding users extra permissions to sudoers."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    echo "# From man:
    # When multiple entries match for a user, they are applied in order.
    # Where there are multiple matches, the last match is used (which is not necessarily the most specific match).
    # If doesn't work, make sure the line that source sudoers is the last one in sudo visudo.
    # Warning: For GUI applications use /etc/polkit-1/rules.d instead.
    zeioth ALL=(ALL:ALL) NOPASSWD: /home/zeioth/.local/bin/update-mirrors" \
      | sudo tee /etc/sudoers.d/permissions
  fi


  echo "/n/n2.2) Adding EDID profile for the monitors."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo mkdir -p /usr/firmware/lib/edid
    sudo cp ~/tweaks/misc/edid-profiles-for-screens/edid-philips-4k-71hz.bin /usr/firmware/lib/edid/edid-philips-4k-71hz.bin
  fi


  echo "/n/n2.3) Xbox One Controller bluetooth support."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
        sudo sed -i '/#AutoEnable/c\AutoEnable=true' /etc/bluetooth/main.conf
    sudo sed -i '/#DiscoverableTimeout/c\DiscoverableTimeout = 0' /etc/bluetooth/main.conf
    sudo sed -i '/#FastConnectable/c\FastConnectable = true' /etc/bluetooth/main.conf
    sudo sed -i '/#JustWorksRepairing/c\JustWorksRepairing = always' /etc/bluetooth/main.conf
    # Example of systemd boot entry
    #files=(*) echo " quiet udev.log_priority=3 bluetooth.disable_ertm=1 mitigations=off drm.edid_firmware=DP-2:edid/edid-philips-4k-71hz.bin video=1280x1024@60 amdgpu.ppfeaturemask=0xffffffff" | sudo tee "/boot/loader/entries/${files[0]}"
  fi


  echo "/n/n2.4) Setting ZSH as the default shell."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    chsh -s $(which zsh)
    sudo chsh -s $(which zsh) # same but for sudo
  fi


  echo "/n/n2.5) Creating the swapfile (24Gb)."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo mkdir /var/tmp/swap/
    sudo fallocate -l 24G /var/tmp/swap/swapfile
    sudo chmod 600 /var/tmp/swap/swapfile
    sudo mkswap /var/tmp/swap/swapfile
    sudo swapon /var/tmp/swap/swapfile
    # Make it persistent
    echo "/var/tmp/swap/swapfile swap swap defaults 0 0" | sudo tee /etc/fstab
  fi


  echo "/n/n2.6) Limiting systemctl journalctl to 250MB instead of 10%."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo mkdir -p /etc/systemd/journald.conf.d
    echo "[Journal]
    SystemMaxUse=250M
    SystemMaxFileSize=50M
    " | sudo tee -a /etc/systemd/journald.conf.d/size.conf
  fi


  echo "/n/n2.7) Add corectrl to polkit so it doesn't ask for sudo permissions."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    echo 'polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
             action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("zeioth")) {
                return polkit.Result.YES;
        }
    });
    ' | sudo tee /etc/polkit-1/rules.d/90-corectrl.rules
  fi


  echo "/n/n2.8) Enable libvirtd."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    # El servicio inicia en ~/.local/bin/virt-manager-custom
    sudo usermod -a -G libvirt $(whoami)
    newgrp libvirt
  fi


  echo "/n/n2.9) Enable Docker."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo systemctl enable --now docker
  fi


  echo "/n/n2.10) Enable bluetooth."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo systemctl enable --now bluetooth
  fi


  echo "/n/n2.11) Optimizing IO schedulers."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo touch /etc/udev/rules.d/60-ioschedulers.rules
    echo '# SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

    # NVME
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"

    # HDD
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' | sudo tee '/etc/udev/rules.d/60-ioschedulers.rules'
  fi


  echo "/n/n2.12) Restoring crontab tasks."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo touch /var/log/crontab-zeioth-auto-cloud-backup.log
    crontab ~/tweaks/misc/crontab-tasks-zeioth
    sudo chown zeioth:zeioth /var/log/crontab-zeioth-auto-cloud-backup.log
  fi


  echo "/n/n2.13) Setting vim fugitive as merge tool."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    git config --global mergetool.fugitive.cmd 'vim -f -c "Gvdiffsplit!" "$MERGED"'
    git config --global merge.tool fugitive
  fi


  echo "/n/n2.14) Changing main GPU for SWAY."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    # Note: The first one will do the heavy lift.
    #       If the main GPU is more powerful than the second one,it will stutter.
    echo 'WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0' | sudo tee '/etc/environment'
  fi
  echo ""


  echo "/n/n2.15) Enabling Wob (Wayland overlay bar)"
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    systemctl enable --now --user wob.socket
  fi


  echo "/n/n2.16) Enabling cups (Printer service)"
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    # INSTRUCTIONS:
    # CUPS server default url: http://localhost:631/
    # To list uris use:        lpinto -v
    sudo systemctl enable --now cups.service
    sudo systemctl enable --now avahi-daemon.service
    # Enable hostname resolution:
    # https://wiki.archlinux.org/title/Avahi#Hostname_resolution
    sudo sed -i 's/^hosts:.*/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns/g' /etc/nsswitch.conf
    # NOTE: Now we are using driverless mode instead of ppd.
    #       In the future -m parameter won't be necessary anymore.
    lpadmin -p epson-et1810 -v ipps://EPSON%20ET-1810%20Series._ipps._tcp.local/ -m driverless:ipps://EPSON%20ET-1810%20Series._ipps._tcp.local/ -E
    lpadmin -d epson-et1810 # set as default printer
    echo "Printers installed:"
    lpstat -p | awk '{print $2}'
    # NOTES
    # Feel free to stop the services when not in use.
    # La impresora se puede emparejar al router con el boton WPS del router
    # WARING: En caso de que retiren el soporte PPD tienes dos opciones:
    # * Comprarte otra impresora que soporte el protocolo (https://www.pwg.org/printers/)
    # * O hacer downgrade a una version que lo soporte:  cups 1:2.4.1-1
    # OPTIONAL: TO PRINT FROM COMMAND LINE (
    # To find the ipps uri of your pinter run 'lpinfo -v'
    # lpadmin -p epson-et1810 -E -v ipps://EPSON%20ET-1810%20Series._ipps._tcp.local/ -i /usr/share/ppd/epson-inkjet-printer-escpr/Epson-ET-1810_Series-epson-escpr-en.ppd # Add the printer to lp
  fi

  echo "/n/n2.17) Enabling TRIM for hard disks."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    # Delete once per week all the stuff marked as deleted physically.
    # Speeds up writing times and disk life.
    sudo systemctl enable fstrim.timer
  fi

  echo "/n/n2.18) Changing TTY font and size (terminus16x32)."
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    sudo pacman -S terminus-font
    sudo touch /etc/vconsole.conf
    echo 'FONT=ter132n
    USECOLOR=yes
    KEYMAP=es
    ' | sudo tee /etc/vconsole.conf
  fi

  echo "/n/n2.19) Enable greeter"
  read -p "DO YOU AGREE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
  if [ "$USER_AGREEMENT" == "y" ]; then
    # Nota:  Es muy recomendable usar greeter en vezde TTY puro.
    #        Actua de barrera y evita que rompamos TTY por accidente.
    # Nota2: Es crucial añadir $PATH a .profile para que funcione 100%.
    paru -S greetd
    paru -S greetd-tuigreet-bin
    # Config for tuigreet/sway
    echo '[terminal]
    vt = "next"

    [default_session]
    command = "tuigreet --remember --time --issue --asterisks --cmd sway"
    user = "greeter"' | sudo tee /etc/greetd/config.toml
    # Creating the greeter user
    sudo useradd -M -G video greeter
    # Limiting greetd permissions to the minimum (as in the docs)
    sudo chmod -R go+r /etc/greetd/
    # Enabling greetd service
    sudo systemctl enable greetd
  fi

  # LEGACY
  # ------------------------------------
  # NO NEED FOR IT, NOW WE USE KEYCHAIN
  # echo "17) Add ssh to ssh agent (so it doesn't ask for pass every time)"
  # eval "$(ssh-agent -s)"
  # ssh-add ~/.ssh/zeioth-github.key
  # ssh-add ~/.ssh/zeioth-bitbucket.key
  # ssh-add ~/.ssh/zeioth-paru.key

  # echo "7) Enable SSH server (Currently has a bad scape somewhere, careful)"
  # echo "
  # # Allow only zeioth on local network
  # DenyUsers users@"!host,*\\"
  # AllowUsers zeioth

  # # Increase concurrent connections
  # MaxSessions 10000
  # MaxStartups 10000
  # " | sudo tee -a /etc/ssh/sshd_config
  # sudo systemctl enable sshd && sudo systemctl start --now sshd
  # echo ""


  # HEMOS LOCALIZADO EL FALLO EN EL KERNEL TKG - Vanilla y zen no lo tienen.
  #echo "17) Enable the display resolution fix on wakeup from sleep"
  #systemctl enable --now --user post-wakeup.service
  #systemctl start --now --user post-wakeup.service
  #echo ""

  # echo "1) Add zeioth to wheel group (Allow to run sudo and su)"
  # su
  # usermod --append --groups wheel zeioth
  # usermod --append --groups sudo zeioth
  # sudo touch /etc/sudoers.d/permissions
  # echo "# Anyone in the wheel group can run sudo commands
  # %wheel ALL=(ALL:ALL) ALL
  # %sudo ALL=(ALL:ALL) ALL

  # # Allow updating mirrors without password

  # # Allow some apps sudo without password
  # zeioth ALL=(ALL:ALL) NOPASSWD: /home/zeioth/.local/bin/update-mirrors
  # " | sudo tee /etc/sudoers.d/permissions
  # su zeioth

  # echo "/n/n10) Add mimetypes (Currently disabled)"
  # echo ""

  # echo "========================================================================"
  # echo "BACKUP THE SYSTEMD-BOOT"
  # echo "========================================================================"
  # echo "WARNING: Don't touch /boot/loader/entries/arch.conf until the script ends"
  # sudo mkdir -p /var/tmp/bootconfig.bk
  # sudo cp -rf /boot/loader/entries /var/tmp/bootconfig.bk
  # echo


fi # → END of appling configurations
echo
echo
