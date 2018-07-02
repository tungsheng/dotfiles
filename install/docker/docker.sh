#!/bin/bash

# switch user
su docker

# remove older docker
apt-get -y remove docker docker-engine docker.io

# setup docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg  | apt-key add -
# wget https://download.docker.com/linux/debian/gpg 
# apt-key add gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee -a /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-ce

# install docker
apt-get -y install docker-ce

# start docker
systemctl start docker

# verify docker
docker run hello-world


# remove older docker compose
rm /usr/local/bin/docker-compose

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


