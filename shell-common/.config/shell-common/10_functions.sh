# shellcheck shell=bash

# Git pulls latest dotfiles
function update-dotfiles() {
    local dotfiles_dirs=(".dotfiles" ".dotfiles-private" ".dotfiles-work")

    for dir in "${dotfiles_dirs[@]}"; do
        if [[ -d "${HOME}/$dir" ]]; then
            if [[ ! -d "${HOME}/$dir/.git" ]]; then
                echo "Warning: $dir exists but is not a git repository. Skipping..."
                continue
            fi

            echo "Updating $dir..."
            if ! (cd "${HOME}/$dir" && git pull --rebase --autostash); then
                echo "Error: Failed to update $dir"
            fi
        fi
    done
}

# Wrapper around ssh-add to easily add SSH keys with a timeout
# Usage: add-sshkey [key_name]
function add-sshkey() {
    TIMEOUT="8h"
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
    if [ -n "${OLDPS1+x}" ]; then
        PS1=$OLDPS1
        unset OLDPS1
    else
        OLDPS1=$PS1
        PS1=" %# "
        clear
    fi
}
