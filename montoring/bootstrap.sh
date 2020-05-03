#!/bin/bash

apt update
apt install -y ansible python3-pip

pip3 install tox

# Install Prometheus with ansible
git clone https://github.com/cloudalchemy/ansible-prometheus.git

cd ansible-prometheus
mkdir -p roles/cloudalchemy.prometheus
mv defaults/ handlers/ meta/ molecule/ tasks/ templates/ vars/ roles/cloudalchemy.prometheus/

# setup main playbook
tee -a main.yaml << EOL
---
- hosts: all
  roles:
  - cloudalchemy.prometheus
  vars:
    prometheus_targets:
      node:
      - targets:
        - localhost:9100
        labels:
          env: demosite
EOL
# setup inventory file
echo 'localhost ansible_connection=local' >> inventory
# Install Prometheus
ansible-playbook -i inventory main.yaml


# Install node_exporter
# go back to root
cd ..
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.0/node_exporter-1.0.0-rc.0.linux-amd64.tar.gz
tar xzf node_exporter-1.0.0-rc.0.linux-amd64.tar.gz
cd node_exporter-1.0.0-rc.0.linux-amd64/
mv node_exporter /usr/local/bin

# Create node_exporter user
useradd node_exporter

# Create node_exporter systemd service
tee -a /etc/systemd/system/node_exporter.service << EOL
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl restart node_exporter

# Add node_exporter target to prometheus.yml
tee -a /etc/prometheus/prometheus.yml << EOL
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
EOL

# Restart prometheus
systemctl restart prometheus


## Install Grafana
apt install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_6.7.3_amd64.deb
dpkg -i grafana_6.7.3_amd64.deb

systemctl daemon-reload
systemctl start grafana-server


# Install Elasticsearch with ansible
cd ..
git clone https://github.com/elastic/ansible-elasticsearch.git
cd ansible-elasticsearch
mkdir -p roles/elastic.elasticsearch
mv defaults/ docs/ files/ filter_plugins/ handlers/ meta/ tasks/ templates/ test/ vars roles/elastic.elasticsearch

# setup main playbook
tee -a main.yaml << EOL
- name: Simple Example
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
  vars:
    es_version: 7.6.2
EOL
# setup inventory file
echo 'localhost ansible_connection=local' >> inventory
# Install Elasticsearch
ansible-playbook -i inventory main.yaml


# Install Kibana
cd ..
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.6.2-amd64.deb
shasum -a 512 kibana-7.6.2-amd64.deb
dpkg -i kibana-7.6.2-amd64.deb

# Install Filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.2-amd64.deb
dpkg -i filebeat-7.6.2-amd64.deb

# Install Nginx as a proxy to kibana
apt install -y nginx

# Configure basic auth for kibana
# echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users

systemctl daemon-reload
