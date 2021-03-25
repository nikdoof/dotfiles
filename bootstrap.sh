#!/bin/bash

which git > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Git isn't installed."
  exit
fi

# Clone dotfiles
git clone https://github.com/nikdoof/dotfiles.git $HOME/.dotfiles > /dev/null

# Stow the default packages
for package in bin shell-common bash zsh; do
  echo "Stowing ${package}"
  $HOME/.dotfiles/bin/bin/stowage --clobber install $package
done
echo ""
echo "Done, either source ~/.bash_profile / ~/.zshrc or restart your shell."