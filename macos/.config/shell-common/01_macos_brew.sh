# Configure Homebrew environment
if [ -x /opt/homebrew/bin/brew ]; then
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
