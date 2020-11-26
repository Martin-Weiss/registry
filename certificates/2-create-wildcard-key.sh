#!/bin/bash
source ./variables.txt
openssl \
  genrsa \
  -out wildcard.$DOMAIN.key 2048
exit
