# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# User specific environment and startup programs
export TZ=GB
export LANG=en_GB.UTF-8

# Make a sensible editor choice
editor_preferences=(nano pico vim vi)
for editor in "${editor_preferences[@]}"; do
    if [ -x "$(which $editor)" ]; then
        export EDITOR=$editor
        export VISUAL=$editor
        break
    fi
done

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

# macOS Specific envs
if [[ $(uname) == "Darwin" ]]; then
    # Python user bin folder
    [ -d $HOME/Library/Python/3.9/bin ] && export PATH=$PATH:$HOME/Library/Python/3.9/bin

    # Homebrew
    [ -d /opt/homebrew ] && eval $(/opt/homebrew/bin/brew shellenv)
fi
