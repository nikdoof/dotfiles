# Zed specific shell configuration

# Detect Zed installation in common locations
for zed_path in "$HOME/Applications/Zed.app" "/Applications/Zed.app"; do
    if [ -d "$zed_path" ]; then
        alias zed="$zed_path/Contents/MacOS/cli"
        break
    fi
done
