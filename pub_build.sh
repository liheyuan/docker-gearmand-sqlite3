#!/bin/bash

VERSION=$(cat ./current)
NAME=$(cat ./name)

docker tag rubydns coder4/$NAME:$VERSION
docker push coder4/$NAME:$VERSION
