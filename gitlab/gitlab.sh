#!/bin/bash -x

# variables
source ./variables.txt

########
systemctl stop container-gitlab.service
systemctl disable container-gitlab.service
rm /etc/systemd/system/container-gitlab.service
systemctl daemon-reload

$RUNTIME stop gitlab
$RUNTIME rm gitlab
mkdir -p /data/gitlab/data /data/gitlab/logs /data/gitlab/config/ssl

$RUNTIME run -d \
--restart=always \
--name gitlab \
-v /data/gitlab/config:/etc/gitlab \
-v /data/gitlab/logs:/var/log/gitlab \
-v /data/gitlab/data:/var/opt/gitlab \
-v /data/certificates/$CERTIFICATE:/etc/gitlab/ssl/$FQDN.crt:ro \
-v /data/certificates/$KEY:/etc/gitlab/ssl/$FQDN.key:ro \
-p 10080:80 \
-p 10443:10443 \
-p 10022:22 \
-e GITLAB_OMNIBUS_CONFIG="external_url 'https://$FQDN:10443/'; letsencrypt['enable'] = false; nginx['redirect_http_to_https'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 10022;" \
docker.io/gitlab/gitlab-ce:13.11.4-ce.0
podman generate systemd --restart-policy=always gitlab -n > /etc/systemd/system/container-gitlab.service
systemctl daemon-reload
systemctl enable --now container-gitlab.service
exit
-p 10443:10443 \
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.example.com.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.example.com.key"
-v /data/certificates/$CA_CERTIFICATE:/etc/gitlab/trusted-certs/ca-bundle.pem:ro \
