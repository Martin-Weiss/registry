#!/bin/bash

source ./variables.txt

# k3s
mkdir -p k3s-$K3S_VERSION
if grep "k3s-$K3S_VERSION" .gitignore; then echo "k3s-$K3S_VERSION already in .gitignore"; else echo "k3s-$K3S_VERSION" >>.gitignore; fi
cd k3s-$K3S_VERSION
curl https://get.k3s.io -o install.sh
wget -N "https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s"
wget -N https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s-airgap-images-amd64.tar
cd ..

