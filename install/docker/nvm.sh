#!/bin/bash

# install packaegs
apt-get install -y build-essential and libssl-dev

#install nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

nvm install node
nvm use node


# Install yarn
curl -o- -L https://yarnpkg.com/install.sh | bash
