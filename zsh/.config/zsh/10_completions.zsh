# shellcheck shell=zsh
fpath+=($XDG_CONFIG_HOME/zsh/completions)

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# If we have fzf installed, load its zsh completions
if [ -x $(command -v fzf) ]; then
    source <(fzf --zsh)
fi
