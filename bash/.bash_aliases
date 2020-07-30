# OSX aliases
if [ $(uname) == "Darwin" ]; then
	alias ls="ls -FG"
else
	alias ls="ls -F --color=auto"
fi

alias t='(tmux has-session 2>/dev/null && tmux attach) || (tmux new-session)'
alias tma="tmux attach"
alias last="last | head"
