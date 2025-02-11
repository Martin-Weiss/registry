#!/bin/bash
source ./settings.txt

# binary installed
#SKOPEO="skopeo"
# running with docker
#SKOPEO="docker run --rm $SKOPEO_IMAGE"
# running with podman
SKOPEO="podman run --rm $SKOPEO_IMAGE"

function _GET_REGISTRIES_LIST {
	# get the list of registries used in the image txt files to be able to ignore everything else in the registry
	REGISTRIES=$(cat $FILES|cut -f1 -d '/'|sort|uniq)
}

function _GET_IMAGES_LIST {
	_GET_REGISTRIES_LIST
	# define the filter for registries in txt files
	FILTER=$(echo $(for REGISTRY in $REGISTRIES; do echo -n ^$REGISTRY\|; done)|sed 's/.$//g')
	# get list of images in the registry based on images in the txt files
        IMAGES=$(./docker-ls repositories --registry https://$TARGET_REGISTRY --allow-insecure --basic-auth -u $PULL_USER -p $PULL_PASSWORD --table|grep -v ^REPOSITORY|grep -E "$FILTER")
}

function _COPY_IMAGES {
        _GET_IMAGES_LIST
        for IMAGE in $IMAGES; do
		# we need to get all versions of a given image
                TAGS=$(./docker-ls tags --registry https://$TARGET_REGISTRY --allow-insecure --basic-auth -u $PULL_USER -p $PULL_PASSWORD $IMAGE|grep ^-|sed 's/^-//g'|sed 's/"//g')
                for TAG in $TAGS; do
                        IMAGE_NAME=$IMAGE
                        IMAGE_TAG=$TAG
                        echo IMAGE is $IMAGE_NAME:$IMAGE_TAG
                        SOURCE_IMAGE=$(echo $TARGET_REGISTRY/$SOURCE_STAGE/$IMAGE_NAME:$IMAGE_TAG|sed 's#//#/#g')
                        TARGET_IMAGE=$TARGET_REGISTRY/$TARGET_STAGE/$IMAGE_NAME:$IMAGE_TAG
                        echo SOURCE_IMAGE is $SOURCE_IMAGE
                        echo TARGET_IMAGE is $TARGET_IMAGE
			# find out if target image already exists
			#if ./docker-ls tags --registry https://$TARGET_REGISTRY --allow-insecure --basic-auth -u $PULL_USER -p $PULL_PASSWORD $IMAGE|grep ^-|sed 's/^-//g'|sed 's/"//g'|grep $TAG; then
			if $SKOPEO inspect --tls-verify=false docker://"$TARGET_IMAGE" --creds "$PUSH_USER":"$PUSH_PASSWORD --multi-arch system" >/dev/null 2>&1 ; then
				echo $TARGET_IMAGE already exists
			else
                        	echo $SKOPEO copy --src-tls-verify=false --dest-tls-verify=false docker://"$SOURCE_IMAGE" docker://"$TARGET_IMAGE" --src-creds "$PULL_USER":"$PULL_PASSWORD" --dest-creds "$PUSH_USER":"$PUSH_PASSWORD --multi-arch all"
	                       $SKOPEO copy --src-tls-verify=false --dest-tls-verify=false docker://"$SOURCE_IMAGE" docker://"$TARGET_IMAGE" --src-creds "$PULL_USER":"$PULL_PASSWORD" --dest-creds "$PUSH_USER":"$PUSH_PASSWORD --multi-arch all"
		       fi
                        if [ ! $? == "0" ]; then
                                echo "Error while copying source image:$SOURCE_IMAGE to target image: $TARGET_IMAGE" >> stage-image-error.log
                                #exit 1;
                        fi
                done
        done
}

function _MAIN {
                if [ "$1" = "1" ]; then
                        SOURCE_STAGE=$STAGE_0
                        TARGET_STAGE=$STAGE_1
                        _COPY_IMAGES
                elif [ "$1" = "2" ]; then
                        SOURCE_STAGE=$STAGE_1
                        TARGET_STAGE=$STAGE_2
                        _COPY_IMAGES
                elif [ "$1" = "3" ]; then
                        SOURCE_STAGE=$STAGE_2
                        TARGET_STAGE=$STAGE_3
                        _COPY_IMAGES
                elif [ "$1" = "4" ]; then
                        SOURCE_STAGE=$STAGE_3
                        TARGET_STAGE=$STAGE_4
                        _COPY_IMAGES
                else
                        echo "specify stage as 1,2,3,4"
                exit
                fi
}

_MAIN $1

