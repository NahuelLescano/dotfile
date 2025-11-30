function ll --wraps='eza' --description 'alias ll eza long format'
  eza --icons -a -l --color=always --group-directories-first $argv
end
