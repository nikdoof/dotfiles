# shellcheck shell=bash

# Configure Homebrew environment
if [ -x /opt/homebrew/bin/brew ]; then
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
