#!/bin/bash

# Install and start code-server
wget -q https://github.com/cdr/code-server/releases/download/3.1.1/code-server-3.1.1-linux-x86_64.tar.gz
tar -xzf code-server-3.1.1-linux-x86_64.tar.gz

# Install nginx and pip3
apt update
apt install -y nginx
apt install -y python3-pip

# Install aws-cli
pip3 install awscli --upgrade --user
