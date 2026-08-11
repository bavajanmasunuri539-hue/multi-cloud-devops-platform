# Deployment Guide

## 1. Overview

This document describes how to deploy the Multi-Cloud DevOps Platform to Amazon EKS using Terraform, Docker, Amazon ECR, Helm, and GitHub Actions.

---

## 2. Prerequisites

Install and configure:

* AWS CLI
* Terraform
* kubectl
* Helm
* Docker
* Git
* GitHub CLI

Verify the tools:

```bash
aws --version
terraform version
kubectl version --client
helm version
docker --version
git --version
gh --version
```

---

## 3. AWS Authentication

Configure AWS credentials:

```bash
aws configure
```

Verify the active AWS identity:

```bash
aws sts get-caller-identity
```

The project uses the AWS region:

```text
ap-south-1
```

---

## 4. Infrastructure Deployment

Navigate to Terraform:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the deployment plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

The infrastructure includes AWS resources required for the Kubernetes platform.

---

## 5. EKS Configuration

After the EKS cluster is created, configure kubectl:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name devops-eks-cluster
```

Verify the cluster:

```bash
kubectl get nodes
```

Expected result:

```text
STATUS
Ready
```

---

## 6. Kubernetes Namespace

Create the application namespace:

```bash
kubectl create namespace multi-cloud
```

If the namespace already exists, Kubernetes will report that it already exists. Humanity survives another day.

---

## 7. Helm Deployment

Deploy the API:

```bash
helm upgrade --install api ./helm/api \
  -n multi-cloud
```

Deploy the Backend:

```bash
helm upgrade --install backend ./helm/backend \
  -n multi-cloud
```

Deploy the Frontend:

```bash
helm upgrade --install frontend ./helm/frontend \
  -n multi-cloud
```

Verify Helm releases:

```bash
helm list -n multi-cloud
```

---

## 8. Verify Application Pods

Run:

```bash
kubectl get pods -n multi-cloud -o wide
```

Expected application components:

```text
api-api
backend-backend
frontend-frontend
```

The current deployment uses two replicas for each service.

---

## 9. Verify Services

Run:

```bash
kubectl get svc -n multi-cloud
```

Expected services:

```text
api-api
backend-backend
frontend-frontend
```

Service types are:

```text
ClusterIP
```

---

## 10. Ingress Deployment

Verify the NGINX Ingress:

```bash
kubectl get ingress -n multi-cloud
```

Current host:

```text
frontend.local
```

The AWS load balancer provides external access to the NGINX Ingress Controller.

---

## 11. Application Verification

Retrieve the load balancer hostname:

```bash
kubectl get ingress frontend-frontend \
  -n multi-cloud \
  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
```

Test the application using the required Host header:

```powershell
$h=@{"Host"="frontend.local"}
Invoke-WebRequest `
  -Uri "http://<LOAD_BALANCER_HOSTNAME>/" `
  -Headers $h `
  -UseBasicParsing
```

Expected response:

```text
StatusCode: 200
StatusDescription: OK
```

---

## 12. Monitoring Deployment

Install the Prometheus Community repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Update repositories:

```bash
helm repo update
```

Install the monitoring stack:

```bash
helm upgrade --install monitoring \
  prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  --set grafana.enabled=true \
  --set prometheus.enabled=true
```

---

## 13. Verify Monitoring

Check monitoring pods:

```bash
kubectl get pods -n monitoring
```

Expected components include:

```text
Prometheus
Grafana
Alertmanager
Prometheus Operator
Node Exporter
kube-state-metrics
```

Verify Prometheus:

```bash
kubectl get prometheus -n monitoring
```

Verify ServiceMonitors:

```bash
kubectl get servicemonitors -n monitoring
```

---

## 14. Grafana Access

Grafana is exposed internally through:

```text
monitoring-grafana
```

Port-forward it locally:

```bash
kubectl port-forward svc/monitoring-grafana 3001:80 -n monitoring
```

Open:

```text
http://localhost:3001
```

Grafana credentials:

```text
Username: admin
Password: <retrieve from Kubernetes Secret>
```

Retrieve the password:

```bash
kubectl get secret monitoring-grafana \
  -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 -d
```

---

## 15. Prometheus Access

Port-forward Prometheus:

```bash
kubectl port-forward \
  svc/monitoring-kube-prometheus-prometheus \
  9090:9090 \
  -n monitoring
```

Open:

```text
http://localhost:9090
```

Useful query:

```text
up
```

The project currently monitors:

```text
api:8080
backend:5000
prometheus:9090
```

All three targets have been verified as `UP`.

---

## 16. Grafana Dashboard

The project contains monitoring dashboards under:

```text
monitoring/grafana/dashboards/
```

Dashboard provisioning is configured through:

```text
monitoring/grafana/provisioning/
```

Prometheus is configured as the Grafana data source.

The dashboard provides visibility into:

* API availability
* Backend availability
* Prometheus availability
* Go API metrics
* Service health

---

## 17. CI/CD Deployment

For automated deployment, push changes to the `main` branch:

```bash
git add .
git commit -m "Deploy application changes"
git push origin main
```

GitHub Actions then performs:

```text
Push
 |
 v
CI
 |
 +--> SonarQube
 |
 +--> Docker Build
 |
 +--> ECR Push
 |
 v
CD
 |
 +--> EKS
 |
 +--> API
 +--> Backend
 +--> Frontend
 |
 v
Verification
```

---

## 18. Destroy Infrastructure

The project includes:

```text
.github/workflows/destroy.yml
```

Terraform can also be used to destroy infrastructure:

```bash
cd terraform
terraform destroy
```

Review the resources carefully before confirming destruction.

---

## 19. Useful Verification Commands

### Kubernetes

```bash
kubectl get nodes
kubectl get pods -A
kubectl get deployments -n multi-cloud
kubectl get svc -n multi-cloud
kubectl get ingress -n multi-cloud
```

### Helm

```bash
helm list -A
```

### Monitoring

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get prometheus -n monitoring
kubectl get servicemonitors -n monitoring
```

### GitHub Actions

```bash
gh run list --repo bavajanmasunuri539-hue/multi-cloud-devops-platform --limit 5
```

Watch CI:

```bash
gh run watch <CI_RUN_ID> --repo bavajanmasunuri539-hue/multi-cloud-devops-platform
```

Watch CD:

```bash
gh run watch <CD_RUN_ID> --repo bavajanmasunuri539-hue/multi-cloud-devops-platform
```

---

## 20. Deployment Status

The current platform has successfully demonstrated:

```text
✓ AWS infrastructure
✓ Amazon EKS cluster
✓ Kubernetes worker nodes
✓ API deployment
✓ Backend deployment
✓ Frontend deployment
✓ Helm releases
✓ NGINX Ingress
✓ AWS Load Balancer
✓ GitHub Actions CI
✓ GitHub Actions CD
✓ SonarQube analysis
✓ Docker image builds
✓ Amazon ECR image publishing
✓ Prometheus
✓ Grafana
✓ ServiceMonitors
✓ Monitoring dashboards
✓ Application health verification
```

The deployment is therefore operational from source commit through CI/CD, Kubernetes deployment, ingress, and monitoring.
