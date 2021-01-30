#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Set busylight status
# @raycast.mode silent
# @raycast.packageName Browsing

# Optional parameters:
# @raycast.icon 🚦

# Documentation:
# @raycast.author Andrew Williams
# @raycast.authorURL https://github.com/nikdoof
# @raycast.description Sets your busylight status

# @raycast.argument1 { "type": "text", "placeholder": "available" }

status=$1

curl -s "http://10.101.2.167/${status}" > /dev/null 
if [[ $? -ne 0 ]]; then
    echo "Something went wrong!"
else
    echo "Done!"
fi