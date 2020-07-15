#!/bin/bash

# Install Java
apt update
apt install -y default-jdk

# Download Jenkins package.
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
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

# Install aws-cli
apt update
pip3 install awscli --upgrade --user

# Install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# Install Ansible
# apt update
# apt install -y software-properties-common
# apt-add-repository --yes --update ppa:ansible/ansible
# apt update
# apt install -y ansible

# sudo apt install -y python3-pip
# pip install boto
