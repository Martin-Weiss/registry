#!/bin/bash -x
# variables
source ./variables.txt

########
systemctl stop container-minio.service
systemctl disable container-minio.service
rm /etc/systemd/system/container-minio.service
systemctl daemon-reload

$RUNTIME stop minio
$RUNTIME rm minio
mkdir -p $DATA_DIR
$RUNTIME run -d \
	--name minio \
	--hostname $FQDN \
	-p 9000:9000 \
	-e MINIO_ROOT_USER=admin \
	-e MINIO_ROOT_PASSWORD=Suse1234! \
	-e MINIO_ACCESS_KEY="ABCKIKJAA5BMMU2RHO7IBB" \
	-e MINIO_SECRET_KEY="V7f1CwQqAdab80UEIJEjc5gVQUSSx5ohQ9GSrr13" \
	-e MINIO_REGION_NAME="de-bw-1" \
	-v $CERTIFICATE_DIR/$KEY:/root/.minio/certs/private.key:ro \
	-v $CERTIFICATE_DIR/$CERTIFICATE:/root/.minio/certs/public.crt:ro \
	-v $DATA_DIR:/data \
docker.io/minio/minio:RELEASE.2021-02-14T04-01-33Z server /data
podman generate systemd --restart-policy=always minio -n > /etc/systemd/system/container-minio.service
systemctl daemon-reload
systemctl enable --now container-minio.service
exit
	--restart=unless-stopped \
