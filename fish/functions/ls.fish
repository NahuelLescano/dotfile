function ls --wraps='eza' --description 'alias ls eza listing'
  eza --icons -a --color=always --group-directories-first $argv
end
