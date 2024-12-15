#!/bin/bash
IMAGE_URI="227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/boot3warweb"

echo "Pulling image $IMAGE_URI..."
docker pull $IMAGE_URI

echo "Starting new container..."
docker run -d --name Boot3WarWeb -p 80:9080 $IMAGE_URI
