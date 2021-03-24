#!/bin/bash

which git > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Git isn't installed."
  exit
fi

# Clone dotfiles
git clone https://github.com/nikdoof/dotfiles.git $HOME/.dotfiles > /dev/null

# Clean bash files
for file in .bash_profile .bashrc .bash_logout .zshrc; do
  if [ -e $file ]; then
    rm -f $file
  fi
done

# Stow the default packages
for package in bin shell-common bash zsh; do
  echo "Stowing ${package}"
  $HOME/.dotfiles/bin/bin/stowage install $package
done
echo ""
echo "Done, either source ~/.bash_profile / ~/.zshrc or restart your shell."