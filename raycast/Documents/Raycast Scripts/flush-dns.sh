#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Flush DNS
# @raycast.mode fullOutput
# @raycast.packageName Browsing

# Optional parameters:
# @raycast.icon 💾

# Documentation:
# @raycast.author Andrew Williams
# @raycast.authorURL https://github.com/nikdoof
# @raycast.description Flushes DNS cache on macOS

sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
