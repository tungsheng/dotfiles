#!/bin/bash
log_file=$HOME/install_progress_log.txt

echo -ne "Initiating...\n"
sudo apt-get update
sudo apt-get -y update
sudo apt-get -y install openssh-server sudo

echo -ne "Installing tmux...\n"
sudo apt-get install tmux

echo -ne "Installing zsh...\n"
sudo apt-get -y install zsh

echo -ne "Installing zplug...\n"
hash zplug 2>/dev/null || git clone https://github.com/zplug/zplug $HOME/.zplug 

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
sudo apt-get -y install make locate
sudo apt-get -y install whois
sudo apt-get -y install curl wget
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install python-pip
sudo apt-get -y install apt-transport-https ca-certificates software-properties-common

# neovim
echo -ne "Installing neovim...\n"
sudo apt-get install neovim
# apt-get install python-neovim
# apt-get install python3-neovim

# download z.sh (https://github.com/rupa/z)
echo "Install z...\n"
[ -f "${HOME}/z.sh" ] && rm -rf ${HOME}/z.sh
curl -L "https://raw.githubusercontent.com/rupa/z/master/z.sh" -o ~/z.sh
sudo chmod +x ~/z.sh

echo "Install color...\n"
tic $DOTFILES/color/xterm-256color-italic.terminfo
tic $DOTFILES/color/tmux-256color-italic.terminfo

source $DOTFILES/install/debian/nvm.sh
source $DOTFILES/install/debian/golang.sh
# source $DOTFILES/install/debian/adduser.sh
# source docker.sh
# source caddy.sh

