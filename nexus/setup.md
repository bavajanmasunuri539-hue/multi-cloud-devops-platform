# Nexus Repository Setup

Nexus Repository is used as an artifact repository in the DevOps pipeline.

## Installation

Nexus can be installed on an EC2 instance using Docker.

## Docker

```bash
docker pull sonatype/nexus3

docker volume create nexus-data

docker run -d \
  --name nexus \
  -p 8081:8081 \
  -v nexus-data:/nexus-data \
  sonatype/nexus3