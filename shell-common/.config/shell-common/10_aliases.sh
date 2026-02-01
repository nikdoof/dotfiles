# shellcheck shell=bash
alias ls="ls -F --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

# NixOS aliases
if [ -f "/etc/NIXOS" ]; then
    alias nixos-rebuild="cd ~/nixos-config && make rebuild"
fi

# Tmux
if [ -x "$(command -v tmux)" ]; then
    alias t='(tmux has-session 2>/dev/null && tmux attach) || (tmux new-session)'
    alias tma="tmux attach"
fi

# Eza
if [ -x "$(command -v eza)" ]; then
    alias ls="eza"
fi

# Bat
if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
fi

alias last="last | head"
alias dp="demoprompt"
alias stow="stowage"
