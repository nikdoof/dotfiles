# shellcheck shell=bash
alias ls="ls -F --color=auto"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

# NixOS aliases
if [ -f "/etc/NIXOS" ]; then
    alias nrs="sudo nixos-rebuild switch --refresh --flake github:nikdoof/nixos-config#$(hostname)"
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
