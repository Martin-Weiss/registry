#!/bin/bash

source ./variables.txt

# k3s
./get-sources-k3s.sh

# harbor
./get-sources-harbor.sh

# trivi-db #v2
./get-sources-trivy.sh
