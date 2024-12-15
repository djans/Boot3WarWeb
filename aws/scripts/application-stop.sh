#!/bin/bash

# Stop and remove all running containers
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm

# Optionally, clean up unused Docker resources
# docker system prune -f
