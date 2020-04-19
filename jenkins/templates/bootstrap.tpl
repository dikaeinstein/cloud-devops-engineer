#!/bin/bash

apt update
# Install Java
apt install -y default-jdk

# Download Jenkins package.
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

apt update
# Install Jenkins
apt install -y jenkins=${jenkins_version}

# Start the Jenkins server
systemctl start jenkins
