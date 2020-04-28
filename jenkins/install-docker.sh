#!/bin/bash

# Install Docker
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Verify GPG key:
sudo apt-key fingerprint 0EBFCD88
# Set up the stable repository
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
# Update the apt package index, and install the latest version of Docker Engine and containerd
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Add your user and the jenkins user to the docker group
sudo usermod -aG docker ${USER}
sudo usermod -aG docker jenkins
