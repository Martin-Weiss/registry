#!/bin/bash -x

# variables
source ./variables.txt

########
systemctl stop container-registry.service
systemctl disable container-registry.service
rm /etc/systemd/system/container-registry.service
systemctl daemon-reload

$RUNTIME stop registry
$RUNTIME rm registry
echo "version: 0.1" > /data/registry/config.yml
$RUNTIME run -d \
--restart=always \
--name registry \
-v /data/certificates:/certificates:ro \
-v /data/certificates/$CA_CERTIFICATE:/etc/ssl/ca-bundle.pem:ro \
-v /data/registry/config.yml:/etc/docker/registry/config.yml \
-v /data/registry/docker-registry:/var/lib/docker-registry \
-p 5000:5000 \
-p 5001:5001 \
-e REGISTRY_VERSION="0.1" \
-e REGISTRY_LOG_LEVEL="info" \
-e REGISTRY_LOG_ACCESSLOG_DISABLED="true" \
-e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY="/var/lib/docker-registry" \
-e REGISTRY_STORAGE_DELETE_ENABLED=true \
-e REGISTRY_HTTP_ADDR=":5000" \
-e REGISTRY_HTTP_DEBUG_ADDR=":5001" \
-e REGISTRY_HTTP_SECRET="registry1234!" \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certificates/$CERTIFICATE \
-e REGISTRY_HTTP_TLS_KEY=/certificates/$KEY \
-e REGISTRY_AUTH_TOKEN_REALM=https://$FQDN:3001/v2/token \
-e REGISTRY_AUTH_TOKEN_SERVICE=$FQDN:5000 \
-e REGISTRY_AUTH_TOKEN_ISSUER=$FQDN \
-e REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE=/certificates/$CERTIFICATE \
-e REGISTRY_NOTIFICATIONS_ENDPOINTS="
- name: portus 
  url: https://$FQDN:3001/v2/webhooks/events
  timeout: 2000ms
  threshold: 5
  backoff: 1s
" \
registry.suse.com/sles12/registry:2.6.2
podman generate systemd --restart-policy=always registry -n > /etc/systemd/system/container-registry.service
systemctl daemon-reload
systemctl enable --now container-registry.service
exit
# podman does not support "unless-stopped"
--restart=unless-stopped \
