# This is using DT's configs: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish

### ADDING TO THE PATH ###
# First line removes the paths; second line sets it. Without the first line,
# the path gets massive and fish become very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin  /var/lib/flatpak/exports/bin/

fish_vi_key_bindings                        # set vi mode
set fish_greeting                           # Supresses fish's intro message
set TERM "xterm-256color"                   # Sets the terminal type
set EDITOR "nvim"                           # $EDITOR use nvim in terminal

## Set nvim as manpager
set -x MANPAGER "nvim +Man!"

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

## SPARK ##
set -g spark_version 1.0.0

complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc spark -n __fish_use_subcommand -a --version -d "$spark_version"
complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"

function spark -d "sparkline generator"
    if isatty
        switch "$argv"
            case {,-}-v{ersion,}
                echo "Spark version $spark_version"

            case {,-}-h{elp,}
                echo "Usage: spark [--min=<n> --max=<n>] <numbers...> Draw sparklines"
                echo "Examples:"
                echo "  spark 1 2 3 4"
                echo "  seq 100 | sort -R | spark"
                echo "  awk \\\ $0=length spark.fish | spark"

            case \*
                echo $argv | spark $argv

        end
        return

    end

    command awk -v FS="[[:space:]]*" -v argv="$argv" '
        BEGIN {
            min = match(argv, /--min=[0,9]+/) ? substr(argv, RESTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--min=[0,9]+/) ? substr(argv, RESTART + 6, RLENGTH - 6) + 0 : ""
        }

        {

            for (i = j = 1; i <= NF; i++) {
                if ($1 ~ /^--/)
                    continue

                if ($1 !~ /^-?[0-9]/)
                    data[count + j++] = ""

                else {
                    v = data[count + j++] = int($1)
                    if (max == "" && min == "")
                        max = min = v

                    if (max < v)
                        max = v

                    if (min > v)
                        min = v
                }
            }

            count += j - 1
        }

        END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : i
            for (i = 1; i <= count; i++)
                out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])

            print out
        }
    '
end
## END OF SPARK ##

## FUNCTIONS ##
# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint

  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward

  case "*"
    commandline -i '$'
  end
end


function tmux-session
    bash $HOME/tmux-sessionizer.sh
end

# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

### END OF FUNCTIONS ###

### ALIASES AND ABBREVIATIONS ###
## Aliases
alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# Changing ls with exa
alias ls='exa --icons -a --color=always --group-directories-first'    # my preferred listing
alias ll='exa --icons -a -l --color=always --group-directories-first' # long format
alias lt='exa --icons -a -T --color=always --group-directories-first' # tree listing

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Merge Xresources
# alias merge='xrdb -merge ~/.Xresources'

# Always use nvim instead of vim.
alias suvi='sudo -E env "PATH=$PATH" nvim'

# feh
# alias feh="feh -Z -."

## Abbreviations
# navigation
abbr --add .. cd ..
abbr --add ... cd ../..
abbr --add .3 cd ../../..
abbr --add .4 cd ../../../..

# pacman
abbr --add pin sudo pacman -S                       # install programs
abbr --add prm sudo pacman -Rns                     # remove programs and all dependencies
abbr --add pss pacman -Ss                           # search for specific program
abbr --add psyu sudo pacman -Syu                    # update only standard packages
abbr --add psyyu sudo pacman -Syyu                  # refresh pkglist and update standard pkgs
abbr --add cleanup sudo pacman -Rns (pacman -Qtdq)  # remove orphaned packages

# paru
abbr --add pasua paru -Sua --noconfirm              # update only AUR packages
abbr --add pain paru -S                             # install AUR package
abbr --add parm paru -Rns                           # remove AUR package and all dependencies
abbr --add pass paru -Ss                            # search for specific AUR package
abbr --add paqua paru -Qua                          # show if a pkg has an update

# git
abbr --add gi git init
abbr --add ga git add
abbr --add gal git add .
abbr --add gs git status
abbr --add gb git branch
abbr --add gc git clone
abbr --add gcv git commit -v
abbr --add gcm git commit -m
abbr --add gsh git remote show origin
abbr --add gpl git pull origin
abbr --add gps git push origin
abbr --add gsw git switch
abbr --add gl git log --pretty=format:'"%h - %an, %ar: %s"'

# get error messages from journalctl
abbr --add jctl journalctl -p 3 -xb

# nvim
abbr --add nv nvim

# lazygit
abbr --add lg lazygit

# tmux
abbr --add tm tmux
abbr --add ts tmux-session

# yazi
abbr --add ya yazi

# Starship
starship init fish | source

# flatpak
abbr --add flatin flatpak install
abbr --add flatup flatpak update
abbr --add flats flatpak search
abbr --add flatrm flatpak remove

# Set up fzf key bindings
# CTRL-t -> fzf select
# CTRL-r -> fzf history
# ALT-c -> fzf cd
fzf --fish | source
set FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# zoxide
if command -sq zoxide
    zoxide init fish | source
else
    echo 'zoxide: command not found, please install it from https://github.com/ajeetdsouza/zoxide'
end

if not set -q TMUX
    tmux
end

## Yazi setup
# function y
# 	set tmp (mktemp -t "yazi-cwd.XXXXXX")
# 	yazi $argv --cwd-file="$tmp"
# 	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
# 		builtin cd -- "$cwd"
# 	end
# 	rm -f -- "$tmp"
# end
