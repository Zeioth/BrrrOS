#!/usr/bin/env bash

# A clock to show in the locking screen
time=$(LC_ALL=C TZ='Europe/Warsaw' date +'%A, %d. %B')
wttr=$(curl https://wttr.in/?format=1)

echo
echo
echo
echo
echo
echo
echo '<span size="35000" foreground="#ffffff">'$time'</span><span size="60000" foreground="#d6d6d6">'
echo $wttr'</span>'

# time=$(TZ='Europe/Madrid' date +'%H:%M:%S')
# echo '<span size="25000" foreground="#998000" face="monospace" weight="bold"> '$time'</span>'

# echo '<span size="large" face="monospace" foreground="#ccc">'
# time=$(TZ='America/Atikokan' date +"%H:%M")
# echo 'Canada	<b>'$time'</b>'

# time=$(TZ='Europe/Dublin' date +"%H:%M")
# echo 'Ireland	<b>'$time'</b>'

# time=$(TZ='Asia/Kolkata' date +"%H:%M")
# echo 'India	<b>'$time'</b>'

# time=$(TZ='Asia/Shanghai' date +"%H:%M")
# echo 'China	<b>'$time'</b>'
# echo '</span>'
