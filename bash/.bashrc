# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source exports, if it exists
if [ -f $HOME/.bash/exports.bash ]; then
    source $HOME/.bash/exports.bash
fi

# Source functions, if it exists
if [ -f $HOME/.bash/functions.bash ]; then
    source $HOME/.bash/functions.bash
fi

# Source aliases, if it exists
if [ -f $HOME/.bash/aliases.bash ]; then
    source $HOME/.bash/aliases.bash
fi

# Source completions, if it exists
if [ -f $HOME/.bash/exports.bash ]; then
    source $HOME/.bash/completions.bash
fi

# Load iTerm2 integration, for all hosts
source ~/.bash/iterm2_integration.bash

# Homebrew
[ -d /opt/homebrew ] && eval $(/opt/homebrew/bin/brew shellenv)