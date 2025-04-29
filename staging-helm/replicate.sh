#!/bin/bash

source ./variables.txt

#ToDo: for OCI based source
IFS=$'\n'
for LINE in $(cat charts.txt); do

	REPO=$(echo $LINE|cut -f1 -d ",")
	URL=$(echo $LINE|cut -f2 -d ",")
	CHART=$(echo $LINE|cut -f3 -d ",")
	VERSION=$(echo $LINE|cut -f4 -d ",")

	# http based source
	#echo helm repo add "$REPO" "$URL"
	# todo add force?
	helm repo add "$REPO" "$URL"

	helm fetch $REPO/$CHART --version $VERSION
	helm push "$CHART"-"$VERSION".tgz oci://$TARGET_REGISTRY/$TARGET_PROJECT
	rm "$CHART"-"$VERSION".tgz
done
