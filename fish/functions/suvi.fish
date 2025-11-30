function suvi --description 'alias suvi sudo env nvim'
  sudo -E env "PATH=$PATH" nvim $argv
end
