# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source exports, if it exists
if [ -f $HOME/.config/bash/exports.bash ]; then
    source $HOME/.config/bash/exports.bash
fi

# Source functions, if it exists
if [ -f $HOME/.config/bash/functions.bash ]; then
    source $HOME/.config/bash/functions.bash
fi

# Source aliases, if it exists
if [ -f $HOME/.config/bash/aliases.bash ]; then
    source $HOME/.config/bash/aliases.bash
fi

# Source completions, if it exists
if [ -f $HOME/.config/bash/completions.bash ]; then
    source $HOME/.config/bash/completions.bash
fi

# Homebrew
[ -d /opt/homebrew ] && eval $(/opt/homebrew/bin/brew shellenv)