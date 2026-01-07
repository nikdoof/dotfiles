# History
mkdir -p "${XDG_STATE_HOME}"/bash
export HISTFILE="${XDG_STATE_HOME}"/bash/history

# Prompt
export PS1="\[\e[0;90m\][\[\e[0;37m\]\u\[\e[0;37m\]@\[\e[0;37m\]\H\[\e[0;90m\]] \[\e[0;90m\](\[\e[0;37m\]\W\[\e[0;90m\]) \[\e[0;37m\]\$\[\e[0m\] "
