#!/bin/bash
source ./variables.txt
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-$K3S_VERSION/k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
sudo cp k3s-$K3S_VERSION/k3s /usr/local/bin/k3s
sudo chmod +x /usr/local/bin/k3s
sudo chmod +x k3s-$K3S_VERSION/install.sh
sudo INSTALL_K3S_SKIP_ENABLE=true INSTALL_K3S_SKIP_DOWNLOAD=true k3s-$K3S_VERSION/install.sh
sudo systemctl daemon-reload
sudo mkdir -p /etc/rancher/k3s
sudo cp config.yaml /etc/rancher/k3s/config.yaml
sudo cp registries.yaml /etc/rancher/k3s/registries.yaml
sudo systemctl restart k3s
sudo systemctl enable k3s
