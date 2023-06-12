#!/bin/bash
source ./settings$STAGE.txt

if [ "$1" == "" ]; then
       echo "target stage not defined - using default"	
       STAGE=""
       TARGET_STAGE=""
else
       STAGE="-$1"
       TARGET_STAGE="$1/"
fi

# binary installed
#SKOPEO="skopeo"
# running with docker
#SKOPEO="docker run --rm $SKOPEO_IMAGE"
# running with podman
SKOPEO="podman run --rm $SKOPEO_IMAGE"

# for kubewarden policies we need to use a newer registry version and a newer skopeo to copy and store OCI artifacts on-premise

for FILE in $FILES; do
	for IMAGE in $(cat $FILE); do
	        echo downloading $IMAGE
		echo $SKOPEO inspect --tls-verify=false docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --creds "$PUSH_USER":"$PUSH_PASSWORD"
		if $SKOPEO inspect --tls-verify=false docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --creds "$PUSH_USER":"$PUSH_PASSWORD" >/dev/null 2>&1 && ! [[ "$IMAGE" == *latest ]] ; then	       
			echo $TARGET_REGISTRY/$TARGET_STAGE$IMAGE already exists
		else
			echo $SKOPEO copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
			$SKOPEO copy --src-tls-verify=false --dest-tls-verify=false docker://$IMAGE docker://$TARGET_REGISTRY/$TARGET_STAGE$IMAGE --dest-creds "$PUSH_USER":"$PUSH_PASSWORD";
		        if [ ! $? == "0" ]; then
				echo "error downloading $IMAGE" >> image-download-error$STAGE.log
			#	exit 1 
			fi
		fi
	done
done

exit

