# Tag the file as OK to run
function itsok() {
    if [[ $(uname) == "Darwin" ]]; then
        xattr -d com.apple.quarantine $1
    else
        echo 'This only works on macOS...'
    fi
}

# Updates Homebrew installation from the Brewfile
function update-brewfile() {
    brew bundle check --file "$HOME/.config/Brewfile" || brew bundle --cleanup -f --file "$HOME/.config/Brewfile"
}

# Updates the dock
function update-dock() {
    idx=1
    while read entry; do
        app_name=$(echo "$entry" | cut -d $'\t' -f 1)
        app_path=$(echo "$entry" | cut -d $'\t' -f 2)
        app_type=$(echo "$entry" | cut -d $'\t' -f 3)
        idx=$((idx+1))
        dockutil --no-restart -a "$app_path" > /dev/null 2>&1
        if [ "$app_type" = "persisentApps" ]; then
            dockutil --move "$app_name" -p $idx
        fi
    done < ~/.dotfiles/macos/.config/dockConfig.txt
    killall Dock
}
