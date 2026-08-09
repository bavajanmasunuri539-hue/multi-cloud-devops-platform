#!/bin/bash

set -e

NAMESPACE="multi-cloud"

echo "Cleaning Kubernetes resources..."

kubectl delete -f kubernetes/ingress.yaml --ignore-not-found
kubectl delete -f kubernetes/frontend-service.yaml --ignore-not-found
kubectl delete -f kubernetes/frontend-deployment.yaml --ignore-not-found
kubectl delete -f kubernetes/backend-service.yaml --ignore-not-found
kubectl delete -f kubernetes/backend-deployment.yaml --ignore-not-found
kubectl delete -f kubernetes/api-service.yaml --ignore-not-found
kubectl delete -f kubernetes/api-deployment.yaml --ignore-not-found

echo "Cleanup completed."