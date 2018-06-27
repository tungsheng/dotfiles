#!/bin/bash

echo "Installing dotfiles"

echo "Initializing submodule(s)"
git submodule update --init --recursive

echo $(uname)
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"
    source install/brew.sh
    source install/osx.sh
    source install/nvm.sh
    source install/zsh.sh
    source install/shlink.sh
    source install/link.sh
elif [ "$(uname)" == "Linux" ]; then
    echo -e "\n\nRunning on Linux"
    source install/debian/init.sh
    source install/debian/link.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Installing zplug plugin manager"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh


echo "Done."
