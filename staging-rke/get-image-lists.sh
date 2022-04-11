#!/bin/bash
# Get Docker-ls
#wget -N https://github.com/mayflower/docker-ls/releases/download/v0.5.1/docker-ls-linux-amd64.zip

RKE2_VERSIONS="v1.19.7+rke2r1 v1.19.8+rke2r1 v1.19.9+rke2r1 v1.19.10+rke2r1 v1.19.11+rke2r1 v1.19.12+rke2r1 v1.19.13+rke2r1 v1.19.14+rke2r1 v1.19.16+rke2r1 v1.20.4+rke2r1 v1.20.5+rke2r1 v1.20.6+rke2r1 v1.20.7+rke2r1 v1.20.7+rke2r2 v1.20.8+rke2r1 v1.20.9+rke2r1 v1.20.10+rke2r1 v1.20.11+rke2r1 v1.20.11+rke2r2 v1.20.12+rke2r1 v1.20.13+rke2r1 v1.20.15+rke2r1 v1.21.2+rke2r1 v1.21.3+rke2r1 v1.21.4+rke2r3 v1.21.5+rke2r1 v1.21.6+rke2r1 v1.21.7+rke2r1 v1.21.7+rke2r2 v1.21.9+rke2r1 v1.21.10+rke2r1 v1.21.11+rke2r1"
RANCHER_VERSIONS="v2.5.5 v2.5.7 v2.5.8 v2.5.9 v2.5.11 v2.6.0 v2.6.1 v2.6.2 v2.6.3 v2.6.4"

# RKE2
for RKE2_VERSION in $RKE2_VERSIONS; do
	wget -N "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images.linux-amd64.txt" -O rke2-images.linux-amd64-$RKE2_VERSION.txt
done

# Rancher
for RANCHER_VERSION in $RANCHER_VERSIONS; do
	wget -N "https://github.com/rancher/rancher/releases/download/$RANCHER_VERSION/rancher-images.txt" -O rancher-images-$RANCHER_VERSION.txt; sed -i "s#^#docker.io/#g" rancher-images-$RANCHER_VERSION.txt
done
