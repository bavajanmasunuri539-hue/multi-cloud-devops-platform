# SonarQube

SonarQube is used for static code analysis and code quality checking.

## Project

- Project Name: Multi Cloud DevOps Platform
- Project Key: multi-cloud-devops-platform

## Configuration

The SonarQube configuration is stored in:

sonar-project.properties

## Scan

The project can be scanned using:

sonar-scanner \
  -Dsonar.projectKey=multi-cloud-devops-platform \
  -Dsonar.sources=api,backend,frontend \
  -Dsonar.host.url=http://SONARQUBE_SERVER:9000 \
  -Dsonar.token=$SONAR_TOKEN