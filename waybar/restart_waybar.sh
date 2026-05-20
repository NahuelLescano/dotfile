#!/bin/bash

# Verifica si Waybar está en ejecución
if pgrep -x "waybar" > /dev/null; then
    # Si está en ejecución, lo mata
    pkill -x "waybar"
    echo "Waybar ha sido detenido."
fi

# Inicia Waybar nuevamente
waybar & >/dev/null 2>&1 & disown
