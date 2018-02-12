#!/bin/bash
VERSION=$(cat ./current)
NAME=$(cat ./name)

cd $VERSION
docker build -t $NAME .
cd ..
