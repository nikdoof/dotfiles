# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source shell common
for f in ~/.config/shell-common/*.sh; do 
    source $f; 
done

# Source bash specific files
for f in ~/.config/bash/*.bash; do 
    source $f; 
done
