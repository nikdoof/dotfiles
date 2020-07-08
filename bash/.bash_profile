# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export TZ=GB
export LANG=en_GB.UTF-8
export EDITOR=nano
export VISUAL=nano

export PS1="\[\e[0;90m\][\[\e[0;37m\]\u\[\e[0;37m\]@\[\e[0;37m\]\H\[\e[0;90m\]] \[\e[0;90m\](\[\e[0;37m\]\W\[\e[0;90m\]) \[\e[0;37m\]\$\[\e[0m\] "
