# Git pulls latest dotfiles
function update-dotfiles() {
    prevdir=$PWD
    for dir in "${HOME}/.dotfiles" "${HOME}/.dotfiles-private" "${HOME}/.dotfiles-work"; do
        if [ -d "$dir" ]; then
            cd "$dir"
            git pull --rebase --autostash
        fi
    done
    cd "$prevdir"
}

# Wrapper around ssh-add to ease usage and also ensure basic timeouts
function add-sshkey() {
    TIMEOUT="2h"
    NAME=$1

    if [ -z "$NAME" ]; then
        echo "Current Agent Keys"
        ssh-add -L | cut -d" " -f 3-
    else
        if [ -f "${HOME}/.ssh/id_ed25519_${NAME}" ]; then
            ssh-add -t $TIMEOUT "${HOME}/.ssh/id_ed25519_${NAME}"
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
        PS1=" %# "
        clear
    fi
}
