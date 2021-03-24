#!/bin/bash

# variables
source ./variables.txt

for REPO in $(ls $WEBSERVERPATH); do
	echo creating index for $WEBSERVERPATH/$REPO using url $HELMSERVER/$REPO/
	helm repo index $WEBSERVERPATH/$REPO --url $HELMSERVER/$REPO/
done
