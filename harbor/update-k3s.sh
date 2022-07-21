#!/bin/bash
source ./variables.txt
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-$K3S_VERSION/k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
sudo cp k3s-$K3S_VERSION/k3s /usr/local/bin/k3s
sudo chmod +x /usr/local/bin/k3s
sudo systemctl restart k3s
