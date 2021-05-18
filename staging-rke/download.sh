#!/bin/bash

if [ "$1" == "" ]; then
       echo "target stage not defined - using default"	
       STAGE=""
       TARGET_STAGE=""
else
       STAGE="-$1"
       TARGET_STAGE="$1/"
fi

source ./settings$STAGE.txt

for FILE in $FILES; do
	for IMAGE in $(cat $FILE); do
	        echo downloading $IMAGE
		if skopeo inspect --tls-verify=false docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --creds "$PUSH_USER":"$PUSH_PASSWORD" >/dev/null 2>&1 ; then	       
			echo $TARGET_REGISTRY/$TARGET_STAGE$IMAGE already exists
		else
			echo skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
			skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
		        if [ ! $? == "0" ]; then
				echo "error downloading $IMAGE" >> image-download-error$STAGE.log
			#	exit 1 
			fi
		fi
	done
done
