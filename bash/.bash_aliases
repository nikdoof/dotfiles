# OSX aliases
if [ $(uname) == "Darwin" ]; then
	alias ls="ls -FG"
else
	alias ls="ls -F --color=auto"
fi

alias tma="tmux attach"
