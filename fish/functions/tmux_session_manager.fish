function tmux_session_manager -d "Manage tmux sessions on fish startup"
    # Check if we're already inside tmux
    if set -q TMUX
        return
    end

    # Get list of existing tmux sessions
    set sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
    
    if test (count $sessions) -eq 0
        # No sessions exist, create a new one
        echo "No hay sesiones de tmux. Creando nueva sesión..."
        tmux new-session
        return
    end

    # Display existing sessions
    echo "Sesiones de tmux existentes:"
    for i in (seq (count $sessions))
        echo "  $i) $sessions[$i]"
    end
    echo "  n) Nueva sesión"
    echo "  s) Iniciar fish sin tmux"
    
    # Get user choice
    read -P "Selecciona una opción: " choice
    
    switch $choice
        case 'n' 'N'
            echo "Creando nueva sesión..."
            tmux new-session
        case 's' 'S'
            echo "Iniciando fish sin tmux..."
            return
        case '*'
            # Check if choice is a valid number
            if string match -qr '^\d+$' $choice
                set session_index (math $choice)
                if test $session_index -ge 1 -a $session_index -le (count $sessions)
                    set selected_session $sessions[$session_index]
                    echo "Conectando a sesión: $selected_session"
                    tmux attach-session -t $selected_session
                else
                    echo "Opción inválida. Creando nueva sesión..."
                    tmux new-session
                end
            else
                echo "Opción inválida. Creando nueva sesión..."
                tmux new-session
            end
    end
end
