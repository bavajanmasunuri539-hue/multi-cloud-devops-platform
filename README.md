# Multi-Cloud DevOps Platform

A production-style **DevOps and cloud-native deployment platform** demonstrating Infrastructure as Code, containerization, Kubernetes orchestration, Helm deployments, CI/CD automation, code quality analysis, container image management, and monitoring.

The platform deploys a three-tier microservices application consisting of:

* **Frontend** — Node.js
* **Backend** — Python
* **API** — Go

The application is containerized with Docker, provisioned using **Terraform**, deployed to **Amazon EKS**, packaged with **Helm**, automated through **GitHub Actions**, analyzed using **SonarQube**, supported by **Nexus Repository Manager**, and monitored using **Prometheus, Grafana, Alertmanager, Node Exporter, and kube-state-metrics**.

> **Current documented cloud deployment: AWS (`ap-south-1`)**

---

# 📌 Project Overview

| Item                   | Details                       |
| ---------------------- | ----------------------------- |
| Project                | `multi-cloud-devops-platform` |
| Cloud Platform         | AWS                           |
| Region                 | `ap-south-1`                  |
| Kubernetes Platform    | Amazon EKS                    |
| Application Namespace  | `multi-cloud`                 |
| Monitoring Namespace   | `monitoring`                  |
| Infrastructure as Code | Terraform                     |
| Containers             | Docker                        |
| Package Management     | Helm                          |
| CI/CD                  | GitHub Actions                |
| Container Registry     | Amazon ECR                    |
| Code Quality           | SonarQube                     |
| Repository Manager     | Nexus                         |
| Monitoring             | Prometheus + Grafana          |
| Alerting               | Alertmanager                  |

---

# 🏗️ Architecture

```text
                         ┌─────────────────────┐
                         │       GitHub        │
                         │   Source Repository │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   GitHub Actions    │
                         │       CI / CD       │
                         └──────────┬──────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
             ┌───────────────┐              ┌───────────────┐
             │ Docker Build  │              │   SonarQube   │
             │ & Image Push  │              │ Code Analysis │
             └───────┬───────┘              └───────────────┘
                     │
                     ▼
              ┌───────────────┐
              │    AWS ECR    │
              │   Container   │
              │   Registry    │
              └───────┬───────┘
                      │
                      ▼
            ┌──────────────────────┐
            │      Amazon EKS      │
            │                      │
            │   NGINX Ingress     │
            │          │           │
            │    ┌─────┴─────┐    │
            │    ▼           ▼    │
            │ Frontend     Backend│
            │ Node.js      Python │
            │                 │    │
            │                 ▼    │
            │                API   │
            │                 Go   │
            └──────────┬───────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │      Monitoring      │
            │                      │
            │ Prometheus           │
            │ Grafana              │
            │ Alertmanager         │
            │ Node Exporter        │
            │ kube-state-metrics   │
            └──────────────────────┘
```

Detailed architecture documentation:

```text
docs/Architecture.md
```

### 📸 Architecture Evidence

```markdown
![AWS and Kubernetes Architecture](docs/screenshots/architecture.png)
```

> Replace the image filename above with the actual architecture screenshot available in the repository.

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
* Amazon EKS
* EKS worker nodes
* Amazon ECR
* Supporting AWS resources

Terraform configuration:

```text
terraform/
```

---

## Terraform Workflow

```text
Terraform Configuration
        │
        ▼
terraform init
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
terraform apply
        │
        ▼
AWS Infrastructure
```

### Terraform State

Terraform currently uses the **local backend** for development and practice.

```text
Terraform
    │
    ▼
Local Backend
    │
    ▼
terraform.tfstate
    │
    ▼
AWS Infrastructure
```

For team-based or production environments, the project can be migrated to a remote **Amazon S3 backend** for centralized state management.

> **Important:** Terraform state files can contain sensitive information and should not be committed to Git.

---

# 🐳 Containerization

Each application service is packaged as a Docker container.

| Service  | Technology | Container Port |
| -------- | ---------- | -------------: |
| Frontend | Node.js    |           3000 |
| Backend  | Python     |           5000 |
| API      | Go         |           8080 |

Docker configuration is located in the individual application directories.

Local development is supported using:

```text
docker-compose.yml
```

---

# ☸️ Kubernetes

The application runs on **Amazon EKS**.

Application namespace:

```text
multi-cloud
```

The application is deployed with multiple replicas for availability.

Example deployment structure:

```text
api-api
backend-backend
frontend-frontend
```

### Kubernetes components

* Pods
* Deployments
* Services
* Ingress
* Namespaces
* ConfigMaps
* Health checks
* Rolling updates

---

# 📦 Kubernetes Services

Internal application communication uses Kubernetes `ClusterIP` services.

| Service             | Type      | Port |
| ------------------- | --------- | ---: |
| `api-api`           | ClusterIP | 8080 |
| `backend-backend`   | ClusterIP | 5000 |
| `frontend-frontend` | ClusterIP | 3000 |

---

# 🌐 Ingress

The frontend is exposed through an NGINX-based Kubernetes Ingress.

```text
Client
  │
  ▼
AWS Load Balancer
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

Example host:

```text
frontend.local
```

Ingress configuration:

```text
kubernetes/ingress.yaml
```

---

# ⎈ Helm

Helm is used to package and deploy the application services.

```text
helm/
├── api/
├── backend/
└── frontend/
```

Each chart contains:

* `Chart.yaml`
* `values.yaml`
* Kubernetes templates
* Deployment configuration
* Service configuration
* ConfigMap configuration

Helm provides repeatable application deployments and simplifies upgrades.

---

# 🔄 CI/CD Pipeline

GitHub Actions provides automated CI/CD.

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
    ├── Validation
    ├── SonarQube Analysis
    ├── Docker Build
    ├── Image Push
    └── Helm Validation
            │
            ▼
       CD Workflow
            │
            ▼
        Amazon EKS
            │
            ▼
      Rolling Update
```

Workflow files:

```text
.github/workflows/
├── ci.yml
├── cd.yml
└── destroy.yml
```

---

# 🧪 Continuous Integration

The CI workflow performs tasks such as:

1. Checkout source code
2. Set up required runtimes
3. Validate application code
4. Run SonarQube analysis
5. Build Docker images
6. Authenticate with the container registry
7. Push container images
8. Validate Helm charts

Workflow:

```text
.github/workflows/ci.yml
```

### 📸 CI Evidence

```markdown
![GitHub Actions CI](docs/screenshots/ci-success.png)
```

> Use the actual screenshot filename from your repository.

---

# 🚀 Continuous Deployment

The CD workflow deploys the application to Kubernetes.

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
Kubernetes Rolling Update
```

Workflow:

```text
.github/workflows/cd.yml
```

### 📸 CD Evidence

```markdown
![GitHub Actions CD](docs/screenshots/cd-success.png)
```

---

# 🔎 Code Quality — SonarQube

SonarQube is integrated into the CI pipeline for automated code-quality analysis.

```text
Source Code
    │
    ▼
SonarQube Analysis
    │
    ▼
Quality Evaluation
    │
    ▼
Docker Build
```

Configuration:

```text
sonar/
```

---

# 📦 Container Repository — Nexus and Amazon ECR

Nexus Repository Manager is included as part of the project's container management tooling.

Configuration and documentation:

```text
nexus/
```

Amazon ECR is used as the AWS container registry.

```text
Application
    │
    ▼
Docker Image
    │
    ▼
Amazon ECR
    │
    ▼
Amazon EKS
```

---

# 📊 Monitoring and Observability

The Kubernetes monitoring stack includes:

* Prometheus
* Grafana
* Alertmanager
* Prometheus Operator
* Node Exporter
* kube-state-metrics

Monitoring namespace:

```text
monitoring
```

---

## Prometheus

Prometheus collects Kubernetes and application metrics.

Example service:

```text
monitoring-kube-prometheus-prometheus
```

Port:

```text
9090
```

Prometheus targets can be inspected from:

```text
http://localhost:9090/targets
```

---

## Grafana

Grafana provides dashboards for:

* Kubernetes nodes
* Pods
* CPU utilization
* Memory utilization
* Network metrics
* Application metrics
* Prometheus metrics

### 📸 Grafana Evidence

```markdown
![Grafana Dashboard](docs/screenshots/grafana.png)
```

---

## Alertmanager

Alertmanager handles alerts generated by Prometheus.

It provides centralized alert processing and routing.

---

## Node Exporter

Node Exporter provides infrastructure-level metrics from Kubernetes worker nodes.

---

## kube-state-metrics

kube-state-metrics exposes Kubernetes object state as metrics for Prometheus.

---

# 📈 Application Metrics

Application metrics endpoints can be exposed for Prometheus scraping.

Examples:

```text
http://api:8080/metrics
http://backend:5000/metrics
```

Check Prometheus targets:

```text
http://localhost:9090/targets
```

---

# 🧹 Destroy Workflow

Infrastructure cleanup is automated through:

```text
.github/workflows/destroy.yml
```

Terraform can destroy AWS infrastructure when required:

```powershell
terraform destroy
```

> ⚠️ **Warning:** Destroy operations can remove cloud resources and may cause data loss. Always review the Terraform plan before performing destructive operations.

---

# 🔐 Security

The project follows several security practices.

## IAM

AWS IAM roles are used for AWS resource access rather than embedding long-lived credentials into application containers.

## Secrets

Sensitive values should be stored outside source control using:

* GitHub Actions Secrets
* Kubernetes Secrets
* AWS IAM
* AWS Systems Manager where applicable

Never commit credentials directly into Git.

## Network Isolation

The AWS architecture separates public and private networking resources.

## Kubernetes Namespaces

Application and monitoring resources are separated:

```text
multi-cloud
monitoring
```

## Files That Must Not Be Committed

```text
.env
*.pem
*.key
credentials
passwords
tokens
AWS access keys
terraform.tfstate
terraform.tfstate.*
```

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
│   │   ├── eks/
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
│   ├── backend/
│   └── frontend/
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
│   └── screenshots/
│
├── docker-compose.yml
├── Makefile
├── README.md
├── LICENSE
└── .gitignore
```

---

# 🛠️ Technologies Used

| Category               | Technology         |
| ---------------------- | ------------------ |
| Cloud                  | AWS                |
| Infrastructure as Code | Terraform          |
| Containers             | Docker             |
| Orchestration          | Kubernetes         |
| Managed Kubernetes     | Amazon EKS         |
| Package Management     | Helm               |
| CI/CD                  | GitHub Actions     |
| Container Registry     | Amazon ECR         |
| Code Quality           | SonarQube          |
| Repository Manager     | Nexus              |
| Monitoring             | Prometheus         |
| Visualization          | Grafana            |
| Alerting               | Alertmanager       |
| Node Metrics           | Node Exporter      |
| Kubernetes Metrics     | kube-state-metrics |
| Frontend               | Node.js            |
| Backend                | Python             |
| API                    | Go                 |
| Source Control         | Git / GitHub       |
| Automation             | Make               |

---

# 🧰 Prerequisites

Install:

* Git
* Docker
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

Update kubeconfig:

```powershell
aws eks update-kubeconfig `
  --region ap-south-1 `
  --name <EKS-CLUSTER-NAME>
```

Verify:

```powershell
kubectl get nodes
```

---

# 🏗️ Terraform Commands

Initialize:

```powershell
make tf-init
```

Format:

```powershell
make tf-fmt
```

Validate:

```powershell
make tf-validate
```

Create plan:

```powershell
make tf-plan
```

Apply:

```powershell
make tf-apply
```

View outputs:

```powershell
make tf-output
```

View state:

```powershell
make tf-state
```

Destroy:

```powershell
make tf-destroy
```

---

# ⎈ Helm Commands

Lint charts:

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

Deploy:

```powershell
make helm-deploy
```

Uninstall:

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

Check rollout:

```powershell
make k8s-rollout
```

Restart deployments:

```powershell
make k8s-restart
```

View events:

```powershell
make k8s-events
```

---

# 📈 Monitoring Commands

Check monitoring:

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

Open:

```text
http://localhost:3001
```

Forward Prometheus:

```powershell
make prometheus
```

Open:

```text
http://localhost:9090
```

Check targets:

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

View workflows:

```powershell
make workflows
```

Watch CI:

```powershell
make ci-watch
```

Watch CD:

```powershell
make cd-watch
```

---

# 🐳 Docker Compose

Build:

```powershell
make docker-build
```

Start:

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

Stop:

```powershell
make docker-down
```

Restart:

```powershell
make docker-restart
```

Clean:

```powershell
make docker-clean
```

---

# 🧪 Validation

Run the complete validation:

```powershell
make validate
```

Validation can include:

* Terraform configuration
* Helm charts
* Kubernetes nodes
* Application pods
* Monitoring components

Example:

```text
Terraform:
Configuration is valid

Helm:
Charts linted successfully

Kubernetes:
Nodes Ready
Pods Running
```

---

# 🔍 Troubleshooting

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

## Check Helm releases

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

## Check application logs

```powershell
kubectl logs -n multi-cloud deployment/api-api
kubectl logs -n multi-cloud deployment/backend-backend
kubectl logs -n multi-cloud deployment/frontend-frontend
```

---

# 📸 Documentation and Evidence

Project documentation is stored under:

```text
docs/
```

Documentation includes:

```text
docs/
├── Architecture.md
├── cicd.md
├── deployment.md
├── kubernetes.md
├── monitoring.md
├── terraform.md
├── troubleshooting.md
└── screenshots/
```

Recommended evidence:

* AWS infrastructure
* Terraform validation
* EKS cluster
* Kubernetes nodes
* Kubernetes pods
* ECR repositories
* CI workflow
* CD workflow
* SonarQube
* Nexus
* Grafana
* Prometheus targets
* Application running

---

# 🔁 Deployment Workflow

```text
1. Developer writes code
          │
          ▼
2. Git push to GitHub
          │
          ▼
3. GitHub Actions CI
          │
          ├── Checkout
          ├── Build
          ├── Validate
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

```text
Create Feature
      │
      ▼
Develop Locally
      │
      ▼
Docker Compose
      │
      ▼
Run Validation
      │
      ▼
Commit Changes
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
Amazon EKS
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
* Amazon ECR
* SonarQube
* Nexus
* Prometheus
* Grafana
* Alertmanager
* Kubernetes monitoring
* Linux and shell automation
* Git and GitHub
* Makefile automation
* Cloud troubleshooting

---

# 🏆 Project Highlights

```text
✓ AWS infrastructure managed with Terraform
✓ Modular Terraform architecture
✓ Amazon EKS Kubernetes cluster
✓ Containerized microservices
✓ Multiple replicas per application
✓ Helm-based deployment
✓ Kubernetes Ingress
✓ AWS Load Balancing
✓ GitHub Actions CI
✓ GitHub Actions CD
✓ Docker image build and publishing
✓ Amazon ECR
✓ SonarQube integration
✓ Nexus integration
✓ Prometheus monitoring
✓ Grafana dashboards
✓ Alertmanager
✓ Node Exporter
✓ kube-state-metrics
✓ Makefile automation
✓ Troubleshooting documentation
✓ Deployment documentation
✓ Monitoring evidence
```

---

# 📊 Project Validation

The project should be considered operational only after the corresponding components have been recently verified.

Example validation checklist:

```text
Terraform        : Validated
Kubernetes       : Verified
Helm             : Verified
CI               : Verified
CD               : Verified
Monitoring       : Verified
Application      : Verified
```

> Update this section whenever the deployment changes so that the README reflects the actual project state.

---

# 📚 Learning Outcomes

## Cloud

* AWS VPC architecture
* Public and private networking
* IAM
* EKS
* ECR
* Load balancing
* Security groups

## Infrastructure

* Terraform modules
* Terraform state
* Variables
* Outputs
* Infrastructure validation

## Containers

* Dockerfiles
* Docker Compose
* Microservices
* Container image management

## Kubernetes

* Pods
* Deployments
* Services
* Ingress
* Namespaces
* Rolling updates
* Health checks

## Helm

* Helm charts
* Values
* Templates
* Releases
* Deployment and upgrade concepts

## CI/CD

* GitHub Actions
* Automated builds
* Code analysis
* Docker image publishing
* Automated deployment

## Monitoring

* Prometheus
* Grafana
* Alertmanager
* ServiceMonitor
* Node Exporter
* kube-state-metrics

---

# 🔮 Future Improvements

Possible enhancements include:

* Remote Terraform state using Amazon S3
* Terraform state locking
* GitHub Actions OIDC authentication
* CloudWatch integration
* Additional Prometheus alert rules
* Custom Grafana dashboards
* Centralized logging
* Automated security scanning
* GitOps using Argo CD
* Azure infrastructure for a true multi-cloud implementation
* Automated integration testing

---

# 👨‍💻 Author

**Masunuri Bavajan**

DevOps & Cloud Engineer

### GitHub

```text
https://github.com/bavajanmasunuri539-hue/multi-cloud-devops-platform
```

### LinkedIn

```text
https://www.linkedin.com/in/bavajan-masunuri-1406453a4
```

---

# 📄 License

This project is licensed under the terms specified in the repository `LICENSE` file.

---

# ⭐ Summary

The **Multi-Cloud DevOps Platform** demonstrates an end-to-end cloud-native DevOps workflow using AWS, Terraform, Docker, Kubernetes, Helm, GitHub Actions, SonarQube, Nexus, Prometheus, Grafana, and Alertmanager.

The platform integrates:

```text
Code
  ↓
Build
  ↓
Validate
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

The result is a repeatable DevOps platform demonstrating **Infrastructure as Code, CI/CD automation, containerization, Kubernetes orchestration, cloud infrastructure, monitoring, security practices, and troubleshooting**.
