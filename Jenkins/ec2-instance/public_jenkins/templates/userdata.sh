#!/bin/bash

sudo yum update
sudo yum install -y docker git

# docker
sudo usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# source
cd /home/ec2-user
git clone git@github.com:hyun6ik/Terraform-Study.git
chown -R ec2-user:ec2-user Terraform-Study
cd /home/ec2-user/Terraform-Study/Jenkins/ec2-instance/public_jenkins
make run