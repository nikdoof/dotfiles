# OSX aliases
if [[ $(uname) == "Darwin" ]]; then
    alias ls="ls -FG"
    alias code="code-insiders"
    alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
else
    alias ls="ls -F --color=auto"
fi

alias t='(tmux has-session 2>/dev/null && tmux attach) || (tmux new-session)'
alias tma="tmux attach"
alias last="last | head"
alias dp="demoprompt"
