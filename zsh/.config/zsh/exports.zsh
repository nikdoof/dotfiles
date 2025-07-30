# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2000
SAVEHIST=1000

# Prompt
setopt PROMPT_SUBST
export AWS_PROFILE_DISPLAY=''
export PS1='%F{8}[%F{white}%n@%m%F{8}] (%F{white}%1~%F{8}) %F{yellow}$AWS_PROFILE_DISPLAY%F{white} %#%f '
