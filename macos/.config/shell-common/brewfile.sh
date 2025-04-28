# Updates Homebrew installation from the Brewfile
function update-brewfile() {
    brew bundle check --file "$HOME/.config/Brewfile" || brew bundle --cleanup -f --file "$HOME/.config/Brewfile"
}
