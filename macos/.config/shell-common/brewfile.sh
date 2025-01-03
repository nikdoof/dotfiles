# Updates Homebrew installation from the Brewfile
function update-brewfile() {
    brew bundle check --file ~/.config/Brewfile && brew bundle --file ~/.config/Brewfile
}
