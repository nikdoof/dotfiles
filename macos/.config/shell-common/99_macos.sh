# shellcheck shell=bash

# Configure Homebrew environment
if [ -d /opt/homebrew ]; then
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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

# Use Tailscale binary if installed via app
if [ -d "/Applications/Tailscale.app" ]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias ts="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# Standard QoL stuff
alias ls="ls -FG"
