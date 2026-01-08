# shellcheck shell=bash

# Flushes the DNS cache on macOS
function flushdns() {
    if [[ $(uname) == "Darwin" ]]; then
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
        echo 'DNS cache flushed.'
    else
        echo 'This only works on macOS...'
    fi
}

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
    if ! [ -x $(command -v brew) ]; then
        echo "Homebrew is not installed. Please install it first."
        return 1
    fi
    brew bundle check --global || brew bundle --cleanup -f --global
}

# Updates the macOS Dock based on a configuration file
# The configuration file should be in the format:
# app_name<TAB>app_path<TAB>app_type
# where app_type can be "persisentApps" or "other"
# Usage: update-dock

function update-dock() {
    if ! [ -x $(command -v dockutil) ]; then
        echo "dockutil is not installed. Please install it via Homebrew: brew install dockutil"
        return 1
    fi
    idx=1
    while read entry; do
        app_name=$(echo "$entry" | cut -d $'\t' -f 1)
        app_path=$(echo "$entry" | cut -d $'\t' -f 2)
        app_type=$(echo "$entry" | cut -d $'\t' -f 3)
        idx=$((idx + 1))
        dockutil --no-restart -a "$app_path" >/dev/null 2>&1
        if [ "$app_type" = "persisentApps" ]; then
            dockutil --move "$app_name" -p $idx
        fi
    done <~/.dotfiles/macos/.config/dotfiles/dockConfig.txt
    killall Dock
}

# Function to switch the macOS desktop wallpaper from the CLI, using fzf.
function set_wallpaper() {
    local wallpaper_dir="$HOME/.config/wallpaper"
    local wallpaper_path=""

    # If no argument provided, use fzf to select from wallpaper directory
    if [ $# -eq 0 ]; then
        if ! [ -x $(command -v fzf) ]; then
            echo "fzf is not installed"
            return 1
        fi

        if [ ! -d "$wallpaper_dir" ]; then
            echo "Wallpaper directory not found: $wallpaper_dir"
            return 1
        fi

        wallpaper_path=$(find "$wallpaper_dir" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.heic" \) | fzf --preview 'fzf-preview.sh {}' --height 40%)

        if [ -z "$wallpaper_path" ]; then
            echo "No wallpaper selected."
            return 1
        fi
    else
        # Check if argument is a full path or relative filename
        if [[ "$1" == /* ]]; then
            # Full path provided
            wallpaper_path="$1"
        else
            # Relative filename, assume it's in wallpaper directory
            wallpaper_path="$wallpaper_dir/$1"
        fi
    fi

    # Validate file exists
    if [ ! -f "$wallpaper_path" ]; then
        echo "File not found: $wallpaper_path"
        return 1
    fi

    # Check if file is a valid image format (PNG, JPEG, or HEIC)
    local file_type=$(file -b --mime-type "$wallpaper_path")
    if [[ "$file_type" != "image/png" && "$file_type" != "image/jpeg" && "$file_type" != "image/heic" ]]; then
        echo "Unsupported file type: $file_type. Only PNG, JPEG, and HEIC are supported."
        return 1
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        # Set the wallpaper using AppleScript
        osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper_path\""

        if [ $? -eq 0 ]; then
            echo "Wallpaper set successfully: $wallpaper_path"
        else
            echo "Failed to set wallpaper: $wallpaper_path"
            return 1
        fi
    else
        echo "This function only works on macOS at the moment."
        return 1
    fi
}

# Use Tailscale binary if installed via app
if [ -d "/Applications/Tailscale.app" ]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias ts="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# Open the finder to a specified path or to current directory.
# https://natelandau.com/my-mac-os-zsh-profile/
f() {
    open -a "Finder" "${1:-.}"
}

# Search for a file using macOS Spotlight
# https://natelandau.com/my-mac-os-zsh-profile/
spotlight() {
    mdfind "kMDItemDisplayName == '${1}'wc"
}
