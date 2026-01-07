# shellcheck shell=bash

# XDG Base Directories
# Empty variables would be set to defaults, but we define them explicitly
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

# https://github.com/oz/tz
if [ -x "$(command -v tz)" ]; then
    export TZ_LIST="Europe/Dublin,Portwest HQ;America/New_York,WDW;America/Los_Angeles,DLR;Europe/Paris,DLP"
fi
