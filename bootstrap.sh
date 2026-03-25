#!/usr/bin/env bash
set -euo pipefail

# Validate environment argument before doing any work
ENVIRONMENT="${1:-personal}"
case "$ENVIRONMENT" in
personal | work) ;;
*)
    echo "Unknown environment: ${ENVIRONMENT}"
    echo "Valid options are: personal, work"
    exit 1
    ;;
esac

# Check dependencies
if ! command -v git &>/dev/null; then
    echo "Git isn't installed."
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo "Python3 isn't installed."
    exit 1
fi

echo "Bootstrapping dotfiles for environment: ${ENVIRONMENT}"

# Clone main dotfiles (idempotent)
if [ -d "${HOME}/.dotfiles" ]; then
    echo "Main dotfiles already present, skipping clone."
else
    echo "Cloning main dotfiles repository..."
    git clone git@github.com:nikdoof/dotfiles.git "${HOME}/.dotfiles"
fi

# stowage lives inside the bin package — use it directly
# (bin/.local/bin/stowage must exist before we can stow anything else)
STOWAGE="${HOME}/.dotfiles/bin/.local/bin/stowage"
if ! [ -x "${STOWAGE}" ]; then
    echo "Stowage not found or not executable at: ${STOWAGE}"
    exit 1
fi

# Clone private dotfiles based on environment (idempotent)
case "$ENVIRONMENT" in
personal)
    PRIVATE_DIR="${HOME}/.dotfiles-private"
    PRIVATE_REPO="git@github.com:nikdoof/dotfiles-private.git"
    ;;
work)
    PRIVATE_DIR="${HOME}/.dotfiles-work"
    PRIVATE_REPO="git@github.com:nikdoof/dotfiles-work.git"
    ;;
esac

if [ -d "${PRIVATE_DIR}" ]; then
    echo "Private dotfiles already present, skipping clone."
else
    echo "Cloning private dotfiles (${ENVIRONMENT})..."
    git clone "${PRIVATE_REPO}" "${PRIVATE_DIR}"
fi

# Install common packages from main repo
"${STOWAGE}" --force install bin shell-common bash zsh ssh git gpg starship

# Install private packages (overlays common packages with secrets/local config)
"${STOWAGE}" --repository "${PRIVATE_DIR}" --force install shell-common ssh gpg

# Install platform-specific packages
if [[ "$(uname)" == "Darwin" ]]; then
    "${STOWAGE}" --force install macos zed ghostty aerospace
fi

echo ""
echo "Done! Please source ~/.zshrc or restart your shell."
