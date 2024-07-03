#!/bin/bash

source ./variables.txt

# harbor
mkdir -p harbor-$HARBOR_CHART_VERSION
cd harbor-$HARBOR_CHART_VERSION
helm repo add harbor https://helm.goharbor.io --force-update
helm fetch harbor/harbor --version $HARBOR_CHART_VERSION
helm inspect values harbor-$HARBOR_CHART_VERSION.tgz > harbor-$HARBOR_CHART_VERSION.values.yaml.org
cd ..

# trivi-db #v1 (deprecated)
#if grep "data" .gitignore; then echo "data already in .gitignore"; else echo "data" >>.gitignore; fi
#mkdir -p /data/harbor/data/trivy-pv/trivy/db
#cd /data/harbor/data/trivy-pv/trivy/db
#wget -N https://github.com/aquasecurity/trivy-db/releases/download/$TRIVY_VERSION/trivy-offline.db.tgz
#tar -zxf trivy-offline.db.tgz -C .
#chown -R 10000:10000 /data/harbor/data/trivy-pv

# trivi-db #v2
if grep "data" .gitignore; then echo "data already in .gitignore"; else echo "data" >>.gitignore; fi
mkdir -p /data/harbor/data/trivy-pv/trivy/
cd /data/harbor/data/trivy-pv/trivy/
wget -N https://github.com/aquasecurity/trivy/releases/download/v$TRIVY_VERSION/trivy_"$TRIVY_VERSION"_Linux-64bit.tar.gz
tar xzvf trivy_"$TRIVY_VERSION"_Linux-64bit.tar.gz
./trivy --cache-dir /data/harbor/data/trivy-pv/trivy image --download-db-only
chown -R 10000:10000 /data/harbor/data/trivy-pv
