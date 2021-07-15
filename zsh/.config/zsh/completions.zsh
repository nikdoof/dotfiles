autoload -Uz compinit
compinit

function _add-sshkey() {
    local -a identities

    # check for .ssh folder presence
    if [[ ! -d $HOME/.ssh ]]; then
        return
    fi
    for id in $HOME/.ssh/id_ed25519_*; do
        name=$(basename $id | cut -d'_' -f3 | cut -d'.' -f1)
        [[ ${id:-3} != 'pub' ]] && identities+=$name
    done

    compadd $identities
}
compdef _add-sshkey add-sshkey
