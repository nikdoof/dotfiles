# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2000
SAVEHIST=1000

# Prompt
export PS1="%F{black}[%F{white}%n@%m%F{black}] (%F{white}%1~%F{black}) %F{white}%# "

# User specific environment and startup programs
export TZ=GB
export LANG=en_GB.UTF-8

# Make a sensible editor choice
if [ -x /usr/bin/nano ]; then
	export EDITOR=nano
	export VISUAL=nano
else
	export EDITOR=vi
	export VISUAL=vi
fi

# Go stuff
if [ -d /usr/local/go ]; then
	export GOROOT=/usr/local/go/
	export GOPATH=$HOME/go/
	export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

    # https://github.com/oz/tz
    if [ -f $HOME/go/bin/tz ]; then
        export TZ_LIST="America/New_York,America/Los_Angeles,Europe/Paris"
    fi
fi

# OSX Specific envs
if [[ $(uname) == "Darwin" ]]; then
	# M1 specific hacks
	if [[ $(uname -p) == "arm" ]]; then
		# Stop golang progs having fun with Rosetta 2 (https://yaleman.org/post/2021/2021-01-01-apple-m1-terraform-and-golang/)
		export GODEBUG=asyncpreemptoff=1
	fi
fi