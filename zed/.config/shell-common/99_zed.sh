# Zed specific shell configuration

# Rather than installing or linking the Zed CLI, we define a function that
# locates the Zed application and invokes its CLI directly.
function zed() {
    for zed_path in "$HOME/Applications/Zed.app" "/Applications/Zed.app"; do
        if [ -d "$zed_path" ]; then
            "$zed_path/Contents/MacOS/cli" "$@"
            return
        fi
    done
    echo "Zed application not found in common locations."
    return 1
}
