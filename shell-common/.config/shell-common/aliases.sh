# shellcheck shell=bash

# macOS aliases
if [[ $(uname) == "Darwin" ]]; then
    alias ls="ls -FG"
    alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

    # Use Tailscale binary if installed via app
    if [ -d "/Applications/Tailscale.app" ]; then
        alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    fi
else
    alias ls="ls -F --color=auto"
fi

# Use code-insiders if installed
if [ -x "$(command -v code-insiders)" ]; then
    alias code="code-insiders"
fi

# NixOS aliases
if [ -f "/etc/NIXOS" ]; then
    alias nixos-rebuild="cd ~/nixos-config && make rebuild"
fi

# Tmux
if [ -x "$(command -v tmux)" ]; then
    alias t='(tmux has-session 2>/dev/null && tmux attach) || (tmux new-session)'
    alias tma="tmux attach"
fi

alias last="last | head"
alias dp="demoprompt"
