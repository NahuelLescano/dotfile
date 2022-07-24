if status --is-login
      startx
end

## ADDING TO THE PATH
# First line removes the paths; second line sets it. Without the first line,
# the path gets massive and fish become very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths

set EDITOR nvim           # Set the editor
set TERM "xterm-256color" # Sets the terminal type
fish_vi_key_bindings      # set vi mode
set fish_greeting         # Supresses fish's intro message

neofetch

## AUTOCOMPLETE AND HIGHLIGHT COLORS ##
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


## ALIASES AND ABBREVIATIONS##
alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# navigation
abbr --add .. cd ..
abbr --add ... cd ../..
abbr --add .3 cd ../../..
abbr --add .4 cd ../../../..

# Changing ls with exa
alias ls='exa -al --color=always --color-scale --group-directories-first' # Listing the files.
alias lt='exa -aT --color=always --color-scale --group-directories-first' # Listing the files with tree view.

# pacman and yay
abbr --add pacin sudo pacman -S                     # install programs
abbr --add pacsyu sudo pacman -Syu                  # update only standard packages
abbr --add pacsyyu sudo pacman -Syyu                # refresh pkglist and update standard pkgs
abbr --add cleanup sudo pacman -Rns (pacman -Qtdq)  # remove orphaned packages
abbr --add yaysua yay -Sua --noconfirm              # update only AUR packages

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# git
abbr --add addup git add -u
abbr --add addall git add .
abbr --add branch git branch
abbr --add clone git clone
abbr --add commit git commit -m
abbr --add pull git pull origin
abbr --add push git push origin

