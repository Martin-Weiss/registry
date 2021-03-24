#!/bin/bash -x
# variables
source ./variables.txt

podman run -it --rm --hostname mc --name mc --entrypoint=/bin/bash docker.io/minio/mc:RELEASE.2021-02-19T05-34-40Z
