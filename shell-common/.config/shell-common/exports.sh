# shellcheck shell=bash
# User specific environment

# XDG Base Directories
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="${TMPDIR}/runtime-${UID}"
export XDG_STATE_HOME="$HOME/.local/state"

PATH="$XDG_BIN_HOME:$HOME/bin:$PATH"
export PATH

# User specific environment and startup programs
export TZ=GB
export LANG=en_GB.UTF-8

# Make a sensible editor choice
editor_preferences=(nano pico vim vi)
for editor in "${editor_preferences[@]}"; do
    if [ -x "$(command -v $editor)" ]; then
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

# Python stuff
export POETRY_VIRTUALENVS_IN_PROJECT=true

# Rust stuff
if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# https://github.com/oz/tz
if [ -x "$(command -v tz)" ]; then
    export TZ_LIST="Europe/Dublin,Portwest HQ;America/New_York,WDW;America/Los_Angeles,DLR;Europe/Paris,DLP"
fi
