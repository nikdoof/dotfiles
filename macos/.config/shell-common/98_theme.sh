# shellcheck shell=bash

# Set themes for various CLI apps to match our terminal settings
# Theme flavour of the month: Nord

# Bat
if [ -x "$(command -v bat)" ]; then
    export BAT_THEME="Nord"
fi

# Fzf
if [ -x "$(command -v bat)" ]; then
    export FZF_DEFAULT_OPTS='
        --color=fg:#e5e9f0,bg:#2E3440,hl:#81a1c1
        --color=fg+:#e5e9f0,bg+:#2E3440,hl+:#81a1c1
        --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
        --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
fi
