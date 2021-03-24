#!/bin/bash

source ./settings.txt
for FILE in $FILES; do
	for IMAGE in $(cat $FILE); do
	       echo $IMAGE	
		skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD"; 
	done
done
