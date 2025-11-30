function mirrors --description 'alias mirrors reflector score sort'
  sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist $argv
end
