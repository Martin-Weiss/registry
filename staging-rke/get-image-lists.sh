#!/bin/bash
# Get Docker-ls
#wget -N https://github.com/mayflower/docker-ls/releases/download/v0.5.1/docker-ls-linux-amd64.zip

#Get Image Text files
wget -N https://github.com/rancher/rke2/releases/download/v1.19.7%2Brke2r1/rke2-images.linux-amd64.txt -O rke2-images.linux-amd64-v1.19.7+rke2r1.txt
wget -N https://github.com/rancher/rke2/releases/download/v1.20.4%2Brke2r1/rke2-images.linux-amd64.txt -O rke2-images.linux-amd64-v1.20.4+rke2r1.txt
wget -N https://github.com/rancher/rke2/releases/download/v1.20.5%2Brke2r1/rke2-images.linux-amd64.txt -O rke2-images.linux-amd64-v1.20.5+rke2r1.txt

# Rancher
wget -N https://github.com/rancher/rancher/releases/download/v2.5.5/rancher-images.txt -O rancher-images-v2.5.5.txt; sed -i "s#^#docker.io/#g" rancher-images-v2.5.5.txt
wget -N https://github.com/rancher/rancher/releases/download/v2.5.7/rancher-images.txt -O rancher-images-v2.5.7.txt; sed -i "s#^#docker.io/#g" rancher-images-v2.5.7.txt
