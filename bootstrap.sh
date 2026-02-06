#!/usr/bin/env bash
set -e

# Check if git is installed
if ! [ -x $(command -v git) ]; then
    echo "Git isn't installed."
    exit 1
fi

# Check if we have a Python3 installation
if ! [ -x $(command -v python3) ]; then
    echo "Python3 isn't installed."
    exit 1
fi

# Set environment, default to 'personal'
ENVIRONMENT="${1:-personal}"
echo "Bootstrapping dotfiles for environment: ${ENVIRONMENT}"

# Clone dotfiles
echo "Cloning main dotfiles repository..."
git clone git@github.com:nikdoof/dotfiles.git "${HOME}/.dotfiles" >/dev/null

# Validate that the stowage command exists
STOWAGE="$HOME/.dotfiles/bin/.local/bin/stowage"
if ! [ -f "$STOWAGE" ]; then
    echo "Stowage not found at in the expected location: ${STOWAGE}"
    exit 1
fi

# Clone private dotfiles based on environment
case "$ENVIRONMENT" in
personal)
    echo "Cloning personal dotfiles..."
    git clone git@github.com:nikdoof/dotfiles-private.git "${HOME}/.dotfiles-private" >/dev/null
    ;;
work)
    echo "Cloning work dotfiles..."
    git clone git@github.com:nikdoof/dotfiles-work.git "${HOME}/.dotfiles-work" >/dev/null
    ;;
*)
    echo "Unknown environment: ${ENVIRONMENT}"
    echo "Valid options are: personal, work"
    exit 1
    ;;
esac

# Add the default packages
$STOWAGE --force install bin shell-common bash zsh ssh

# If we're on macOS, add macos-specific packages
if [[ "$(uname)" == "Darwin" ]]; then
    $STOWAGE --force install macos
fi

echo ""
echo "Done! Please either source ~/.bash_profile / ~/.zshrc or restart your shell."
