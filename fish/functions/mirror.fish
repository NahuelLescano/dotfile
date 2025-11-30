function mirror --description 'alias mirror reflector fast mirrors'
  sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist $argv
end
