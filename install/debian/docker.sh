#!/bin/bash


println() {
    echo "\n"
    echo $1
    echo "...\n"
}

# remove older docker compose if exist
which docker-compose || sudo rm /usr/local/bin/docker-compose

# install docker daemon
output "Install docker daemon"
wget -qO- https://get.docker.com/ | sh

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# show docker compose version
println "Show docker-compose version"
docker-compose --version

# create deploy user
println "create deploy user"
useradd -m -s /bin/bash deploy
println "add deploy user to docker group"
usermod -aG docker deploy

println "docker successfully installed!!"

