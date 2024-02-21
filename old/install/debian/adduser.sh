#!/bin/bash
log_file=~/install_progress_log.txt

# add group
sudo groupadd deploy
sudo groupadd docker

# add deploy user
useradd -G deploy,docker -s /bin/zsh -c "User for deploy" deploy

# update password
passwd deploy

# add deploy user
useradd -G docker -s /bin/zsh -c "User for docker" docker

# update password
passwd docker
