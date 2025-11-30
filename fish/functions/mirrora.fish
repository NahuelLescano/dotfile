function mirrora --description 'alias mirrora reflector age sort'
  sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist $argv
end
