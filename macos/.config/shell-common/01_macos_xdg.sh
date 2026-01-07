# shellcheck shell=bash

# Override XDG cache location for macOS to use the standard Library/Caches directory
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_RUNTIME_DIR="${TMPDIR}runtime-${UID}"
