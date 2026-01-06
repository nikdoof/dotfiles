# Aerospace specific shell configuration

# Fuzzy find and focus a window using aerospace and fzf
if [ -x "$(command -v aerospace)" ] && [ -x "$(command -v fzf)" ]; then
    function ff() {
        aerospace list-windows --all | fzf --height 40% --layout=reverse --border --ansi | awk '{print $1}' | xargs -I {} aerospace focus --window-id {}
    }
fi
