#!/bin/bash
source ./variables.txt
openssl \
    genrsa \
	-out rootCA.$DOMAIN.key 2048
	
openssl req -x509 -new -nodes -key rootCA.$DOMAIN.key -sha256 -days 3600 -out rootCA.$DOMAIN.crt  -subj "/C=$C/ST=$ST/O=$O/CN=$CA_CN"

exit
