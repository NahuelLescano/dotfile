function mirrord --description 'alias mirrord reflector delay sort'
  sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist $argv
end
