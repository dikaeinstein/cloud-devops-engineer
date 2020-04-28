#!/bin/bash

# Install Java
apt update
apt install -y default-jdk

# Download Jenkins package.
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list'
add-apt-repository universe

# Install Jenkins
apt update
apt install -y jenkins

# Start the Jenkins server
systemctl start jenkins

# Install Tidy
wget -q https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-5.4.0-64bit.deb
dpkg -i tidy-5.4.0-64bit.deb
rm tidy-5.4.0-64bit.deb

# Install Ansible
# apt update
# apt install -y software-properties-common
# apt-add-repository --yes --update ppa:ansible/ansible
# apt update
# apt install -y ansible

# sudo apt install -y python3-pip
# pip install boto
