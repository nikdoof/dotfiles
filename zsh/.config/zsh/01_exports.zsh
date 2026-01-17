# shellcheck shell=zsh
# History
mkdir -p "${XDG_STATE_HOME}/zsh"
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# Prompt
# Use starship if installed, otherwise use a simple prompt
if [ -x $(command -v starship) ]; then
    eval "$(starship init zsh)"
    export STARSHIP_CACHE="${XDG_CACHE_HOME}"/starship
else
    setopt PROMPT_SUBST
    export PS1='%F{8}[%F{white}%n@%m%F{8}] (%F{white}%1~%F{8}) %F{yellow}$AWS_PROFILE%F{white} %#%f '
fi
