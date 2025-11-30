function clear --description 'alias clear fancy clear screen'
  echo -en "\x1b[2J\x1b[1;1H"
  echo
  echo
  seq 1 (tput cols) | sort -R | spark | lolcat
  echo
  echo
end
