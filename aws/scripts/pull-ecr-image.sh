#!/bin/bash
echo "Listing files"
ls -l
echo "Pulling Docker image from ECR...."
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/boot3warweb
docker pull 227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/boot3warweb:latest
