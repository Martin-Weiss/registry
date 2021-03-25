#!/bin/bash

source ./settings.txt
for FILE in $FILES; do
	for IMAGE in $(cat $FILE); do
	       echo $IMAGE	
		skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
		echo skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
	        if [ $? != 0 ]; then
			echo "error downloading $IMAGE" >> image-download-error.log
		#	exit 1 
		fi
	done
done
