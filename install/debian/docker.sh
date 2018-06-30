# switch user
su docker

# remove older docker
sudo apt-get -y remove docker docker-engine docker.io

# setup docker repository
# wget --quiet --output-document - https://download.docker.com/linux/debian/gpg  | sudo apt-key add -
wget https://download.docker.com/linux/debian/gpg 
sudo apt-key add gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee -a /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-cache policy docker-ce

# install docker
sudo apt-get -y install docker-ce

# start docker
sudo systemctl start docker

# verify docker
sudo docker run hello-world


