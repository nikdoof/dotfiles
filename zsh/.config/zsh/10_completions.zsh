fpath+=($XDG_CONFIG_HOME/zsh/completions)

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
