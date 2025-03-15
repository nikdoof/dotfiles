# Updates Homebrew installation from the Brewfile
function update-brewfile() {
    brew bundle check --file ~/.config/Brewfile || brew bundle --cleanup -f --file ~/.config/Brewfile
}
