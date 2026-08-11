# CI/CD Pipeline

## 1. Overview

The project uses GitHub Actions to automate Continuous Integration and Continuous Deployment.

The pipeline automatically:

1. Checks out the source code.
2. Performs SonarQube analysis.
3. Builds Docker images.
4. Pushes images to Amazon ECR.
5. Deploys the application to Amazon EKS.
6. Verifies Kubernetes deployments.

---

## 2. CI/CD Architecture

```text
Developer
    |
    v
Git Push
    |
    v
GitHub Repository
    |
    v
+----------------------+
|       CI Workflow    |
+----------------------+
          |
          +--> Checkout
          |
          +--> SonarQube
          |
          +--> Docker Build
          |
          +--> ECR Push
          |
          v
+----------------------+
|       CD Workflow    |
+----------------------+
          |
          +--> AWS Authentication
          |
          +--> Update kubeconfig
          |
          +--> Deploy API
          |
          +--> Deploy Backend
          |
          +--> Deploy Frontend
          |
          +--> Verify Deployment
          |
          v
       Amazon EKS
```

---

## 3. GitHub Actions Workflows

The project contains:

```text
.github/
└── workflows/
    ├── ci.yml
    ├── cd.yml
    └── destroy.yml
```

### CI Workflow

File:

```text
.github/workflows/ci.yml
```

The CI workflow is triggered when changes are pushed to the `main` branch.

Main stages:

```text
Checkout
   |
   v
SonarQube Analysis
   |
   v
Configure AWS
   |
   v
Login to ECR
   |
   v
Build API
   |
   v
Build Backend
   |
   v
Build Frontend
   |
   v
Push Images to ECR
```

---

## 4. SonarQube Analysis

SonarQube is used to perform static code analysis.

The pipeline executes:

```text
SonarQube Scan
```

This provides automated code quality analysis before container images are pushed.

---

## 5. Docker Image Build

Three application images are built:

```text
API
Backend
Frontend
```

Example flow:

```text
api/Dockerfile
      |
      v
Docker Build
      |
      v
API Image
      |
      v
Amazon ECR
```

The same process is used for Backend and Frontend.

---

## 6. Amazon ECR

Amazon Elastic Container Registry stores the application images.

```text
GitHub Actions
      |
      v
AWS Credentials
      |
      v
Amazon ECR Login
      |
      v
Docker Push
```

ECR is used as the private container registry for Kubernetes deployments.

---

## 7. CD Workflow

File:

```text
.github/workflows/cd.yml
```

The CD workflow is triggered after successful CI execution.

Deployment flow:

```text
Successful CI
     |
     v
CD Workflow
     |
     v
Configure AWS Credentials
     |
     v
Update kubeconfig
     |
     v
Amazon EKS
     |
     +--> API Deployment
     |
     +--> Backend Deployment
     |
     +--> Frontend Deployment
     |
     v
Deployment Verification
```

---

## 8. Kubernetes Deployment

The CD pipeline deploys the application into:

```text
multi-cloud
```

namespace.

Current deployment configuration:

| Application | Replicas | Status  |
| ----------- | -------: | ------- |
| API         |        2 | Running |
| Backend     |        2 | Running |
| Frontend    |        2 | Running |

Helm is used to manage the application deployments.

---

## 9. Deployment Verification

The CD workflow verifies Kubernetes resources after deployment.

Typical verification commands include:

```bash
kubectl get deployments -n multi-cloud
kubectl get pods -n multi-cloud
kubectl get services -n multi-cloud
kubectl get ingress -n multi-cloud
```

A successful deployment should show:

```text
READY 2/2
STATUS Running
```

for the application replicas.

---

## 10. CI/CD Evidence

The latest successful CI run:

```text
Run CI: 31470049497
Status: success
```

CI jobs completed successfully:

```text
✓ SonarQube Analysis
✓ Build and Push Images to ECR
✓ Build and Push API
✓ Build and Push Backend
✓ Build and Push Frontend
```

The latest successful CD run:

```text
Run CD: 31470250095
Status: success
```

CD deployment completed:

```text
✓ Configure AWS credentials
✓ Update kubeconfig
✓ Deploy API
✓ Deploy Backend
✓ Deploy Frontend
✓ Verify deployment
```

---

## 11. CI/CD Benefits

The automated pipeline provides:

* Automated code quality checks
* Automated Docker image creation
* Automated ECR publishing
* Automated Kubernetes deployment
* Repeatable releases
* Reduced manual deployment work
* Deployment verification

---

## 12. Pipeline Summary

```text
Git Push
   |
   v
CI
   |
   +-- SonarQube
   |
   +-- Docker Build
   |
   +-- ECR Push
   |
   v
CD
   |
   +-- EKS Authentication
   |
   +-- Helm Deployment
   |
   +-- Kubernetes Verification
   |
   v
Running Application
```
