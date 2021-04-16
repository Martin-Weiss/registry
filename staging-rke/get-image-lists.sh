#!/bin/bash
# Get Docker-ls
#wget -N https://github.com/mayflower/docker-ls/releases/download/v0.5.1/docker-ls-linux-amd64.zip

RKE2_VERSIONS="v1.19.7+rke2r1 v1.19.8+rke2r1 v1.19.9+rke2r1 v1.20.4+rke2r1 v1.20.5+rke2r1 v1.20.5-alpha1+rke2r2"
RANCHER_VERSIONS="v2.5.5 v2.5.7"

# RKE2
for RKE2_VERSION in $RKE2_VERSIONS; do
	wget -N "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images.linux-amd64.txt" -O rke2-images.linux-amd64-$RKE2_VERSION.txt
done

# Rancher
for RANCHER_VERSION in $RANCHER_VERSIONS; do
	wget -N "https://github.com/rancher/rancher/releases/download/$RANCHER_VERSION/rancher-images.txt" -O rancher-images-$RANCHER_VERSION.txt; sed -i "s#^#docker.io/#g" rancher-images-$RANCHER_VERSION.txt
done
