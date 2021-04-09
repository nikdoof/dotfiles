# Source shell common
for f in ~/.config/shell-common/*.sh; do 
    source $f; 
done

# Source zsh specific files
for f in ~/.config/zsh/*.zsh; do 
    source $f; 
done
