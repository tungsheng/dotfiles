# copy ssh key
cat ~/.ssh/id_rsa.pub | ssh demo@168.58.111.0 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"

# copy ssh file
sendkey() {
    scp ~/.ssh/id_rsa $1:~/.ssh
    scp ~/.ssh/id_rsa.pub $1:~/.ssh
}
