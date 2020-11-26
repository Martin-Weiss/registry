#!/bin/bash -x

# variables
source ./variables.txt

#####################

systemctl stop container-mysql.service
systemctl disable container-mysql.service
rm /etc/systemd/system/container-mysql.service
systemctl daemon-reload
$RUNTIME stop mysql
$RUNTIME rm mysql
$RUNTIME run -d \
--restart=always \
--name mysql \
-p 33306:3306 \
-v /data/registry/mysql:/var/lib/mysql \
-e MYSQL_DATABASE="portus_production" \
-e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
-e MYSQL_DISABLE_REMOTE_ROOT="false" \
-e MYSQLD_CONFIG="character-set-server=utf8;collation-server=utf8_unicode_ci;init-connect=\"SET NAMES UTF8\";innodb-flush-log-at-trx-commit=0" \
-v /data/registry/mysql-entrypoint.sh:/usr/local/bin/entrypoint.sh \
registry.suse.com/sles12/mariadb:10.0
podman generate systemd --restart-policy=always mysql -n > /etc/systemd/system/container-mysql.service
systemctl daemon-reload
systemctl enable --now container-mysql.service
exit
--restart=unless-stopped \
