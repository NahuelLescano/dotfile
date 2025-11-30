# This is using DT's configs: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish

### ADDING TO THE PATH ###
# Initialize universal path only once
if not set -q fish_user_paths
    set -U fish_user_paths $HOME/.bin $HOME/.local/bin /var/lib/flatpak/exports/bin/
end

fish_vi_key_bindings                        # set vi mode
set fish_greeting                           # Supresses fish's intro message
set TERM "xterm-256color"                   # Sets the terminal type
set EDITOR "nvim"                           # $EDITOR use nvim in terminal

if status --is-interactive;
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
    ## END OF SPARK ##
    
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

    ### ALIASES AND ABBREVIATIONS ###

    ## PACMAN abbreviations
    abbr --query pin   ; or abbr --add pin   sudo pacman -S
    abbr --query prm   ; or abbr --add prm   sudo pacman -Rns
    abbr --query pss   ; or abbr --add pss   pacman -Ss
    abbr --query psyu  ; or abbr --add psyu  sudo pacman -Syu
    abbr --query psyyu ; or abbr --add psyyu sudo pacman -Syyu
    abbr --query cleanup; or abbr --add cleanup sudo pacman -Rns (pacman -Qtdq)

    ## PARU abbreviations
    abbr --query pasua ; or abbr --add pasua paru -Sua --noconfirm
    abbr --query pain  ; or abbr --add pain  paru -S
    abbr --query parm  ; or abbr --add parm  paru -Rns
    abbr --query prss  ; or abbr --add prss  paru -Ss
    abbr --query paqua ; or abbr --add paqua paru -Qua

    ## Misc abbreviations
    abbr --query jctl; or abbr --add jctl journalctl -p 3 -xb
    abbr --query nv  ; or abbr --add nv nvim
    abbr --query lg  ; or abbr --add lg lazygit
    abbr --query tm  ; or abbr --add tm tmux
    abbr --query ts  ; or abbr --add ts tmux-session
    abbr --query flin; or abbr --add flin flatpak install
    abbr --query flup; or abbr --add flup flatpak update
    abbr --query flss ; or abbr --add flss flatpak search
    abbr --query flrm; or abbr --add flrm flatpak remove

    # Set up fzf key bindings
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

    # Starship
    starship init fish | source
    
    # zoxide
    if command -sq zoxide
        zoxide init fish | source
    else
        echo 'zoxide: command not found, please install it from https://github.com/ajeetdsouza/zoxide'
    end
    
    if status --is-login; and not set -q TMUX
        tmux
    end
end
