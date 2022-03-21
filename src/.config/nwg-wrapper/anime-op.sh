#!/usr/bin/env bash






### Consts
max_spacing=2    # maximum number of spaces between characters
ncols=44         # Number of cols
nrows=3          # Number of rows
chars=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ)

# Code
echo
for i in {1..$(seq 0 $nrows)} :
do
  count=${#chars[@]}
  final_string=""
  for i in {1..$(seq 0 $ncols)} :
  do rand=$(($RANDOM%$max_spacing))
    case $rand in
      0)
        final_string="$final_string  ${chars[$RANDOM%$count]}"
      ;;
      1)
        printf "   "
      ;;
    esac
  done
  echo '<span size="25000" foreground="#FFFFFF">'$final_string'</span>'
done
