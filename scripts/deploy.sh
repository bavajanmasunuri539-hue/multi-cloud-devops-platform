#!/bin/bash

set -e

NAMESPACE="multi-cloud"

echo "Creating namespace..."

kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying API..."

kubectl apply -f kubernetes/api-deployment.yaml
kubectl apply -f kubernetes/api-service.yaml

echo "Deploying Backend..."

kubectl apply -f kubernetes/backend-deployment.yaml
kubectl apply -f kubernetes/backend-service.yaml

echo "Deploying Frontend..."

kubectl apply -f kubernetes/frontend-deployment.yaml
kubectl apply -f kubernetes/frontend-service.yaml

echo "Deploying Ingress..."

kubectl apply -f kubernetes/ingress.yaml

echo "Deployment completed."

kubectl get pods -n $NAMESPACE
kubectl get svc -n $NAMESPACE
kubectl get ingress -n $NAMESPACE