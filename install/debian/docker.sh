#!/bin/bash

# switch user
su docker

# remove older docker
sudo apt-get -y remove docker docker-engine docker.io

# setup docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg  | sudo apt-key add -
# wget https://download.docker.com/linux/debian/gpg 
# sudo apt-key add gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-cache policy docker-ce

# install docker
sudo apt-get -y install docker-ce

# start docker
sudo systemctl start docker

# verify docker
sudo docker run hello-world


# remove older docker compose
sudo rm /usr/local/bin/docker-compose

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


