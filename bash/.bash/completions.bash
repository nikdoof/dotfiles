# SSH completion based on ssh config
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config* | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
