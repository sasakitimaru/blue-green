#!/bin/bash

# Docker login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# docker build -t $CONTAINER_NAME $DOCKER_DIR
docker build -f $DOCKER_DIR/Dockerfile -t $CONTAINER_NAME --target $TARGET_STAGE $DOCKER_DIR

# Tag
docker tag $CONTAINER_NAME:latest $REPO_URL:latest

# Push image
docker push $REPO_URL:latest
