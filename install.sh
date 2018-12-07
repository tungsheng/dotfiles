#!/bin/bash

export DOT=dotfiles
export DOTBACK=dotfiles-backup
export DOTFILES=$HOME/$DOT
export BACKUP_DIR=$HOME/$DOTBACK

echo "Installing dotfiles..."
# git pull origin master

echo "Installing colors..."
tic -x color/xterm-256color-italic.terminfo
tic -x color/tmux-256color.terminfo

[ -d "${HOME}/bin" ] || mkdir ~/bin

echo $(uname)
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"
    source $DOTFILES/install/osx/brew.sh
    # source $DOTFILES/install/osx/osx.sh
    source $DOTFILES/install/osx/nvm.sh
    source $DOTFILES/install/osx/shlink.sh
    source $DOTFILES/install/osx/link.sh
elif [ "$(uname)" == "Linux" ]; then
    # TODO: need hardening
    echo -e "\n\nRunning on Linux"
    source $DOTFILES/install/debian/init.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "Configuring zsh as default shell"
chsh -s $(which zsh)


echo "Done."
