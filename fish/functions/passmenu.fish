function passmenu --description 'alias passmenu pass-menu with fzf opts'
  pass-menu -- fzf --layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark $argv
end
