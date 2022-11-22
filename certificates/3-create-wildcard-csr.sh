#!/bin/bash
source ./variables.txt
openssl \
 req \
 -new \
 -nodes \
 -subj "/C=$C/ST=$ST/O=$O/CN=$CN" \
 -sha256 \
 -key wildcard.$DOMAIN.key \
 -out wildcard.$DOMAIN.csr \
 -config ./req.conf

openssl \
 req \
 -in  wildcard.$DOMAIN.csr \
 -noout \
 -text
exit
openssl \
 req \
 -new \
 -nodes \
 -subj "/C=$C/ST=$ST/O=$O/CN=$CN" \
 -sha256 \
 -key wildcard.$DOMAIN.key \
 -out wildcard.$DOMAIN.csr \
 -days 720

