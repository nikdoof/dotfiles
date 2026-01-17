# shellcheck shell=bash
# Override application locations to fix XDG
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export TLDR_CACHE_DIR="$XDG_CACHE_HOME"/tldr
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"
