#!/bin/bash
source ./settings.txt

function _GET_REGISTRIES_LIST {
	REGISTRIES=$(cat $FILES|cut -f1 -d '/'|sort|uniq)
}

function _GET_IMAGES_LIST {
	_GET_REGISTRIES_LIST
	FILTER=$(echo $(for REGISTRY in $REGISTRIES; do echo -n ^$REGISTRY\|; done)|sed 's/.$//g')
        IMAGES=$(./docker-ls repositories --registry https://$TARGET_REGISTRY --allow-insecure -u $PULL_USER -p $PULL_PASSWORD --table|grep -v ^REPOSITORY|grep -E "$FILTER")
}

function _COPY_IMAGES {
        _GET_IMAGES_LIST
        for IMAGE in $IMAGES; do
                TAGS=$(./docker-ls tags --registry https://$TARGET_REGISTRY --allow-insecure -u $PULL_USER -p $PULL_PASSWORD $IMAGE|grep ^-|sed 's/^-//g'|sed 's/"//g')
                for TAG in $TAGS; do
                        IMAGE_NAME=$IMAGE
                        IMAGE_TAG=$TAG
                        echo IMAGE is $IMAGE_NAME:$IMAGE_TAG
                        SOURCE_IMAGE=$(echo $TARGET_REGISTRY/$SOURCE_STAGE/$IMAGE_NAME:$IMAGE_TAG|sed 's#//#/#g')
                        TARGET_IMAGE=$TARGET_REGISTRY/$TARGET_STAGE/$IMAGE_NAME:$IMAGE_TAG
                        echo SOURCE_IMAGE is $SOURCE_IMAGE
                        echo TARGET_IMAGE is $TARGET_IMAGE
                        echo skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://"$SOURCE_IMAGE" docker://"$TARGET_IMAGE" --src-creds "$PULL_USER":"$PULL_PASSWORD" --dest-creds "$PUSH_USER":"$PUSH_PASSWORD"
                        skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://"$SOURCE_IMAGE" docker://"$TARGET_IMAGE" --src-creds "$PULL_USER":"$PULL_PASSWORD" --dest-creds "$PUSH_USER":"$PUSH_PASSWORD"
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

