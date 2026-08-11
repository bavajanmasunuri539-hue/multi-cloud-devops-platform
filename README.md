# Multi-Cloud DevOps Platform

A production-style DevOps and cloud deployment platform demonstrating **Infrastructure as Code, containerization, Kubernetes orchestration, Helm deployments, CI/CD automation, monitoring, and AWS cloud infrastructure**.

The project deploys a three-tier microservices application consisting of:

* **Frontend** - Node.js application
* **Backend** - Python application
* **API** - Go application

The application is containerized with Docker, deployed to **Amazon EKS**, managed using **Helm**, provisioned with **Terraform**, automated through **GitHub Actions**, and monitored using **Prometheus, Grafana, Alertmanager, Node Exporter, and kube-state-metrics**.

---

## 📌 Project Overview

### Project Name

`multi-cloud-devops-platform`

### Cloud Platform

**Amazon Web Services (AWS)**

### AWS Region

`ap-south-1`

### Kubernetes Platform

**Amazon EKS**

### Kubernetes Version

`v1.33.13-eks-254016e`

### Application Namespace

`multi-cloud`

### Monitoring Namespace

`monitoring`

---

# 🏗️ Architecture

The platform follows a cloud-native architecture:

```text
                         ┌─────────────────────┐
                         │       GitHub        │
                         │   Source Repository │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   GitHub Actions    │
                         │      CI / CD        │
                         └──────────┬──────────┘
                                    │
                   ┌────────────────┴────────────────┐
                   │                                 │
                   ▼                                 ▼
          ┌─────────────────┐               ┌─────────────────┐
          │ Docker Images   │               │   SonarQube     │
          │ Build & Push    │               │ Code Analysis   │
          └────────┬────────┘               └─────────────────┘
                   │
                   ▼
          ┌─────────────────────┐
          │    AWS ECR         │
          │ Container Registry │
          └──────────┬──────────┘
                     │
                     ▼
        ┌────────────────────────────┐
        │       Amazon EKS           │
        │                            │
        │  ┌──────────────────────┐  │
        │  │ Kubernetes Ingress   │  │
        │  └──────────┬───────────┘  │
        │             │              │
        │      ┌──────┴──────┐       │
        │      ▼             ▼       │
        │  ┌────────┐   ┌────────┐   │
        │  │Frontend│   │Backend │   │
        │  │Node.js │   │Python  │   │
        │  └────────┘   └────┬───┘   │
        │                    │       │
        │                 ┌──▼───┐   │
        │                 │ API  │   │
        │                 │ Go   │   │
        │                 └──────┘   │
        └────────────────────────────┘
                     │
                     ▼
          ┌────────────────────────────┐
          │       Monitoring           │
          │                            │
          │ Prometheus + Grafana       │
          │ Alertmanager               │
          │ Node Exporter              │
          │ kube-state-metrics         │
          └────────────────────────────┘
```

Detailed architecture documentation is available in:

`docs/screenshots/Architecture.md`

---

# 🚀 Key Features

## Infrastructure as Code

Terraform is used to provision and manage AWS infrastructure.

Infrastructure includes:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Security groups
* IAM roles
* EKS cluster
* EKS worker nodes
* ECR repositories
* Supporting AWS resources

Terraform configuration is located under:

```text
terraform/
```

---

## Containerization

Each application is packaged as a Docker container.

### Application services

| Service  | Technology | Container Port |
| -------- | ---------- | -------------: |
| Frontend | Node.js    |           3000 |
| Backend  | Python     |           5000 |
| API      | Go         |           8080 |

Docker configuration is located in the individual application directories and the project `docker-compose.yml`.

---

# ☸️ Kubernetes

The application runs on an Amazon EKS cluster.

Current cluster nodes:

```text
ip-10-0-11-83.ap-south-1.compute.internal
ip-10-0-12-17.ap-south-1.compute.internal
```

Both nodes are currently:

```text
STATUS: Ready
```

Application namespace:

```text
multi-cloud
```

The application is deployed with two replicas for each service.

### Current deployments

```text
api-api             2/2
backend-backend     2/2
frontend-frontend   2/2
```

---

# 📦 Kubernetes Services

The application uses Kubernetes `ClusterIP` services for internal communication.

| Service           | Type      | Port |
| ----------------- | --------- | ---: |
| api-api           | ClusterIP | 8080 |
| backend-backend   | ClusterIP | 5000 |
| frontend-frontend | ClusterIP | 3000 |

---

# 🌐 Ingress

The frontend is exposed through an NGINX-based Kubernetes Ingress.

Current ingress:

```text
Name:     frontend-frontend
Class:     nginx
Host:      frontend.local
Port:      80
```

The AWS load balancer is provisioned through the Kubernetes ingress infrastructure.

Example:

```text
frontend.local
      │
      ▼
NGINX Ingress
      │
      ▼
Frontend Service
      │
      ▼
Frontend Pods
```

---

# ⎈ Helm

Helm is used to package and deploy the application services.

The project contains three application charts:

```text
helm/
├── api/
├── backend/
└── frontend/
```

Current Helm releases:

```text
api
backend
frontend
monitoring
```

Current status:

```text
api         deployed
backend     deployed
frontend    deployed
monitoring  deployed
```

---

# 📊 Monitoring

The platform uses the **kube-prometheus-stack** for Kubernetes monitoring.

Monitoring namespace:

```text
monitoring
```

Components include:

* Prometheus
* Grafana
* Alertmanager
* Prometheus Operator
* Node Exporter
* kube-state-metrics

---

## Prometheus

Prometheus is used to collect application and Kubernetes metrics.

Current Prometheus version:

```text
v3.13.2-distroless
```

Prometheus service:

```text
monitoring-kube-prometheus-prometheus
```

Port:

```text
9090
```

---

## Grafana

Grafana provides dashboards for monitoring:

* Kubernetes nodes
* Pods
* CPU utilization
* Memory utilization
* Network metrics
* Application metrics
* Prometheus metrics

Grafana service:

```text
monitoring-grafana
```

Port:

```text
80
```

---

## Alertmanager

Alertmanager handles alerts generated by Prometheus.

Current Alertmanager pod:

```text
alertmanager-monitoring-kube-prometheus-alertmanager-0
```

---

## ServiceMonitors

The monitoring stack currently contains ServiceMonitor resources for:

* Grafana
* Alertmanager
* Kubernetes API server
* CoreDNS
* kube-controller-manager
* kube-etcd
* kube-proxy
* kube-scheduler
* kubelet
* Prometheus Operator
* Prometheus
* kube-state-metrics
* Node Exporter

---

# 🔎 Application Metrics

The application exposes metrics endpoints that can be scraped by Prometheus.

Example endpoints:

```text
http://api:8080/metrics
http://backend:5000/metrics
```

Prometheus target health can be checked from:

```text
http://localhost:9090/targets
```

Example healthy targets:

```text
api        UP
backend    UP
prometheus UP
```

---

# 🔄 CI/CD Pipeline

GitHub Actions provides automated CI/CD.

The pipeline follows:

```text
Developer
    │
    ▼
Git Push
    │
    ▼
GitHub Actions
    │
    ├── Checkout
    │
    ├── Code Quality
    │
    ├── SonarQube Analysis
    │
    ├── Docker Build
    │
    ├── Container Image Push
    │
    └── Deployment
            │
            ▼
        Amazon EKS
```

---

# 🧪 Continuous Integration

The CI workflow performs tasks such as:

1. Checkout source code
2. Set up required runtimes
3. Run application validation
4. Perform SonarQube analysis
5. Build Docker images
6. Authenticate with container registry
7. Push images
8. Validate Helm charts

Workflow file:

```text
.github/workflows/ci.yml
```

---

# 🚀 Continuous Deployment

The CD workflow deploys the application to Kubernetes.

Workflow file:

```text
.github/workflows/cd.yml
```

The deployment process includes:

```text
CI Success
    │
    ▼
CD Workflow
    │
    ▼
Container Images
    │
    ▼
Helm Deployment
    │
    ▼
Amazon EKS
    │
    ▼
Rolling Update
```

---

# 🧹 Destroy Workflow

Infrastructure cleanup is automated through:

```text
.github/workflows/destroy.yml
```

Terraform is used to destroy AWS infrastructure when required.

**Warning:** Destroy operations can remove cloud resources and generate charges or data loss. Humanity invented `-auto-approve`, which is useful right up until someone points it at production.

---

# 🔐 Security

The project follows several cloud security practices.

### IAM

AWS IAM roles are used instead of embedding long-lived AWS credentials inside application containers.

### Kubernetes namespaces

Application and monitoring resources are separated:

```text
multi-cloud
monitoring
```

### Network isolation

The AWS architecture separates public and private networking resources.

### Secrets

Sensitive credentials should be stored using:

* GitHub Actions Secrets
* Kubernetes Secrets
* AWS IAM
* AWS Systems Manager where applicable

Never commit credentials directly into Git.

---

# 📁 Project Structure

```text
multi-cloud-devops-platform/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── destroy.yml
│
├── terraform/
│   ├── modules/
│   ├── environments/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── ingress.yaml
│   └── ...
│
├── helm/
│   ├── api/
│   ├── backend/
│   └── frontend/
│
├── nexus/
│
├── sonar/
│
├── scripts/
│
├── docs/
│   ├── Architecture.md
│   ├── cicd.md
│   ├── deployment.md
│   ├── kuberneties.md
│   └── screenshots/
│
├── docker-compose.yml
├── Makefile
├── README.md
└── LICENSE
```

---

# 🛠️ Technologies Used

| Category           | Technology         |
| ------------------ | ------------------ |
| Cloud              | AWS                |
| Infrastructure     | Terraform          |
| Containers         | Docker             |
| Orchestration      | Kubernetes         |
| Managed Kubernetes | Amazon EKS         |
| Package Management | Helm               |
| CI/CD              | GitHub Actions     |
| Container Registry | Amazon ECR         |
| Code Quality       | SonarQube          |
| Repository Manager | Nexus              |
| Monitoring         | Prometheus         |
| Visualization      | Grafana            |
| Alerting           | Alertmanager       |
| Metrics            | Node Exporter      |
| Kubernetes Metrics | kube-state-metrics |
| Frontend           | Node.js            |
| Backend            | Python             |
| API                | Go                 |
| Source Control     | Git / GitHub       |
| Automation         | Make               |

---

# 🧰 Prerequisites

Install the following tools:

* Git
* Docker Desktop
* AWS CLI
* Terraform
* kubectl
* Helm
* GitHub CLI
* GNU Make
* Node.js
* Python
* Go

Verify installations:

```powershell
git --version
docker --version
aws --version
terraform version
kubectl version --client
helm version
gh --version
make --version
```

---

# 🔧 AWS Configuration

Configure AWS CLI:

```powershell
aws configure
```

Set the AWS region:

```text
ap-south-1
```

Verify AWS access:

```powershell
aws sts get-caller-identity
```

---

# ☸️ Connect to EKS

Update the local kubeconfig:

```powershell
aws eks update-kubeconfig `
  --region ap-south-1 `
  --name devops-eks-cluster
```

Verify:

```powershell
kubectl get nodes
```

Expected result:

```text
STATUS
Ready
Ready
```

---

# 🏗️ Terraform Commands

Initialize Terraform:

```powershell
make tf-init
```

Format Terraform:

```powershell
make tf-fmt
```

Validate Terraform:

```powershell
make tf-validate
```

Create execution plan:

```powershell
make tf-plan
```

Apply infrastructure:

```powershell
make tf-apply
```

View outputs:

```powershell
make tf-output
```

View Terraform state:

```powershell
make tf-state
```

Destroy infrastructure:

```powershell
make tf-destroy
```

---

# ⎈ Helm Commands

Lint all charts:

```powershell
make helm-lint
```

Render templates:

```powershell
make helm-template
```

View releases:

```powershell
make helm-status
```

Deploy application:

```powershell
make helm-deploy
```

Uninstall application charts:

```powershell
make helm-uninstall
```

---

# ☸️ Kubernetes Commands

Check cluster:

```powershell
make k8s-status
```

Check pods:

```powershell
make k8s-pods
```

Check services:

```powershell
make k8s-services
```

Check ingress:

```powershell
make k8s-ingress
```

Deploy applications:

```powershell
make k8s-deploy
```

Check rollout:

```powershell
make k8s-rollout
```

Restart deployments:

```powershell
make k8s-restart
```

View Kubernetes events:

```powershell
make k8s-events
```

---

# 📈 Monitoring Commands

Check monitoring components:

```powershell
make monitoring-status
```

Install monitoring stack:

```powershell
make monitoring-install
```

Forward Grafana:

```powershell
make grafana
```

Then open:

```text
http://localhost:3001
```

Forward Prometheus:

```powershell
make prometheus
```

Then open:

```text
http://localhost:9090
```

Check monitoring targets:

```powershell
make monitoring-targets
```

---

# 🔄 CI/CD Commands

View CI runs:

```powershell
make ci-status
```

View CD runs:

```powershell
make cd-status
```

View recent workflows:

```powershell
make workflows
```

Watch the latest CI workflow:

```powershell
make ci-watch
```

Watch the latest CD workflow:

```powershell
make cd-watch
```

---

# 🧪 Validation

Run the complete validation:

```powershell
make validate
```

This checks:

* Terraform configuration
* Helm charts
* Kubernetes nodes
* Application pods

Expected result:

```text
Terraform:
Success! The configuration is valid.

Helm:
1 chart(s) linted, 0 chart(s) failed

Kubernetes:
Nodes Ready
Pods Running
```

---

# 📋 Project Status

Use:

```powershell
make status
```

This displays:

* Kubernetes nodes
* Application pods
* Deployments
* Services
* Ingress
* Helm releases
* Monitoring pods
* Recent CI/CD runs

Current project state:

```text
Kubernetes Nodes
2/2 Ready

API
2/2 Running

Backend
2/2 Running

Frontend
2/2 Running

Helm
api        deployed
backend    deployed
frontend   deployed
monitoring  deployed

Monitoring
Prometheus       Running
Grafana          Running
Alertmanager     Running
Node Exporter    Running
kube-state-metrics Running
```

---

# 🐳 Docker Compose

For local development:

Build images:

```powershell
make docker-build
```

Start services:

```powershell
make docker-up
```

Check containers:

```powershell
make docker-ps
```

View logs:

```powershell
make docker-logs
```

Stop services:

```powershell
make docker-down
```

Restart services:

```powershell
make docker-restart
```

Clean Docker Compose resources:

```powershell
make docker-clean
```

---

# 📸 Documentation and Evidence

Project evidence is stored in:

```text
docs/screenshots/
```

The documentation includes evidence for:

* AWS infrastructure
* Kubernetes cluster
* Application deployment
* Helm
* CI/CD
* Prometheus
* Grafana
* Monitoring targets
* Project architecture

Documentation files:

```text
docs/
├── Architecture.md
├── cicd.md
├── deployment.md
├── kuberneties.md
└── screenshots/
```

---

# 📊 Current Validation Evidence

The project has successfully demonstrated:

### Terraform

```text
Success! The configuration is valid.
```

### Helm

```text
api       1 chart(s) linted, 0 chart(s) failed
backend   1 chart(s) linted, 0 chart(s) failed
frontend  1 chart(s) linted, 0 chart(s) failed
```

The Helm icon messages are informational warnings, not failures.

### Kubernetes

```text
2 nodes Ready
```

### Application

```text
API       2/2 Running
Backend   2/2 Running
Frontend  2/2 Running
```

### Monitoring

```text
Prometheus       Running
Grafana          Running
Alertmanager     Running
Node Exporter    Running
kube-state-metrics Running
```

### CI/CD

Recent CI and CD workflows have completed successfully.

---

# 🔍 Useful Troubleshooting

## Check all pods

```powershell
kubectl get pods -A
```

## Check application pods

```powershell
kubectl get pods -n multi-cloud
```

## Check monitoring pods

```powershell
kubectl get pods -n monitoring
```

## Check services

```powershell
kubectl get svc -n multi-cloud
```

## Check ingress

```powershell
kubectl get ingress -n multi-cloud
```

## Check Helm

```powershell
helm list -A
```

## Check Kubernetes events

```powershell
kubectl get events -n multi-cloud --sort-by=.lastTimestamp
```

## Check deployment details

```powershell
kubectl describe deployment api-api -n multi-cloud
kubectl describe deployment backend-backend -n multi-cloud
kubectl describe deployment frontend-frontend -n multi-cloud
```

## Check pod logs

```powershell
kubectl logs -n multi-cloud deployment/api-api
```

```powershell
kubectl logs -n multi-cloud deployment/backend-backend
```

```powershell
kubectl logs -n multi-cloud deployment/frontend-frontend
```

---

# 🔐 Environment Variables and Secrets

The following types of values should be configured outside source control:

```text
AWS credentials
AWS region
ECR credentials
SonarQube token
Nexus credentials
GitHub secrets
Kubernetes secrets
Database credentials
```

Never commit:

```text
.env
*.pem
*.key
credentials
passwords
tokens
AWS access keys
```

Use `.gitignore` to prevent accidental commits.

---

# 🔁 Deployment Workflow

The complete deployment lifecycle is:

```text
1. Developer commits code
             │
             ▼
2. Git push to GitHub
             │
             ▼
3. GitHub Actions CI
             │
             ├── Checkout
             ├── Build
             ├── Test
             ├── SonarQube
             ├── Docker Build
             └── Image Push
             │
             ▼
4. CD Workflow
             │
             ▼
5. Helm Deployment
             │
             ▼
6. Amazon EKS
             │
             ▼
7. Kubernetes Rolling Update
             │
             ▼
8. Prometheus Monitoring
             │
             ▼
9. Grafana Visualization
```

---

# 🧭 Development Workflow

Recommended development process:

```text
Create feature
      │
      ▼
Develop locally
      │
      ▼
Run Docker Compose
      │
      ▼
Run tests
      │
      ▼
Run Make validation
      │
      ▼
Commit changes
      │
      ▼
Push to GitHub
      │
      ▼
CI
      │
      ▼
CD
      │
      ▼
EKS
      │
      ▼
Monitoring
```

---

# 🎯 Project Objectives

This project demonstrates practical knowledge of:

* AWS cloud infrastructure
* Infrastructure as Code
* Terraform
* Docker
* Kubernetes
* Amazon EKS
* Helm
* GitHub Actions
* CI/CD automation
* Container registries
* SonarQube
* Nexus
* Prometheus
* Grafana
* Alertmanager
* Kubernetes monitoring
* Linux and shell automation
* Git and GitHub
* Makefile automation

---

# 📚 Learning Outcomes

By completing this project, the following DevOps concepts are demonstrated:

### Cloud

* AWS VPC architecture
* Public and private networking
* IAM
* EKS
* ECR
* Load balancing
* Security groups

### Infrastructure

* Terraform modules
* Terraform state
* Variables
* Outputs
* Infrastructure validation

### Containers

* Dockerfiles
* Docker Compose
* Multi-service applications
* Container image management

### Kubernetes

* Pods
* Deployments
* Services
* Ingress
* Namespaces
* Rolling updates
* Health checks

### Helm

* Helm charts
* Values
* Templates
* Releases
* Upgrade and rollback concepts

### CI/CD

* GitHub Actions
* Automated builds
* Code analysis
* Docker image publishing
* Automated deployment

### Monitoring

* Prometheus
* Grafana
* Alertmanager
* ServiceMonitor
* Node Exporter
* kube-state-metrics

---

# 🏆 Project Highlights

The project currently demonstrates:

```text
✓ AWS infrastructure managed with Terraform
✓ Amazon EKS Kubernetes cluster
✓ Two Kubernetes worker nodes
✓ Three containerized microservices
✓ Two replicas per application
✓ Helm-based deployment
✓ NGINX Ingress
✓ AWS Load Balancer
✓ GitHub Actions CI
✓ GitHub Actions CD
✓ Docker image build and publishing
✓ SonarQube integration
✓ Nexus integration
✓ Prometheus monitoring
✓ Grafana dashboards
✓ Alertmanager
✓ Node Exporter
✓ kube-state-metrics
✓ Makefile automation
✓ Project documentation
✓ Monitoring evidence screenshots
```

---

# 📌 Final Project Status

```text
================================================
        MULTI-CLOUD DEVOPS PLATFORM
================================================

Infrastructure       : AWS
Region               : ap-south-1
Kubernetes           : Amazon EKS
Application Namespace: multi-cloud
Monitoring Namespace : monitoring

API                  : 2/2 Running
Backend              : 2/2 Running
Frontend             : 2/2 Running

Kubernetes Nodes     : 2/2 Ready

Helm API             : Deployed
Helm Backend         : Deployed
Helm Frontend        : Deployed
Helm Monitoring      : Deployed

Prometheus           : Running
Grafana              : Running
Alertmanager         : Running
Node Exporter        : Running
kube-state-metrics   : Running

Terraform Validation : Passed
Helm Lint            : Passed
CI                   : Passed
CD                   : Passed

Overall Status       : OPERATIONAL
================================================
```

---

# 👨‍💻 Author

**Masunuri Bavajan**

DevOps & Multicloud Engineer

GitHub:

`https://github.com/bavajanmasunuri539-hue`

LinkedIn:

`https://www.linkedin.com/in/bavajan-masunuri-1406453a4`

---

# 📄 License

This project is licensed under the terms specified in the repository `LICENSE` file.

---

# ⭐ Summary

The **Multi-Cloud DevOps Platform** demonstrates an end-to-end DevOps implementation using AWS, Terraform, Docker, Kubernetes, Helm, GitHub Actions, SonarQube, Nexus, Prometheus, and Grafana.

The platform provides automated infrastructure provisioning, containerized application deployment, Kubernetes orchestration, CI/CD automation, and centralized monitoring.

It is designed as a practical portfolio project demonstrating the complete lifecycle:

```text
Code
 ↓
Build
 ↓
Test
 ↓
Analyze
 ↓
Containerize
 ↓
Publish
 ↓
Deploy
 ↓
Orchestrate
 ↓
Monitor
 ↓
Operate
```

The result is a repeatable cloud-native deployment platform with infrastructure automation, application automation, and observability integrated into a single DevOps workflow.


multi-cloud-devops-platform/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── destroy.yml
│
├── api/
│   ├── src/
│   │   ├── main.go
│   │   ├── go.mod
│   │   └── go.sum
│   └── Dockerfile
│
├── backend/
│   ├── app/
│   │   ├── app.py
│   │   └── requirements.txt
│   └── Dockerfile
│
├── frontend/
│   ├── src/
│   ├── package.json
│   ├── package-lock.json
│   └── Dockerfile
│
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── terraform.tfvars
│   │
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── eks/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── ec2/
│   │   ├── ecr/
│   │   ├── rds/
│   │   └── alb/
│   │
│   └── environments/
│       └── prod/
│
├── helm/
│   ├── api/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── configmap.yaml
│   │       └── _helpers.tpl
│   │
│   ├── backend/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── configmap.yaml
│   │       └── _helpers.tpl
│   │
│   └── frontend/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── configmap.yaml
│           └── _helpers.tpl
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── ingress.yaml
│   ├── api/
│   ├── backend/
│   └── frontend/
│
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   ├── alertmanager/
│   └── servicemonitors/
│
├── nexus/
│   ├── README.md
│   └── configuration/
│
├── sonar/
│   ├── README.md
│   └── sonar-project.properties
│
├── scripts/
│   ├── deploy.sh
│   ├── health-check.sh
│   ├── install.sh
│   └── cleanup.sh
│
├── docs/
│   ├── Architecture.md
│   ├── cicd.md
│   ├── deployment.md
│   ├── kubernetes.md
│   ├── monitoring.md
│   ├── terraform.md
│   ├── troubleshooting.md
│   │
│   └── screenshots/
│       ├── Architecture.md
│       ├── Screenshot 2026-08-11 110610.png
│       ├── Screenshot 2026-08-11 110634.png
│       ├── Screenshot 2026-08-11 122052.png
│       ├── Screenshot 2026-08-11 122356.png
│       ├── Screenshot 2026-08-11 133518.png
│       ├── Screenshot 2026-08-11 133531.png
│       ├── Screenshot 2026-08-11 133706.png
│       ├── Screenshot 2026-08-11 133816.png
│       └── Screenshot 2026-08-11 133850.png
│
├── docker-compose.yml
├── Makefile
├── README.md
├── LICENSE
└── .gitignore
