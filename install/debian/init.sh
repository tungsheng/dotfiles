#!/bin/bash
log_file=~/install_progress_log.txt

echo -ne "Initiating...\n"
sudo apt-get update
sudo apt-get -y update
sudo apt-get -y install openssh-server sudo

echo -ne "Installing neovim...\n"
sudo apt-get install neovim
# sudo apt-get install python-neovim
# sudo apt-get install python3-neovim

echo -ne "Installing zsh...\n"
sudo apt-get -y install zsh
sudo apt-get install zsh-syntax-highlighting
if hash zsh 2>/dev/null; then
    echo "zsh Installed" >> $log_file
else
    echo "zsh FAILED TO INSTALL!!!" >> $log_file
fi

echo -ne "Installing tmux...\n"
sudo apt-get -y install tmux
if hash tmux 2>/dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi

echo -ne "Installing utils...\n"
sudo apt-get -y install git tig 
sudo apt-get -y install whois
sudo apt-get -y install curl
sudo apt-get -y install wget
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install python-pip
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common


source adduser.sh
source golang.sh
source caddy.sh
source docker.sh

