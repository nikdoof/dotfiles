#!/usr/bin/env bash
set -e

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Git isn't installed."
    exit 1
fi

# Set environment, default to 'personal'
ENVIRONMENT="${1:-personal}"
echo "Bootstrapping dotfiles for environment: $ENVIRONMENT"

# Clone dotfiles
echo "Cloning main dotfiles repository..."
git clone git@github.com:nikdoof/dotfiles.git "$HOME/.dotfiles" >/dev/null

# Clone private dotfiles based on environment
case "$ENVIRONMENT" in
personal)
    echo "Cloning personal dotfiles..."
    git clone git@github.com:nikdoof/dotfiles-private.git "$HOME/.dotfiles-private" >/dev/null
    ;;
work)
    echo "Cloning work dotfiles..."
    git clone git@github.com:nikdoof/dotfiles-work.git "$HOME/.dotfiles-work" >/dev/null
    ;;
*)
    echo "Unknown environment: $ENVIRONMENT"
    echo "Valid options are: personal, work"
    exit 1
    ;;
esac

# Add the default packages
for package in bin shell-common bash zsh ssh; do
    echo "Stowing public package: $package"
    "$HOME/.dotfiles/bin/.local/bin/stowage" --clobber install "$package"
done

echo ""
echo "Done! Please either source ~/.bash_profile / ~/.zshrc or restart your shell."
