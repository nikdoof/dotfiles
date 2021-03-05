#!/bin/bash
git clone https://github.com/nikdoof/dotfiles.git $HOME/.dotfiles > /dev/null
cd $HOME/.dotfiles/
for package in bin bash; do
  echo "Stowing ${package}"
  ./bin/bin/stowage $package
done
echo ""
echo "Done, either source ~/.bash_profile or restart your shell."