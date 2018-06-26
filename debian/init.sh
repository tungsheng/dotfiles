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
if type -p zsh > /dev/null; then
    echo "zsh Installed" >> $log_file
else
    echo "zsh FAILED TO INSTALL!!!" >> $log_file
fi

echo -ne "Installing tmux...\n"
sudo apt-get -y install tmux
if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi

echo -ne "Installing utils...\n"
sudo apt-get -y install git tig 
sudo apt-get -y install whois
sudo apt-get -y install curl
if type -p curl > /dev/null; then
    echo "curl Installed" >> $log_file
else
    echo "crul FAILED TO INSTALL!!!" >> $log_file
fi

sudo apt-get install silversearcher-ag
if type -p ag > /dev/null; then
    echo "Silver searcher Installed" >> $log_file
else
    echo "Silver searcher FAILED TO INSTALL!!!" >> $log_file
fi

sudo apt-get -y install python-pip
if type -p pip > /dev/null; then
    echo "pip Installed" >> $log_file
else
    echo "pip FAILED TO INSTALL!!!" >> $log_file
fi

