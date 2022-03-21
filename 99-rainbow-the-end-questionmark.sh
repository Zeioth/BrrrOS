#!/bin/bash
# ============================================================================"
# COMMENT: Tehehehe
# ============================================================================"

echo "========================================================================"
echo "4) RESTORING PERSONAL FOLDER"
echo "========================================================================"
echo "You didn't programmed this. Maybe the next time ;p"
echo "TODO: Now you can do it by running rclone and restoring!)
            (Alternatively you can offer the user to resore from laptop)"
echo "/n"

echo "========================================================================"
echo "5) CLEANING USELESS PACKAGES"
echo "========================================================================"
sudo pacman -rf /etc/sway
read -p "DO YOU WANT TO CLEAN USELESS PACKAGES? (Y/n): " -n 1 -i "y" USER_AGREEMENT
if [ "$USER_AGREEMENT" == "y" ]; then
  paco-autoremove
fi
echo "/n"

echo "========================================================================"
echo "SUCCESS!!"
echo "========================================================================"
echo "We are ready. Enjoy."
echo "* → To setup neomutt, run 'mw', and follow the instructions. Then delete ~/.config/mutt/muttrc and ~/.mbsyncrc and restore both files from your backups"
echo "* Some settings won't apply until you reboot."
echo ""
