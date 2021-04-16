#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Commit PKM files to GitHub
# @raycast.mode fullOutput
# @raycast.packageName Browsing

# Optional parameters:
# @raycast.icon 💾

# Documentation:
# @raycast.author Andrew Williams
# @raycast.authorURL https://github.com/nikdoof
# @raycast.description Pushes PKM files to GitHub repository

source $HOME/.config/shell-common/functions.sh
commit-pkm
