#!/bin/bash

# ============================================================================"
# COMMENT: CONSIDER YOURSELF SALUTATED
# ============================================================================"

echo
echo "BrrrOS - The black sheep of operative systems
==============================================================================
You will be guided through the next steps and probably life:

THE THINGY                 DESCRIPTION
1) Software installer   →  Base packages from the official arch repos.
2) Settings applier     →  You can accept only the ones you want!
3) AUR installer        →  you can accept only the ones your want!


IMPORTANT NOTE:
Before running this installer you must run 'archinstall', and choose 'sway'.
We don't install arch for you.
"

echo
read -p "DO YOU ACCEPT THE ACCEPTANCE? (Y/n): " -n 1 -i "y" USER_AGREEMENT
if [ "$USER_AGREEMENT" == "n" ]; then
  echo "Bummer"
  exit
fi
echo

# ============================================================================"
# COMMENT: YOU ARE ABOUT TO INSTALL THIS"
# ============================================================================"

./01-software-installer.sh
./02-configs-installer.sh
./03-aur-packages.sh
./99-the-end-rainbow.sh

# ============================================================================"
# COMMENT: YOU JUST INSTALLED THIS. WHY THOUGH"
# ============================================================================"
