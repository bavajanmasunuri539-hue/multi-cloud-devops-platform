# Kubernetes Deployment

## 1. Overview

The Multi-Cloud DevOps Platform uses **Amazon Elastic Kubernetes Service (EKS)** to run and manage the application microservices.

The Kubernetes platform contains:

* API microservice
* Backend microservice
* Frontend microservice
* NGINX Ingress Controller
* Kubernetes Services
* Helm deployments
* Prometheus monitoring
* Grafana dashboards

---

## 2. Kubernetes Architecture

```text
                         Internet
                            |
                            v
                  AWS Load Balancer
                            |
                            v
                 NGINX Ingress Controller
                            |
             +--------------+--------------+
             |              |              |
             v              v              v
        Frontend         Backend          API
        Port 3000        Port 5000       Port 8080
             |              |              |
             +--------------+--------------+
                            |
                       Amazon EKS
                            |
             +--------------+--------------+
             |                             |
        Worker Node 1                 Worker Node 2
        10.0.11.x                     10.0.12.x
```

---

## 3. EKS Cluster

The Kubernetes workloads are deployed on Amazon EKS in:

```text
Region: ap-south-1
```

The cluster uses two worker nodes.

Example nodes:

```text
ip-10-0-11-83.ap-south-1.compute.internal
ip-10-0-12-17.ap-south-1.compute.internal
```

Verify the nodes:

```bash
kubectl get nodes -o wide
```

Expected status:

```text
STATUS
Ready
```

---

## 4. Kubernetes Namespace

Application workloads are deployed into:

```text
multi-cloud
```

Verify:

```bash
kubectl get namespace
```

Application resources can be viewed with:

```bash
kubectl get all -n multi-cloud
```

---

## 5. Application Deployments

The application contains three Kubernetes deployments.

| Deployment | Replicas | Container Port |
| ---------- | -------: | -------------: |
| API        |        2 |           8080 |
| Backend    |        2 |           5000 |
| Frontend   |        2 |           3000 |

Verify deployments:

```bash
kubectl get deployments -n multi-cloud
```

Expected:

```text
api-api             2/2
backend-backend     2/2
frontend-frontend   2/2
```

---

## 6. API Deployment

The API is a Go microservice.

```text
Deployment:
api-api

Service:
api-api

Port:
8080
```

Verify:

```bash
kubectl get deployment api-api -n multi-cloud
kubectl get pods -n multi-cloud -l app.kubernetes.io/name=api
```

The API provides a health endpoint:

```text
/health
```

The API metrics endpoint is:

```text
/metrics
```

---

## 7. Backend Deployment

The backend is a Python microservice.

```text
Deployment:
backend-backend

Service:
backend-backend

Port:
5000
```

Verify:

```bash
kubectl get deployment backend-backend -n multi-cloud
kubectl get pods -n multi-cloud -l app.kubernetes.io/name=backend
```

The backend metrics endpoint is:

```text
/metrics
```

---

## 8. Frontend Deployment

The frontend is a Node.js application.

```text
Deployment:
frontend-frontend

Service:
frontend-frontend

Port:
3000
```

Verify:

```bash
kubectl get deployment frontend-frontend -n multi-cloud
kubectl get pods -n multi-cloud -l app.kubernetes.io/name=frontend
```

---

## 9. Kubernetes Services

The application services use `ClusterIP`.

```bash
kubectl get svc -n multi-cloud
```

Current services:

```text
api-api
backend-backend
frontend-frontend
```

Architecture:

```text
API Pod
   |
   v
api-api Service
   |
   v
Port 8080


Backend Pod
   |
   v
backend-backend Service
   |
   v
Port 5000


Frontend Pod
   |
   v
frontend-frontend Service
   |
   v
Port 3000
```

`ClusterIP` services provide internal communication within the Kubernetes cluster.

---

## 10. Helm

Helm is used to package and deploy the application.

Project structure:

```text
helm/
├── api/
├── backend/
└── frontend/
```

Each Helm chart contains Kubernetes templates and configuration values.

Verify Helm releases:

```bash
helm list -n multi-cloud
```

Current releases:

```text
api
backend
frontend
```

---

## 11. Helm Deployment Commands

Install or upgrade the API:

```bash
helm upgrade --install api ./helm/api -n multi-cloud
```

Install or upgrade the Backend:

```bash
helm upgrade --install backend ./helm/backend -n multi-cloud
```

Install or upgrade the Frontend:

```bash
helm upgrade --install frontend ./helm/frontend -n multi-cloud
```

Validate Helm charts:

```bash
helm lint ./helm/api
helm lint ./helm/backend
helm lint ./helm/frontend
```

---

## 12. NGINX Ingress

NGINX Ingress Controller is used to expose the application.

Verify the ingress controller:

```bash
kubectl get pods -n ingress-nginx
```

Verify the application ingress:

```bash
kubectl get ingress -n multi-cloud
```

Current ingress:

```text
frontend-frontend
```

Configured host:

```text
frontend.local
```

Traffic flow:

```text
Internet
   |
   v
AWS Load Balancer
   |
   v
NGINX Ingress
   |
   v
frontend-frontend
   |
   v
Frontend Pods
```

---

## 13. Load Balancer

The NGINX Ingress Controller is exposed through an AWS Load Balancer.

Current load balancer hostname:

```text
a83ba88b0a72e40e989eb899d90200e7-576909477.ap-south-1.elb.amazonaws.com
```

Retrieve the hostname:

```bash
kubectl get ingress frontend-frontend \
  -n multi-cloud \
  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
```

---

## 14. Application Verification

The frontend uses the host:

```text
frontend.local
```

Test the application from PowerShell:

```powershell
$h=@{"Host"="frontend.local"}
Invoke-WebRequest `
  -Uri "http://<LOAD_BALANCER_HOSTNAME>/" `
  -Headers $h `
  -UseBasicParsing
```

Expected result:

```text
StatusCode
----------
200
```

This confirms that traffic reaches the frontend through the AWS Load Balancer and NGINX Ingress.

---

## 15. Pod Distribution

The application uses two replicas for each microservice.

Example:

```text
Worker Node 1
|
+-- API Pod
+-- Backend Pod
+-- Frontend Pod

Worker Node 2
|
+-- API Pod
+-- Backend Pod
+-- Frontend Pod
```

This provides basic workload distribution across the two worker nodes.

Check pod placement:

```bash
kubectl get pods -n multi-cloud -o wide
```

---

## 16. Rolling Updates

Kubernetes Deployments support rolling updates.

Check rollout status:

```bash
kubectl rollout status deployment/api-api -n multi-cloud
kubectl rollout status deployment/backend-backend -n multi-cloud
kubectl rollout status deployment/frontend-frontend -n multi-cloud
```

Restart a deployment when required:

```bash
kubectl rollout restart deployment/api-api -n multi-cloud
```

View rollout history:

```bash
kubectl rollout history deployment/api-api -n multi-cloud
```

Rollback:

```bash
kubectl rollout undo deployment/api-api -n multi-cloud
```

---

## 17. Kubernetes Monitoring

Prometheus and Grafana are deployed in the:

```text
monitoring
```

namespace.

Verify monitoring resources:

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

The monitoring stack includes:

```text
Prometheus
Grafana
Alertmanager
Prometheus Operator
Node Exporter
kube-state-metrics
```

---

## 18. Prometheus ServiceMonitors

Prometheus Operator uses ServiceMonitors to discover Kubernetes metrics endpoints.

Verify:

```bash
kubectl get servicemonitors -n monitoring
```

ServiceMonitors include:

```text
monitoring-grafana
monitoring-kube-prometheus-alertmanager
monitoring-kube-prometheus-apiserver
monitoring-kube-prometheus-coredns
monitoring-kube-prometheus-kubelet
monitoring-kube-prometheus-operator
monitoring-kube-prometheus-prometheus
monitoring-prometheus-node-exporter
```

Prometheus itself is healthy:

```bash
kubectl get prometheus -n monitoring
```

Expected:

```text
READY       AVAILABLE
1           True
```

---

## 19. Prometheus Targets

Prometheus currently monitors application endpoints including:

```text
api:8080
backend:5000
prometheus:9090
```

The Prometheus `up` query can be used to verify target health:

```text
up
```

Expected target state:

```text
api          UP
backend      UP
prometheus   UP
```

---

## 20. Grafana

Grafana uses Prometheus as its metrics data source.

Access Grafana locally:

```bash
kubectl port-forward svc/monitoring-grafana 3001:80 -n monitoring
```

Open:

```text
http://localhost:3001
```

The project contains a Multi-Cloud DevOps monitoring dashboard.

Dashboard provides visibility into:

* API availability
* Backend availability
* Prometheus availability
* Go API metrics
* Service health

---

## 21. Kubernetes Troubleshooting

### Check all application resources

```bash
kubectl get all -n multi-cloud
```

### Check pod logs

```bash
kubectl logs <pod-name> -n multi-cloud
```

### Describe a pod

```bash
kubectl describe pod <pod-name> -n multi-cloud
```

### Check deployment

```bash
kubectl describe deployment <deployment-name> -n multi-cloud
```

### Check service

```bash
kubectl describe svc <service-name> -n multi-cloud
```

### Check ingress

```bash
kubectl describe ingress frontend-frontend -n multi-cloud
```

---

## 22. Useful Kubernetes Commands

### Nodes

```bash
kubectl get nodes -o wide
```

### Pods

```bash
kubectl get pods -n multi-cloud -o wide
```

### Deployments

```bash
kubectl get deployments -n multi-cloud
```

### Services

```bash
kubectl get svc -n multi-cloud
```

### Ingress

```bash
kubectl get ingress -n multi-cloud
```

### Helm

```bash
helm list -A
```

### Monitoring

```bash
kubectl get pods -n monitoring
kubectl get prometheus -n monitoring
kubectl get servicemonitors -n monitoring
```

---

## 23. Current Kubernetes Status

The Kubernetes deployment has successfully demonstrated:

```text
✓ Amazon EKS cluster
✓ Two worker nodes
✓ multi-cloud namespace
✓ API deployment
✓ Backend deployment
✓ Frontend deployment
✓ Two replicas per application
✓ ClusterIP services
✓ Helm releases
✓ NGINX Ingress
✓ AWS Load Balancer
✓ Application HTTP 200 response
✓ Prometheus
✓ Grafana
✓ ServiceMonitors
✓ Prometheus targets UP
✓ Monitoring dashboard
```

---

## 24. Kubernetes Deployment Flow

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Amazon ECR
   |
   v
Amazon EKS
   |
   v
Helm
   |
   +----------------+
   |                |
   v                v
API              Backend
   |                |
   +--------+-------+
            |
            v
         Frontend
            |
            v
       NGINX Ingress
            |
            v
     AWS Load Balancer
            |
            v
         Internet

Monitoring:

Application
    |
    v
Prometheus
    |
    v
Grafana
```

## 25. Conclusion

Kubernetes provides the deployment and orchestration layer for the Multi-Cloud DevOps Platform. Helm manages application releases, NGINX Ingress handles external traffic, and Prometheus/Grafana provide observability.

The platform therefore covers the complete application lifecycle:

```text
Code
  ↓
CI/CD
  ↓
Container Images
  ↓
ECR
  ↓
EKS
  ↓
Helm
  ↓
Kubernetes
  ↓
Ingress
  ↓
Application
  ↓
Prometheus
  ↓
Grafana
```
