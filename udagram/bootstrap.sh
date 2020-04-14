#!/bin/bash

apt-get update -y

apt-get install unzip awscli -y
apt-get install apache2 -y

systemctl start apache2.service

cd /var/www/html
aws s3 cp s3://udacity-demo-1/udacity.zip .
unzip -o udacity.zip

echo "Done :)"
