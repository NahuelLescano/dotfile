# This is using DT's configs: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish
### ADDING TO THE PATH ###
# First line removes the paths; second line sets it. Without the first line,
# the path gets massive and fish become very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin $HOME/.emacs.d/bin $HOME/Applications /var/lib/flatpak/exports/bin/ $fish_user_paths

fish_vi_key_bindings                        # set vi mode
set fish_greeting                           # Supresses fish's intro message
set TERM "xterm-256color"                   # Sets the terminal type
set EDITOR "emacsclient -t -a ''"           # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs"        # $VISUAL use Emacs in GUI mode

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

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

# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

### END OF FUNCTIONS ###

### ALIASES AND ABBREVIATIONS ###
## Aliases
alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# Changing ls with exa
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# get fastest mirrors
alias mirror="doas reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="doas reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="doas reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="doas reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

## Abbreviations
# navigation
abbr --add .. cd ..
abbr --add ... cd ../..
abbr --add .3 cd ../../..
abbr --add .4 cd ../../../..

# pacman
abbr --add pacin doas pacman -S                       # install programs
abbr --add pacrm doas pacman -Rns                     # remove programs and all dependencies
abbr --add pacss pacman -Ss                           # search for specific program
abbr --add pacsyu doas pacman -Syu                    # update only standard packages
abbr --add pacsyyu doas pacman -Syyu                  # refresh pkglist and update standard pkgs
abbr --add cleanup doas pacman -Rns (pacman -Qtdq)    # remove orphaned packages

# paru
abbr --add parsua paru -Sua --noconfirm              # update only AUR packages
abbr --add parin paru -S                             # install AUR package
abbr --add parm paru -Rns                           # remove AUR package and all dependencies
abbr --add parss paru -Ss                            # search for specific AUR package
abbr --add parqua paru -Qua                         # show if a pkg has an update

# git
abbr --add init git init
abbr --add add git add
abbr --add addup git add -u
abbr --add addall git add .
abbr --add status git status
abbr --add diff git diff
abbr --add branch git branch
abbr --add clone git clone
abbr --add commit git commit -v
abbr --add commitMes git commit -m
abbr --add show git remote show origin
abbr --add pull git pull origin
abbr --add push git push origin
abbr --add checkout git checkout
abbr --add log git log --pretty=format:'"%h - %an, %ar: %s"'

# get error messages from journalctl
abbr --add jctl journalctl -p 3 -xb

# npm
abbr --add npi npm install
abbr --add npt npm test
abbr --add nps npm start
abbr --add npr npm run

# nvim
abbr --add nv nvim

# emacs
abbr --add emacs emacsclient -c -a 'emacs'

# feh
abbr --add feh feh -Z -.

# Colorscript
colorscript -r

# Starship
starship init fish | source

# Fuck
thefuck --alias | source
