# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

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
export GOPATH=$HOME/go/
export PATH=${GOPATH}bin:$PATH
if [ -z ${GOROOT+x} ] && [ -d /usr/local/go ]; then
    export GOROOT=/usr/local/go/
    export PATH=$PATH:$GOROOT/bin:$HOME/go/bin
fi

# Rust stuff
if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# https://github.com/oz/tz
if [ -f $HOME/go/bin/tz ]; then
    export TZ_LIST="America/New_York,America/Los_Angeles,Europe/Paris"
fi

# OSX Specific envs
if [[ $(uname) == "Darwin" ]]; then
    # M1 specific hacks
    if [[ $(uname -p) == "arm" ]]; then
        # Stop golang progs having fun with Rosetta 2 (https://yaleman.org/post/2021/2021-01-01-apple-m1-terraform-and-golang/)
        export GODEBUG=asyncpreemptoff=1
    fi

    # Python user bin folder
    [ -d $HOME/Library/Python/3.9/bin ] && export PATH=$PATH:$HOME/Library/Python/3.9/bin

    # Homebrew
    [ -d /opt/homebrew ] && eval $(/opt/homebrew/bin/brew shellenv)
fi
