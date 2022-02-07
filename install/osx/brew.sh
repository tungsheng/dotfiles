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
# brew install nginx
# brew install dnsmasq

# development tools
brew install git
brew install git-lfs
brew install hub
brew install fzf
brew install reattach-to-user-namespace
brew install tmux
brew install ctags
brew install z
brew install zsh
brew install highlight
brew install ansible
brew install vagrant

# install neovim
# brew install neovim
brew install vim

echo -ne "Installing zplug...\n"
hash zplug 2>/dev/null || git clone https://github.com/zplug/zplug $HOME/.zplug
