#!/bin/bash

echo "Installing dotfiles"

echo "Initializing submodule(s)"
git submodule update --init --recursive

echo $(uname)
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"
    source install/osx/brew.sh
    source install/osx/osx.sh
    source install/osx/nvm.sh
    source install/osx/shlink.sh
    source install/osx/link.sh
elif [ "$(uname)" == "Linux" ]; then
    echo -e "\n\nRunning on Linux"
    source install/debian/init.sh
    source install/debian/link.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "Configuring zsh as default shell"
chsh -s $(which zsh)


echo "Done."
