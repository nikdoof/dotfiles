# macOS tags downloads with "com.apple.quarantine" attribute to prevent execution of downloaded files until the user explicitly allows it.
# This function removes that attribute, allowing the file to be opened without warning.
# Usage: itsok <file_path>
function itsok() {
    if [[ $(uname) == "Darwin" ]]; then
        xattr -d com.apple.quarantine $1
    else
        echo 'This only works on macOS...'
    fi
}

# Runs a brew bundle check and installs missing packages
# Usage: update-brewfile
function update-brewfile() {
    brew bundle check --file "$HOME/.config/Brewfile" || brew bundle --cleanup -f --file "$HOME/.config/Brewfile"
}

# Updates the macOS Dock based on a configuration file
# The configuration file should be in the format:
# app_name<TAB>app_path<TAB>app_type
# where app_type can be "persisentApps" or "other"
# Usage: update-dock
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
