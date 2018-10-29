#!/bin/sh
set -e

REPO="${CI_REGISTRY_IMAGE:-omero-py-alpine}"
if [ -n "$CI_COMMIT_REF_SLUG" ]; then
  TAG_PREFIX="$CI_COMMIT_REF_SLUG"
else
  TAG_PREFIX="latest"
fi

IMAGE_PY_TAG="$REPO/omero-py:${TAG_PREFIX}"
IMAGE_WEB_TAG="$REPO/omero-web:${TAG_PREFIX}"
IMAGE_WEBAPPS_TAG="$REPO/omero-webapps:${TAG_PREFIX}"

sed -i web/Dockerfile -re "s%^FROM\\s+.+%FROM $IMAGE_PY_TAG%"
sed -i webapps/Dockerfile -re "s%^FROM\\s+.+%FROM $IMAGE_WEB_TAG%"

docker build -t $IMAGE_PY_TAG py
docker build -t $IMAGE_WEB_TAG web
docker build -t $IMAGE_WEBAPPS_TAG webapps

if [ -n "$CI_JOB_TOKEN" ]; then
  for image in "$IMAGE_PY_TAG" "$IMAGE_WEB_TAG" "$IMAGE_WEBAPPS_TAG"; do
    docker push $image
  done
fi
