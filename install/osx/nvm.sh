#!/bin/sh

echo -e "\n\nInstalling Node (from nvm)"
echo "=============================="

# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash


# Install node
nvm install node
