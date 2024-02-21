#!/bin/bash

# variables
version=1.11.1

# install Go
wget "https://dl.google.com/go/go$version.linux-amd64.tar.gz"
tar -xvf "go$version.linux-amd64.tar.gz"
sudo mv go /usr/local

# set Go path
GOROOT=/usr/local/go
GOPATH=$HOME/go

# add Go path to profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.profile
