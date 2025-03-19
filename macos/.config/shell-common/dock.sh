# Updates the dock
function update-dock() {
    idx=1
    while read entry; do
        app_name=$(echo "$entry" | cut -d $'\t' -f 1)
        app_path=$(echo "$entry" | cut -d $'\t' -f 2)
        app_type=$(echo "$entry" | cut -d $'\t' -f 3)
        bundle_id=$(echo "$entry" | cut -d $'\t' -f 5)
        idx=$((idx+1))
        dockutil --no-restart -a "$app_path" -l "$bundle_id" > /dev/null 2>&1
        if [ "$app_type" = "persisentApps" ]; then
            dockutil --move "$app_name" -l "$bundle_id" -p $idx
        fi
    done < ~/.dotfiles/macos/.config/dockConfig.txt
    killall Dock
}
