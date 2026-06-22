### ADDING TO THE PATH ###
# Initialize universal path only once
if not set -q fish_user_paths
    set -U fish_user_paths $HOME/.bin $HOME/.local/bin /var/lib/flatpak/exports/bin/ $HOME/.config/emacs
end

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

## FUNCTIONS ##
# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end
### END OF FUNCTIONS ###

# Starship
starship init fish | source

# Set up fzf key bindings
fzf --fish | source
set FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"

# pnpm
set -gx PNPM_HOME "/home/nahuel/.local/share/pnpm"
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
