
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
    TIMEOUT="1h"
    NAME=$1

    if [ -z "$NAME" ]; then
        echo "Current Keys"
        ssh-add -L
    else
        if [ -f "~/.ssh/id_ed25519_${NAME}" ]; then
            ssh-add -t $TIMEOUT "~/.ssh/id_ed25519_${NAME}"
        else
            echo "No key named ${NAME} found..."
        fi
    fi
}

# Switch to a simple prompt for demos (thanks Mark H for the idea)
function demoprompt() {
    if [ ! -z ${OLDPS1+x} ]; then
        PS1=$OLDPS1
        unset OLDPS1
    else
        OLDPS1=$PS1
        PS1="\$ "
        clear
    fi
}