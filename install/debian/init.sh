#!/bin/bash
log_file=$HOME/install_progress_log.txt

echo -ne "Initiating...\n"
sudo apt-get -y update

echo -ne "Installing utils...\n"
sudo apt-get -y install git tig 
sudo apt-get -y install make locate
sudo apt-get -y install whois
sudo apt-get -y install curl wget
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install python-pip
sudo apt-get -y install openssh-server
sudo apt-get -y install apt-transport-https ca-certificates software-properties-common

echo -ne "Installing bash-it...\n"
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it

echo -ne "Installing neovim...\n"
sudo apt-get -y install neovim

echo -ne "Installing tmux...\n"
sudo apt-get -y install tmux
if hash tmux 2>/dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi

# source $DOTFILES/install/debian/nvm.sh
# source $DOTFILES/install/debian/golang.sh
# source $DOTFILES/install/debian/docker.sh
source $DOTFILES/install/debian/link.sh

