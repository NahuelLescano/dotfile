#!/usr/bin/env bash

FZF_OP="fzf --layout=reverse --border=bold --border=rounded --margin=3% --color=dark -e"

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f $2/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find $HOME/Projects $HOME/.config/ \
        \( -path '*/tmux/plugins/*' -o \
        -path '*/node_modules/*' \
        -o -path '*/build/*' -o -path '*/.git/*' \) -prune \
        -o -type d -print | $FZF_OP)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

if ! has_session $selected_name; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

switch_to $selected_name
