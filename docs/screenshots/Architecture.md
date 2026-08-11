# Multi-Cloud DevOps Platform - Architecture

## 1. Overview

The Multi-Cloud DevOps Platform is a cloud-native microservices application designed to demonstrate automated infrastructure provisioning, containerization, CI/CD, Kubernetes deployment, and monitoring.

The platform consists of three application microservices:

* **Frontend** - Node.js application
* **Backend** - Python application
* **API** - Go application

The infrastructure is deployed on **AWS** using Amazon EKS, with Kubernetes workloads managed using Helm.

---

## 2. High-Level Architecture

```text
                         Internet
                            |
                            v
                +-----------------------+
                |   AWS Load Balancer   |
                +-----------+-----------+
                            |
                            v
                +-----------------------+
                |   NGINX Ingress      |
                |      Controller      |
                +-----------+-----------+
                            |
              +-------------+-------------+
              |             |             |
              v             v             v
        +-----------+ +-----------+ +-----------+
        | Frontend  | |  Backend  | |    API    |
        | Node.js   | |  Python   | |    Go     |
        | Port 3000 | | Port 5000 | | Port 8080 |
        +-----------+ +-----------+ +-----------+
              |             |             |
              +-------------+-------------+
                            |
                     Kubernetes Cluster
                            |
              +-------------+-------------+
              |                           |
              v                           v
       Prometheus                    Grafana
       Metrics                       Dashboard
```

---

## 3. AWS Infrastructure

The application runs on an Amazon EKS cluster in the `ap-south-1` region.

### Kubernetes Worker Nodes

Two worker nodes are currently used:

```text
10.0.11.83
10.0.12.17
```

The nodes are distributed across private application subnets.

### Network Architecture

```text
AWS VPC
10.0.0.0/16
|
+-- Public Subnet 1
|   10.0.1.0/24
|
+-- Public Subnet 2
|   10.0.2.0/24
|
+-- Private App Subnet 1
|   10.0.11.0/24
|   |
|   +-- EKS Worker Node
|
+-- Private App Subnet 2
|   10.0.12.0/24
|   |
|   +-- EKS Worker Node
|
+-- Private DB Subnets
    |
    +-- RDS
```

---

## 4. Kubernetes Architecture

The application is deployed into the:

```text
multi-cloud
```

namespace.

### Application Deployments

| Application | Replicas | Container Port |
| ----------- | -------: | -------------: |
| API         |        2 |           8080 |
| Backend     |        2 |           5000 |
| Frontend    |        2 |           3000 |

Each service is exposed internally through Kubernetes `ClusterIP` services.

---

## 5. Ingress Architecture

NGINX Ingress Controller provides external access to the frontend.

```text
Internet
   |
   v
AWS Load Balancer
   |
   v
NGINX Ingress Controller
   |
   v
frontend-frontend:3000
```

Current load balancer:

```text
a83ba88b0a72e40e989eb899d90200e7-576909477.ap-south-1.elb.amazonaws.com
```

The configured host is:

```text
frontend.local
```

---

## 6. Container Architecture

Each microservice has its own Docker image.

```text
Source Code
     |
     v
Docker Build
     |
     +--> API Image
     |
     +--> Backend Image
     |
     +--> Frontend Image
     |
     v
Amazon ECR
     |
     v
Amazon EKS
```

---

## 7. Helm Architecture

Helm is used to package and deploy the application.

```text
helm/
|
+-- api/
+-- backend/
+-- frontend/
```

Each chart contains:

* Deployment
* Service
* Configurations
* Values
* Templates

Current Helm releases:

```text
api
backend
frontend
```

---

## 8. Monitoring Architecture

The monitoring stack is deployed using the Prometheus Community `kube-prometheus-stack`.

```text
                    Kubernetes Cluster
                           |
            +--------------+--------------+
            |                             |
            v                             v
       Prometheus                     Grafana
            |                             |
            |                             v
            |                    Monitoring Dashboard
            |
     +------+-------+
     |              |
     v              v
 Kubernetes     Node Exporter
 Metrics
```

Monitoring components include:

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* kube-state-metrics
* Prometheus Operator
* ServiceMonitors

Prometheus collects metrics from monitored targets.

Grafana uses Prometheus as its data source and displays application and infrastructure metrics.

---

## 9. CI/CD Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> SonarQube Analysis
    |
    +--> Docker Build
    |
    +--> Amazon ECR Push
    |
    v
CD Workflow
    |
    v
Amazon EKS
    |
    +--> API
    +--> Backend
    +--> Frontend
    |
    v
Prometheus + Grafana
```

---

## 10. Security

The platform uses:

* AWS IAM roles
* GitHub Actions secrets
* ECR authentication
* Kubernetes namespaces
* Private application subnets
* Kubernetes service isolation
* AWS security groups

AWS credentials are supplied to GitHub Actions through GitHub Secrets rather than being stored directly in source code.

---

## 11. Technology Stack

| Category               | Technology     |
| ---------------------- | -------------- |
| Cloud                  | AWS            |
| Kubernetes             | Amazon EKS     |
| Containerization       | Docker         |
| Package Management     | Helm           |
| CI/CD                  | GitHub Actions |
| Source Control         | Git/GitHub     |
| Container Registry     | Amazon ECR     |
| Code Quality           | SonarQube      |
| Monitoring             | Prometheus     |
| Visualization          | Grafana        |
| Ingress                | NGINX          |
| Infrastructure as Code | Terraform      |
| API                    | Go             |
| Backend                | Python         |
| Frontend               | Node.js        |

---

## 12. Project Flow

```text
Code Commit
    |
    v
GitHub
    |
    v
CI
    |
    +--> SonarQube
    |
    +--> Docker Build
    |
    +--> ECR
    |
    v
CD
    |
    v
EKS
    |
    +--> Helm Deployments
    |
    v
NGINX Ingress
    |
    v
Application
    |
    v
Prometheus
    |
    v
Grafana
```
