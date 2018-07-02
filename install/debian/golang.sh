#!/bin/bash

# install Go
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xvf go1.10.3.linux-amd64.tar.gz
sudo mv go /usr/local

# set Go path
GOROOT=/usr/local/go
GOPATH=$HOME/go

# add Go path to profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.profile
