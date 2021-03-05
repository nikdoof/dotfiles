#!/bin/bash

which git > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Git isn't installed."
  exit
fi

# Clone dotfiles
git clone https://github.com/nikdoof/dotfiles.git $HOME/.dotfiles > /dev/null

# Clean bash files
for file in .bash_profile .bashrc .bash_logout; do
  if [ -e $file ]; then
    rm -f $file
  fi
done

cd $HOME/.dotfiles/

# Stow the default packages
for package in bin bash; do
  echo "Stowing ${package}"
  ./bin/bin/stowage $package
done
echo ""
echo "Done, either source ~/.bash_profile or restart your shell."