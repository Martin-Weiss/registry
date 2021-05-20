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

# harbor
mkdir -p harbor-$HARBOR_CHART_VERSION
cd harbor-$HARBOR_CHART_VERSION
helm repo add harbor https://helm.goharbor.io --force-update
helm fetch harbor/harbor --version $HARBOR_CHART_VERSION
helm inspect values harbor-$HARBOR_CHART_VERSION.tgz > harbor-$HARBOR_CHART_VERSION.values.yaml.org
cd ..

# trivi-db
if grep "data" .gitignore; then echo "data already in .gitignore"; else echo "data" >>.gitignore; fi
mkdir -p /data/harbor/data/trivy-pv/trivy/db
cd /data/harbor/data/trivy-pv/trivy/db
wget -N https://github.com/aquasecurity/trivy-db/releases/download/$TRIVY_VERSION/trivy-offline.db.tgz
tar -zxf trivy-offline.db.tgz -C .
chown -R 10000:10000 /data/harbor/data/trivy-pv

