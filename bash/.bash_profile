# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export TZ=GB
export LANG=en_GB.UTF-8

if [ -x /usr/bin/nano ]; then
	export EDITOR=nano
	export VISUAL=nano
else
	export EDITOR=vi
	export VISUAL=vi
fi

# OSX Specific envs
if [ $(uname) == "Darwin" ]; then
	# Shhh Catlina, we don't care!
	export BASH_SILENCE_DEPRECATION_WARNING=1

	# M1 specific hacks
	if [ $(uname -p) == "arm" ]; then
		# Stop golang progs having fun with Rosetta 2 (https://yaleman.org/post/2021/2021-01-01-apple-m1-terraform-and-golang/)
		export GODEBUG=asyncpreemptoff=1
	fi
fi

# Go stuff
if [ -d /usr/local/go ]; then
	export GOROOT=/usr/local/go/
	export GOPATH=$HOME/go/
	export PATH=$PATH:/usr/local/go/bin
fi

export PS1="\[\e[0;90m\][\[\e[0;37m\]\u\[\e[0;37m\]@\[\e[0;37m\]\H\[\e[0;90m\]] \[\e[0;90m\](\[\e[0;37m\]\W\[\e[0;90m\]) \[\e[0;37m\]\$\[\e[0m\] "
