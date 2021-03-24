wget -N https://github.com/rancher/rke2/releases/download/v1.19.7%2Brke2r1/rke2-images.linux-amd64.txt
wget -N https://github.com/mayflower/docker-ls/releases/download/v0.5.1/docker-ls-linux-amd64.zip
wget -N https://github.com/rancher/rancher/releases/download/v2.5.5/rancher-images.txt; sed -i "s#^#docker.io/#g" rancher-images.txt
