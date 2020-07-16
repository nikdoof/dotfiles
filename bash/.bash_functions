
# Git pulls latest dotfiles
function update-dotfiles() {
    if [ -d "${HOME}/.dotfiles" ]; then
        cd $HOME/.dotfiles
        git pull --rebase --autostash
    fi
    if [ -d "${HOME}/.dotfiles-private" ]; then
        cd $HOME/.dotfiles-private
        git pull --rebase --autostash
    fi
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