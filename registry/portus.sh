#!/bin/bash -x
# openssl rand -hex 64 -> keybase

# variables
source ./variables.txt

##############################
systemctl stop container-portus.service
systemctl disable container-portus.service
rm /etc/systemd/system/container-portus.service
systemctl daemon-reload
$RUNTIME stop portus
$RUNTIME rm portus
$RUNTIME run -d \
--restart=always \
--name portus \
-v /data/certificates/:/certificates:ro \
-v /data/certificates/$CA_CERTIFICATE:/etc/pki/trust/anchors/rootCA.crt:ro \
-p 3001:3000 \
-e PORTUS_DB_HOST=$FQDN \
-e PORTUS_DB_PORT=33306 \
-e PORTUS_DB_DATABASE="$PORTUS_DB_DATABASE" \
-e PORTUS_DB_USERNAME="$PORTUS_DB_USERNAME" \
-e PORTUS_DB_PASSWORD="$PORTUS_DB_PASSWORD" \
-e PORTUS_DB_POOL=5 \
-e PORTUS_MACHINE_FQDN_VALUE=$FQDN \
-e PORTUS_PASSWORD="$PORTUS_PASSWORD" \
-e PORTUS_CHECK_SSL_USAGE_ENABLED=true \
-e PORTUS_SECRET_KEY_BASE=fe4ead79e6c48fa8cf2234ff31964a9997459ced70effd28fa5b71c0c3a18e46f4bc013d9657ea09ad07397f65a626c48d5f16804022d351724cf463b6da144f \
-e PORTUS_KEY_PATH=/certificates/$KEY \
-e PORTUS_PUMA_TLS_KEY=/certificates/$KEY \
-e PORTUS_PUMA_TLS_CERT=/certificates/$CERTIFICATE \
-e RAILS_SERVE_STATIC_FILES=true \
-e PORTUS_DELETE_ENABLED=true \
-e PORTUS_SIGNUP_ENABLED=false \
registry.suse.com/sles12/portus:2.4.3
podman generate systemd --restart-policy=always portus -n > /etc/systemd/system/container-portus.service
systemctl daemon-reload
systemctl enable --now container-portus.service
exit
# just required with CLAIR
-e PORTUS_SECURITY_CLAIR_SERVER="http://$FQDN:6060" \
# podman does not support "unless-stopped"
--restart=unless-stopped \
