# Git pulls latest dotfiles
function update-dotfiles() {
    prevdir=$PWD
    if [ -d "${HOME}/.dotfiles" ]; then
        cd $HOME/.dotfiles
        git pull --rebase --autostash
    fi
    if [ -d "${HOME}/.dotfiles-private" ]; then
        cd $HOME/.dotfiles-private
        git pull --rebase --autostash
    fi
    cd $prevdir
}

function add-sshkey() {
    TIMEOUT="2h"
    NAME=$1

    if [ -z "$NAME" ]; then
        echo "Current Keys"
        ssh-add -L | cut -d" " -f 3-
    else
        if [ -f "${HOME}/.ssh/id_ed25519_${NAME}" ]; then
            ssh-add -t $TIMEOUT "${HOME}/.ssh/id_ed25519_${NAME}"
        else
            echo "No key named ${NAME} found..."
        fi
    fi
}

function _add-sshkey-completions() {
    COMPREPLY=( $(ls -1 ${HOME}/.ssh/id_*|cut -d'_' -f 3|cut -d'.' -f 1|sed 's/@//'|sort|uniq) ) 
}
complete -F _add-sshkey-completions add-sshkey

# Switch to a simple prompt for demos (thanks Mark H for the idea)
function demoprompt() {
    if [ ! -z ${OLDPS1+x} ]; then
        PS1=$OLDPS1
        unset OLDPS1
    else
        OLDPS1=$PS1
        PS1=" \$ "
        clear
    fi
}

function commit-pkm() {
    if [ -d $HOME/Documents/pkm ]; then
        prevdir=$PWD
        cd ~/Documents/pkm
        if [[ `git status --porcelain` ]]; then
            echo "Changes detected, commiting..."
            git add -A && git commit -a -m 'Manual savepoint'
        else
            echo "No changes detected"
        fi
        git fetch
        if [ $(git rev-parse main) != $(git rev-parse refs/remotes/origin/main) ]; then
            git push origin
        fi
        cd $PREVDIR
    fi
}
