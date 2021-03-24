# Source exports, if it exists
if [ -f $HOME/.config/zsh/exports.zsh ]; then
    source $HOME/.config/zsh/exports.zsh
fi

# Source functions, if it exists
if [ -f $HOME/.config/zsh/functions.zsh ]; then
    source $HOME/.config/zsh/functions.zsh
fi

# Source aliases, if it exists
if [ -f $HOME/.config/zsh/aliases.zsh ]; then
    source $HOME/.config/zsh/aliases.zsh
fi

# Source completions, if it exists
if [ -f $HOME/.config/zsh/completions.zsh ]; then
    source $HOME/.config/zsh/completions.zsh
fi
