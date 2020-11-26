#!/bin/bash
source ./variables.txt
openssl x509 \
	-req \
	-in wildcard.$DOMAIN.csr \
        -CA rootCA.$DOMAIN.crt \
        -CAkey rootCA.$DOMAIN.key \
        -CAcreateserial \
	-out wildcard.$DOMAIN.crt \
	-days 3650 \
	-sha256 \
	-extfile ./req.conf \
	-extensions v3_req

openssl \
 x509 \
 -in  wildcard.$DOMAIN.crt \
 -noout \
 -text

exit
openssl \
  x509 \
  -req \
  -days 720 \
  -in wildcard.$DOMAIN.csr \
  -CA rootCA.$DOMAIN.crt \
  -CAkey rootCA.$DOMAIN.key \
  -CAcreateserial \
  -out wildcard.$DOMAIN.crt \

openssl x509 \
    -req \
    -in wildcard.$DOMAIN.csr \
  -CA rootCA.$DOMAIN.crt \
  -CAkey rootCA.$DOMAIN.key \
  -CAcreateserial \
    -nodes \
    -out wildcard.$DOMAIN.crt \
    -reqexts v3_req \
    -extensions v3_req \
    -config ./req.conf \
    -sha256 \
    -days 720
