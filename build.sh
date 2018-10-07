#!/bin/sh
set -e

REPO="${CI_REGISTRY_IMAGE:-omero-py-alpine}"
if [ -n "$CI_COMMIT_REF_SLUG" ]; then
  TAG_PREFIX="$CI_COMMIT_REF_SLUG-"
else
  TAG_PREFIX=""
fi

IMAGE_PY_TAG="$REPO:${TAG_PREFIX}py"
IMAGE_WEB_TAG="$REPO:${TAG_PREFIX}web"
IMAGE_WEBAPPS_TAG="$REPO:${TAG_PREFIX}webapps"

sed -i web/Dockerfile -re "s%^FROM\\s+.+%FROM $IMAGE_PY_TAG%"
sed -i webapps/Dockerfile -re "s%^FROM\\s+.+%FROM $IMAGE_WEB_TAG%"

docker build -t $IMAGE_PY_TAG py
docker build -t $IMAGE_WEB_TAG web
docker build -t $IMAGE_WEBAPPS_TAG webapps
