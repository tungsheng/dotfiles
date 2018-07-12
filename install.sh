#!/bin/bash

export DOT=dotfiles
export DOTBACK=dotfiles-backup
export DOTFILES=$HOME/$DOT
export BACKUP_DIR=$HOME/$DOTBACK

echo "Installing dotfiles..."
# git pull origin master

[ -d "${HOME}/bin" ] || mkdir ~/bin

echo $(uname)
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"
    source $DOTFILES/install/osx/brew.sh
    source $DOTFILES/install/osx/osx.sh
    source $DOTFILES/install/osx/nvm.sh
    source $DOTFILES/install/osx/shlink.sh
    source $DOTFILES/install/osx/link.sh
elif [ "$(uname)" == "Linux" ]; then
    echo -e "\n\nRunning on Linux"
    source $DOTFILES/install/debian/init.sh
    source $DOTFILES/install/debian/link.sh
    # source install/debian/caddy.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "Configuring zsh as default shell"
chsh -s $(which zsh)


echo "Done."
