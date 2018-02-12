#!/bin/bash
VERSION=$(cat ./current)
NAME=$(cat ./name)

LOCAL_VOLUME="$(pwd)/local_volume"
DOCKER_VOLUME="/var/lib/gearmand/"

mkdir $LOCAL_VOLUME && chmod -R 777 $LOCAL_VOLUME

docker run -v $LOCAL_VOLUME:$DOCKER_VOLUME $NAME
