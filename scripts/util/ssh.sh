# copy ssh key
cat ~/.ssh/id_rsa.pub | ssh demo@168.58.111.0 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"

# copy ssh file
scp ~/.ssh/id_rsa root@206.189.148.67:~/.ssh
scp ~/.ssh/id_rsa.pub root@206.189.148.67:~/.ssh
