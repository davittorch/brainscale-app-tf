#!/bin/bash

set -e

sudo apt update
sudo apt install -y docker.io awscli
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu

sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 211125651847.dkr.ecr.us-east-1.amazonaws.com/brainscale-app-tf

for i in {1..10}; do
  sudo docker pull 211125651847.dkr.ecr.us-east-1.amazonaws.com/brainscale-app-tf:latest && break || sleep 60
done

sudo docker pull 211125651847.dkr.ecr.us-east-1.amazonaws.com/brainscale-app-tf:latest

sudo docker run -d -p 3000:3000 211125651847.dkr.ecr.us-east-1.amazonaws.com/brainscale-app-tf:latest
