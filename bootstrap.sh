#!/bin/bash
git clone git@github.com:nikdoof/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles/
for package in "bin bash"; do
  ./bin/bin/stowage $package
done
