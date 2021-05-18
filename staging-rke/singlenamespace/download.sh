#!/bin/bash

source ./settings.txt
for FILE in $FILES; do
	for IMAGE in $(cat $FILE); do
	       echo Image is $IMAGE
	       SHORTIMAGE=$(echo $IMAGE|awk -F '/' '{print $NF}')
	       echo
#		echo skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$STAGE_0/$SHORTIMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
#		skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$STAGE_0/$SHORTIMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
		sudo docker pull $IMAGE
		sudo docker login $TARGET_REGISTRY -u "$PUSH_USER" -p "$PUSH_PASSWORD"
		sudo docker tag $IMAGE $TARGET_REGISTRY/$STAGE_0/$SHORTIMAGE
		sudo docker push $TARGET_REGISTRY/$STAGE_0/$SHORTIMAGE
	        if [ ! $? == "0" ]; then
			echo "error downloading $IMAGE" >> image-download-error.log
		#	exit 1 
		fi
	done
done
