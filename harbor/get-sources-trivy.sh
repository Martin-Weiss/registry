#!/bin/bash

source ./variables.txt

# trivi-db #v2
if grep "data" .gitignore; then echo "data already in .gitignore"; else echo "data" >>.gitignore; fi
mkdir -p $SUMA_DIR/data/trivy-pv/trivy/
cd $SUMA_DIR/data/trivy-pv/trivy/
wget -N https://github.com/aquasecurity/trivy/releases/download/v$TRIVY_VERSION/trivy_"$TRIVY_VERSION"_Linux-64bit.tar.gz
tar xzvf trivy_"$TRIVY_VERSION"_Linux-64bit.tar.gz
./trivy --cache-dir $SUMA_DIR/data/trivy-pv/trivy image --download-db-only
./trivy --cache-dir $SUMA_DIR/data/trivy-pv/trivy image --download-java-db-only
chown -R root:root $SUMA_DIR/data/trivy-pv
chmod -R 755 $SUMA_DIR/data/trivy-pv
chown -R 10000:10000 $SUMA_DIR/data/trivy-pv
#chmod -R 644 $SUMA_DIR/data/trivy-pv
