#!/bin/bash -x

# variables
source ./variables.txt

########
systemctl stop container-389-ds.service
systemctl disable container-389-ds.service
rm /etc/systemd/system/container-389-ds.service
systemctl daemon-reload

$RUNTIME stop 389-ds
$RUNTIME rm 389-ds
mkdir -p $DATA_DIR/config

$RUNTIME run -d \
--restart=always \
--name 389-ds \
-p 389:3389 \
-p 636:636 \
-v $DATA_DIR:/data \
-e DS_DM_PASSWORD=$DS_DM_PASSWORD \
-e DS_SUFFIX=$DS_SUFFIX \
registry.suse.com/caasp/v4/389-ds:1.4.0
podman generate systemd --restart-policy=always 389-ds -n > /etc/systemd/system/container-389-ds.service
systemctl daemon-reload
systemctl enable --now container-389-ds.service

# replace ssl certificate
systemctl stop container-389-ds.service
cp -av $CERTIFICATE_DIR/$CERTIFICATE $DATA_DIR/config/Server-Cert.crt
(ps -ef ; w ) | sha1sum | awk '{print $1}' > $DATA_DIR/config/pwdfile-import.txt
openssl rsa -aes256 -in $CERTIFICATE_DIR/$KEY -out $DATA_DIR/config/Server-Cert-Key.pem -passout file:$DATA_DIR/config/pwdfile-import.txt
systemctl start container-389-ds.service

exit
