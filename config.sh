#!/bin/bash

configs=(
    "${HOME}/.config/fish"
    # "${HOME}/.config/alacritty"
    "${HOME}/.config/awesome"
    "${HOME}/.config/hypr"
    "${HOME}/.config/kitty"
    # "${HOME}/.config/polybar"
    # "${HOME}/.config/qtile"
    # "${HOME}/.config/qutebrowser"
    "${HOME}/.config/rofi"
    "${HOME}/.config/waybar"
    # "${HOME}/.config/vifm"
    # "${HOME}/.config/zathura"
    "${HOME}/.config/tmux/tmux.conf"
    "${HOME}/.config/starship.toml"
    "${HOME}/.doom.d"
    "${HOME}/.bashrc"
    "${HOME}/tmux-sessionizer.sh"
)

failed=()
dest="${PWD}/"
echo "Copying dotfiles to repository..."

for item in "${configs[@]}"; do
    if [ -e "$item" ]; then
        cp -r "$item" "$dest" || failed+=("$item")
    else
        failed+=("$item")
    fi
done

if [ "${#failed[@]}" -gt 0 ]; then
    echo "WARNING: Some items could not be copied:"
    printf ' - %s\n' "${failed[@]}"
fi

echo "Done!"
