# History
mkdir -p "${XDG_STATE_HOME}/zsh"
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# Prompt
setopt PROMPT_SUBST
export PS1='%F{8}[%F{white}%n@%m%F{8}] (%F{white}%1~%F{8}) %F{yellow}$AWS_PROFILE%F{white} %#%f '
