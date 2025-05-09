#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws  ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 440436438107.dkr.ecr.ap-southeast-1.amazonaws.com

echo "Pulling Docker image..."
docker  pull 440436438107.dkr.ecr.ap-southeast-1.amazonaws.com/yt-chrome-plugin:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=yt-app)" ]; then
    echo "Stopping existing container..."
    docker stop yt-app
fi

if [ "$(docker ps -aq -f name=yt-app)" ]; then
    echo "Removing existing container..."
    docker rm yt-app
fi

echo "Starting new container..."
docker run -d -p 80:5000 --name yt-app 440436438107.dkr.ecr.ap-southeast-1.amazonaws.com/yt-chrome-plugin:latest

echo "Container started successfully."