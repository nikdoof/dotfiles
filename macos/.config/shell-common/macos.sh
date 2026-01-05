# shellcheck shell=bash

# Override XDG cache location for macOS to use the standard Library/Caches directory
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_RUNTIME_DIR="${TMPDIR}runtime-${UID}"

# Configure Homebrew environment
export HOMEBREW_NO_ENV_HINTS=1
[ -d /opt/homebrew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Flushes the DNS cache on macOS
function flushdns() {
    if [[ $(uname) == "Darwin" ]]; then
        sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo 'DNS cache flushed.'
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
    brew bundle check --global || brew bundle --cleanup -f --global
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
    done < ~/.dotfiles/macos/.config/dotfiles/dockConfig.txt
    killall Dock
}

# Fuzzy find and focus a window using aerospace and fzf
if [ -x "$(command -v aerospace)" ] && [ -x "$(command -v fzf)" ]; then
    function ff() {
        aerospace list-windows --all | fzf --height 40% --layout=reverse --border --ansi | awk '{print $1}' | xargs -I {} aerospace focus --window-id {}
    }
fi

# Detect Zed installation in common locations
for zed_path in "$HOME/Applications/Zed.app" "/Applications/Zed.app"; do
    if [ -d "$zed_path" ]; then
        alias zed="$zed_path/Contents/MacOS/cli"
        break
    fi
done

# Use Tailscale binary if installed via app
if [ -d "/Applications/Tailscale.app" ]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias ts="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# Standard QoL stuff
alias ls="ls -FG"
