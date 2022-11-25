#!/bin/bash
source ./variables.txt
curl -L -o helm-linux-amd64.tar.gz https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz
tar xzf helm-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin
rm -rf linux-amd64
rm helm-linux-amd64.tar.gz
/usr/local/bin/helm completion bash > /usr/share/bash-completion/completions/helm
chmod 644 /usr/share/bash-completion/completions/helm
