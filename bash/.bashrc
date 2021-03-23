# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source functions, if it exists
if [ -e $HOME/.bash/functions.bash ]; then
    source $HOME/.bash/functions.bash
fi

# Source aliases, if it exists
if [ -e $$HOME/.bash/aliases.bash ]; then
    source $HOME/.bash/aliases.bash
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH
