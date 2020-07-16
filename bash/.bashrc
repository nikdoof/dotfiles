# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source functions, if it exists
if [ -e $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

# Source aliases, if it exists
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH
