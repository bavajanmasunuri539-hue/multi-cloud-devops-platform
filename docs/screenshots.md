![04-prometheus-service monitors.png](<Screenshot 2026-08-11 133850.png>)

![03-monitoring-pods.png](<Screenshot 2026-08-11 133816.png>)


![02-prometheus-up-metrics.png](<Screenshot 2026-08-11 133706.png>)


![01-grafana-dashboard.png](<Screenshot 2026-08-11 133518.png>)


![01-grafana-dashboard.png](<Screenshot 2026-08-11 133531.png>)


![01-grafana-dashboard.png](<Screenshot 2026-08-11 122356.png>)


![02-prometheus-up-metrics.png](<Screenshot 2026-08-11 122052.png>)


![prometheus metrics.png](<Screenshot 2026-08-11 110610.png>)


![prometheus metrics.png](<Screenshot 2026-08-11 110634.png>)






# Project Screenshots & Evidence

This document provides visual evidence for the **Multi-Cloud DevOps Platform** project.

The screenshots demonstrate the successful implementation of infrastructure provisioning, Kubernetes deployment, Helm releases, CI/CD automation, monitoring, and application health.

---

## 1. Architecture

The project architecture consists of:

```text
                    Internet
                       |
                       v
                 AWS Load Balancer
                       |
                       v
                Kubernetes Ingress
                       |
          +------------+------------+
          |            |            |
          v            v            v
       Frontend     Backend        API
       Service      Service      Service
          |            |            |
          +------------+------------+
                       |
                       v
                  AWS EKS Cluster
                       |
          +------------+------------+
          |                         |
       Worker Node 1            Worker Node 2
          |                         |
          +------------+------------+
                       |
                       v
                 AWS Infrastructure
```

**Evidence:** Architecture and infrastructure design screenshots.

---

## 2. Kubernetes Cluster

The EKS cluster contains two worker nodes.

```text
NAME                                        STATUS
ip-10-0-11-83.ap-south-1.compute.internal   Ready
ip-10-0-12-17.ap-south-1.compute.internal   Ready
```

The nodes are running Kubernetes:

```text
v1.33.13-eks-254016e
```

### Evidence

* Kubernetes nodes are in `Ready` state.
* Two worker nodes are available.
* Applications are distributed across the cluster.

---

## 3. Application Pods

The application consists of three microservices:

* API
* Backend
* Frontend

Each application runs with two replicas.

```text
API
  2/2 Running

Backend
  2/2 Running

Frontend
  2/2 Running
```

Current deployment state:

```text
api-api             2/2
backend-backend     2/2
frontend-frontend   2/2
```

This demonstrates Kubernetes replica management and application availability.

---

## 4. Kubernetes Services

The application services are exposed internally through Kubernetes `ClusterIP` services.

```text
api-api
  ClusterIP
  Port: 8080

backend-backend
  ClusterIP
  Port: 5000

frontend-frontend
  ClusterIP
  Port: 3000
```

The services provide internal communication between the application components.

---

## 5. Kubernetes Ingress

The frontend application is exposed through an NGINX Ingress.

```text
Host:
frontend.local

Ingress Class:
nginx

Port:
80
```

The AWS Load Balancer provides the external address for the ingress.

Example:

```text
a83ba88b0a72e40e989eb899d90200e7-576909477.ap-south-1.elb.amazonaws.com
```

This demonstrates external traffic routing through:

```text
Internet
   |
AWS Load Balancer
   |
NGINX Ingress
   |
Frontend Service
   |
Frontend Pods
```

---

## 6. Helm Deployment

The application is deployed using Helm charts.

Current Helm releases:

```text
NAME        NAMESPACE       STATUS
api         multi-cloud     deployed
backend     multi-cloud     deployed
frontend    multi-cloud     deployed
monitoring  monitoring      deployed
```

Application charts:

```text
api-1.0.0
backend-1.0.0
frontend-1.0.0
```

The Helm charts were validated using:

```text
helm lint ./helm/api
helm lint ./helm/backend
helm lint ./helm/frontend
```

Result:

```text
1 chart(s) linted, 0 chart(s) failed
```

---

## 7. Prometheus Monitoring

Prometheus is deployed in the `monitoring` namespace using the kube-prometheus-stack.

Prometheus status:

```text
VERSION:
v3.13.2-distroless

DESIRED:
1

READY:
1

RECONCILED:
True

AVAILABLE:
True
```

Prometheus service:

```text
monitoring-kube-prometheus-prometheus
Port: 9090
```

### Prometheus Targets

The application exposes Prometheus metrics through `/metrics`.

Configured application targets include:

```text
api:8080/metrics
backend:5000/metrics
prometheus:9090/metrics
```

The target health page confirms that the monitored endpoints are `UP`.

---

## 8. Grafana Monitoring

Grafana is deployed in the monitoring namespace.

```text
monitoring-grafana
```

Pod status:

```text
3/3 Running
```

Grafana is used for visualization of:

* Kubernetes cluster metrics
* Node metrics
* Pod metrics
* Application metrics
* Prometheus metrics

Grafana uses Prometheus as its metrics data source.

---

## 9. Alertmanager

Alertmanager is deployed as part of the monitoring stack.

```text
alertmanager-monitoring-kube-prometheus-alertmanager-0
```

Status:

```text
2/2 Running
```

Alertmanager provides alert management for Prometheus monitoring.

---

## 10. Node Exporter

Node Exporter is deployed on the Kubernetes worker nodes.

Current instances:

```text
monitoring-prometheus-node-exporter-m44rm
monitoring-prometheus-node-exporter-v29pn
```

Both instances are running successfully.

Node Exporter provides infrastructure-level metrics for the Kubernetes worker nodes.

---

## 11. Kubernetes ServiceMonitors

The monitoring stack contains multiple ServiceMonitor resources.

Important ServiceMonitors include:

```text
monitoring-grafana
monitoring-kube-prometheus-alertmanager
monitoring-kube-prometheus-apiserver
monitoring-kube-prometheus-coredns
monitoring-kube-prometheus-kubelet
monitoring-kube-prometheus-operator
monitoring-kube-prometheus-prometheus
monitoring-kube-state-metrics
monitoring-prometheus-node-exporter
```

This confirms that Prometheus service discovery is configured through Kubernetes resources.

---

## 12. Terraform Validation

Terraform configuration was successfully validated.

Command:

```text
terraform -chdir=terraform validate
```

Result:

```text
Success! The configuration is valid.
```

This confirms that the Terraform configuration has valid syntax and configuration structure.

---

## 13. Helm Validation

All application Helm charts passed lint validation.

```text
helm lint ./helm/api
helm lint ./helm/backend
helm lint ./helm/frontend
```

Result:

```text
1 chart(s) linted, 0 chart(s) failed
```

The `icon is recommended` message is informational and does not indicate a failure.

---

## 14. CI Pipeline Evidence

GitHub Actions CI successfully completed.

Latest successful CI workflow:

```text
Workflow:
CI

Branch:
main

Status:
Success

Run:
31483934201
```

The CI pipeline validates the application and performs the configured build, analysis, and container-related stages.

---

## 15. CD Pipeline Evidence

GitHub Actions CD successfully completed.

Latest successful CD workflow:

```text
Workflow:
CD

Branch:
main

Status:
Success

Run:
31484155855
```

The successful CD workflow demonstrates automated deployment to the Kubernetes environment.

---

## 16. Makefile Validation

The project includes a Makefile for common DevOps operations.

Examples:

```text
make help
make validate
make status
make helm-lint
make helm-status
make monitoring-status
make ci-status
make cd-status
```

The following validation command completed successfully:

```text
make validate
```

The validation includes:

```text
Terraform validation
Helm linting
Kubernetes node validation
Kubernetes pod validation
```

---

## 17. Project Status Evidence

The complete project status confirms:

```text
Kubernetes Nodes       2/2 Ready
API Pods               2/2 Running
Backend Pods           2/2 Running
Frontend Pods          2/2 Running
Helm Releases          Deployed
Prometheus             Running
Grafana                Running
Alertmanager           Running
Node Exporter          Running
Terraform Validation   Passed
Helm Validation        Passed
CI                     Passed
CD                     Passed
```

---

## 18. Screenshot Evidence

The following screenshots are stored in the project documentation directory.

Recommended location:

```text
docs/screenshots/
```

Recommended evidence categories:

| Screenshot          | Evidence                        |
| ------------------- | ------------------------------- |
| Architecture        | AWS and Kubernetes architecture |
| Kubernetes Nodes    | EKS worker nodes                |
| Kubernetes Pods     | Application pod status          |
| Kubernetes Services | Internal services               |
| Ingress             | AWS Load Balancer / ingress     |
| Helm                | Helm releases                   |
| Prometheus          | Prometheus dashboard            |
| Prometheus Targets  | Target health                   |
| Grafana             | Monitoring dashboard            |
| CI                  | GitHub Actions CI success       |
| CD                  | GitHub Actions CD success       |
| Makefile            | Validation and project status   |

---

## 19. Evidence Summary

The screenshots and command outputs provide evidence that the project implements:

* AWS infrastructure using Terraform
* Amazon EKS Kubernetes cluster
* Containerized microservices
* Kubernetes deployments and services
* NGINX Ingress
* Helm-based application deployment
* GitHub Actions CI/CD
* Prometheus monitoring
* Grafana dashboards
* Alertmanager
* Node Exporter
* Kubernetes ServiceMonitors
* Infrastructure and application validation
* Automated project status checks through Makefile

---

## 20. Final Verification

The project was verified using:

```bash
make validate
make status
make monitoring-status
make helm-status
make ci-status
make cd-status
```

All major project components were operational at the time of verification.

The repository therefore contains both the implementation and supporting evidence required to demonstrate the DevOps workflow from infrastructure provisioning through deployment, CI/CD, and monitoring.
