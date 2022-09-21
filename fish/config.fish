## ADDING TO THE PATH
# First line removes the paths; second line sets it. Without the first line,
# the path gets massive and fish become very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths

fish_vi_key_bindings                        # set vi mode
set fish_greeting                           # Supresses fish's intro message
set TERM "xterm-256color"                   # Sets the terminal type
set EDITOR "nvim"                           # Use nvim as the text editor of choice

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

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

## FUNCTIONS ##
function __history_previous_command
    switch (commandline -t)
        case "|"
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
if [ "$fish_key_binding" = "fish_vi_bindings" ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments

else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments

end

## END OF FUNCTIONS ##

## ALIASES AND ABBREVIATIONS##
# Aliases
alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# Changing ls with exa
alias ls='exa -al --color=always --color-scale --group-directories-first' # Listing the files.
alias lt='exa -aT --color=always --color-scale --group-directories-first' # Listing the files with tree view.

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

#Abbreviations
# navigation
abbr --add .. cd ..
abbr --add ... cd ../..
abbr --add .3 cd ../../..
abbr --add .4 cd ../../../..

# pacman and paru
abbr --add pacin doas pacman -S                       # install programs
abbr --add pacrm doas pacman -Rns                     # remove programs and all dependencies
abbr --add pacss pacman -Ss                           # search for specific program
abbr --add pacsyu doas pacman -Syu                    # update only standard packages
abbr --add pacsyyu doas pacman -Syyu                  # refresh pkglist and update standard pkgs
abbr --add cleanup doas pacman -Rns (pacman -Qtdq)    # remove orphaned packages

abbr --add parusua paru -Sua --noconfirm              # update only AUR packages
abbr --add paruin paru -S                             # install AUR package
abbr --add parurm paru -Rns                           # remove AUR package and all dependencies
abbr --add paruss paru -Ss                            # search for specific AUR package

# snap
abbr --add snapin doas snap install                   # install snap programs
abbr --add snaprm doas snap remove                    # remove snap programs
abbr --add snapup doas snap refresh                   # update snap programs
abbr --add snapss snap find                           # find snap program

# flatpak
abbr --add flatup flatpak update
abbr --add faltin flatpak install

# git
abbr --add init git init
abbr --add addup git add -u
abbr --add addall git add .
abbr --add status git status
abbr --add diff git diff
abbr --add branch git branch
abbr --add clone git clone
abbr --add commit git commit -v
abbr --add pull git pull origin
abbr --add push git push origin
abbr --add log git log --pretty=format:'"%h - %an, %ar: %s"'

#nvim
abbr --add v nvim

# Colorscript
colorscript -r

# Starship
starship init fish | source
