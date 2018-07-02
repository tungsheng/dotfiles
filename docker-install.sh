#!/bin/bash

export DOT=dotfiles
export DOTBACK=dotfiles-backup
export DOTFILES="$PWD"
export BACKUP_DIR="$(dirname "$DOTFILES")/$DOTBACK"


echo "Installing dotfiles..."
git pull origin master

echo "Initializing submodule(s)"
git submodule update --init --recursive

[ -d "${HOME}/bin" ] || mkdir ~/bin

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
    source install/docker/init.sh
    source install/docker/link.sh
    # source install/debian/caddy.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "Configuring zsh as default shell"
chsh -s $(which zsh)


echo "Done."
