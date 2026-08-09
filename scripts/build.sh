#!/bin/bash

set -e

echo "Building Docker images..."

docker build -t bavajan12/frontend:latest ./frontend
docker build -t bavajan12/backend:latest ./backend
docker build -t bavajan12/api:latest ./api

echo "Docker images built successfully."

docker images | grep bavajan12