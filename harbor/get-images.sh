#!/bin/bash
source variables.txt
mkdir -p harbor-$HARBOR_CHART_VERSION/images
echo "images" > harbor-$HARBOR_CHART_VERSION/.gitignore
for IMAGE in $(cat harbor-images-v$HARBOR_VERSION.txt); do
	echo $IMAGE
	SHORTIMAGE=$(echo $IMAGE|awk -F '/' '{print $NF}')
	IMAGE_FILENAME=$(echo $SHORTIMAGE.tar|sed s#:#X#g)
#	skopeo copy docker://$IMAGE docker-archive:harbor-$HARBOR_CHART_VERSION/images/$IMAGE_FILENAME
	docker pull $IMAGE
	docker save $IMAGE -o harbor-$HARBOR_CHART_VERSION/images/$IMAGE_FILENAME
#	docker rmi $IMAGE
done

