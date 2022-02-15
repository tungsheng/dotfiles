#!/bin/bash

export DOTFILES=$HOME/dotfiles

echo "Installing dotfiles..."

echo "Installing colors..."
tic -x color/xterm-256color-italic.terminfo
tic -x color/tmux-256color-italic.terminfo

[ -d "${HOME}/bin" ] || mkdir ~/bin

echo $(uname)
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"
    source $DOTFILES/install/osx/brew.sh
    source $DOTFILES/install/osx/link.sh
    source $DOTFILES/install/osx/nvim.sh
elif [ "$(uname)" == "Linux" ]; then
    # TODO: need hardening
    echo -e "\n\nRunning on Linux"
    source $DOTFILES/install/debian/init.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "install vim jellybean"
mkdir -p ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# echo "Configuring zsh as default shell"
# chsh -s $(which zsh)

echo "Done."
