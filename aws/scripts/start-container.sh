#!/bin/bash
IMAGE_URI="227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/boot3warweb"
echo " Starting Docker container ..."
docker stop boot3warweb || true
docker rm boot3warweb || true

echo "Pruning Docker images..."
docker image prune -a || true

echo "Pulling image $IMAGE_URI..."
docker pull $IMAGE_URI

echo "Starting new container..."
docker run -d -v /logs:/opt/aws/amazon-cloudwatch-agent/logs  --name boot3warweb --restart always -p 80:9080 $IMAGE_URI
