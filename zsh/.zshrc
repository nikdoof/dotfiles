# shellcheck shell=zsh
# Source shell common
for f in ~/.config/shell-common/*.sh(.N); do
    source "$f"
done

# Source zsh specific files
for f in ~/.config/zsh/*.zsh(.N); do
    source "$f"
done
