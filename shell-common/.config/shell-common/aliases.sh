# macOS aliases
if [[ $(uname) == "Darwin" ]]; then
    alias ls="ls -FG"
    alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
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

alias t='(tmux has-session 2>/dev/null && tmux attach) || (tmux new-session)'
alias tma="tmux attach"
alias last="last | head"
alias dp="demoprompt"
