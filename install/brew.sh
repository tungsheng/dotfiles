#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo -e "\n\nInstalling homebrew packages..."
echo "=============================="

# cli tools
brew install ack
brew install the_silver_searcher
brew install tree
brew install wget
brew install watchman

# development server setup
brew install nginx
brew install dnsmasq

# development tools
brew install git
brew install hub
brew install fzf
brew install reattach-to-user-namespace
brew install tmux
brew install zsh
brew install z
brew install highlight
brew install nvm

# install neovim
brew install neovim/neovim/neovim

exit 0
