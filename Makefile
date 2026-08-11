PROJECT_NAME := multi-cloud-devops-platform
NAMESPACE := multi-cloud
MONITORING_NAMESPACE := monitoring
AWS_REGION := ap-south-1
REPO := bavajanmasunuri539-hue/multi-cloud-devops-platform

.PHONY: help

help:
	@echo "=============================================="
	@echo " Multi-Cloud DevOps Platform - Makefile"
	@echo "=============================================="
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build       Build all Docker images"
	@echo "  make docker-up          Start Docker Compose"
	@echo "  make docker-down        Stop Docker Compose"
	@echo "  make docker-restart     Restart Docker Compose"
	@echo "  make docker-ps          Show Docker containers"
	@echo "  make docker-logs        Show Docker logs"
	@echo "  make docker-clean       Remove Docker containers"
	@echo ""
	@echo "Terraform:"
	@echo "  make tf-init            Initialize Terraform"
	@echo "  make tf-fmt             Format Terraform"
	@echo "  make tf-validate        Validate Terraform"
	@echo "  make tf-plan            Run Terraform plan"
	@echo "  make tf-apply           Apply Terraform"
	@echo "  make tf-destroy         Destroy Terraform infrastructure"
	@echo "  make tf-output          Show Terraform outputs"
	@echo "  make tf-state            Show Terraform state"
	@echo ""
	@echo "Kubernetes:"
	@echo "  make k8s-status         Show cluster nodes"
	@echo "  make k8s-pods           Show application pods"
	@echo "  make k8s-services       Show services"
	@echo "  make k8s-ingress        Show ingress"
	@echo "  make k8s-deploy         Deploy applications"
	@echo "  make k8s-deployments     Show deployments"
	@echo "  make k8s-rollout        Check rollout status"
	@echo "  make k8s-restart        Restart applications"
	@echo "  make k8s-events         Show Kubernetes events"
	@echo ""
	@echo "Helm:"
	@echo "  make helm-lint          Lint all Helm charts"
	@echo "  make helm-template      Render Helm templates"
	@echo "  make helm-status        Show Helm releases"
	@echo "  make helm-deploy        Deploy Helm charts"
	@echo "  make helm-uninstall     Uninstall application charts"
	@echo ""
	@echo "Monitoring:"
	@echo "  make monitoring-status  Show Prometheus/Grafana"
	@echo "  make monitoring-targets Show monitoring targets"
	@echo "  make monitoring-install Install Prometheus/Grafana"
	@echo "  make grafana            Port-forward Grafana"
	@echo "  make prometheus         Port-forward Prometheus"
	@echo ""
	@echo "CI/CD:"
	@echo "  make ci-status          Show latest CI runs"
	@echo "  make cd-status          Show latest CD runs"
	@echo "  make workflows          Show recent GitHub Actions"
	@echo "  make ci-watch           Watch latest CI run"
	@echo "  make cd-watch           Watch latest CD run"
	@echo ""
	@echo "Validation:"
	@echo "  make validate            Validate project"
	@echo "  make status              Show complete project status"
	@echo "  make all                 Run complete validation"
	@echo ""

# ============================================================
# DOCKER
# ============================================================

.PHONY: docker-build
docker-build:
	docker compose build

.PHONY: docker-up
docker-up:
	docker compose up -d

.PHONY: docker-down
docker-down:
	docker compose down

.PHONY: docker-restart
docker-restart:
	docker compose down
	docker compose up -d

.PHONY: docker-ps
docker-ps:
	docker compose ps

.PHONY: docker-logs
docker-logs:
	docker compose logs -f

.PHONY: docker-clean
docker-clean:
	docker compose down --remove-orphans

# ============================================================
# TERRAFORM
# ============================================================

.PHONY: tf-init
tf-init:
	terraform -chdir=terraform init

.PHONY: tf-fmt
tf-fmt:
	terraform -chdir=terraform fmt -recursive

.PHONY: tf-validate
tf-validate:
	terraform -chdir=terraform validate

.PHONY: tf-plan
tf-plan:
	terraform -chdir=terraform plan

.PHONY: tf-apply
tf-apply:
	terraform -chdir=terraform apply -auto-approve

.PHONY: tf-destroy
tf-destroy:
	terraform -chdir=terraform destroy -auto-approve

.PHONY: tf-output
tf-output:
	terraform -chdir=terraform output

.PHONY: tf-state
tf-state:
	terraform -chdir=terraform state list

# ============================================================
# KUBERNETES
# ============================================================

.PHONY: k8s-status
k8s-status:
	kubectl get nodes -o wide

.PHONY: k8s-pods
k8s-pods:
	kubectl get pods -n $(NAMESPACE) -o wide

.PHONY: k8s-services
k8s-services:
	kubectl get svc -n $(NAMESPACE)

.PHONY: k8s-ingress
k8s-ingress:
	kubectl get ingress -n $(NAMESPACE)

.PHONY: k8s-deployments
k8s-deployments:
	kubectl get deployments -n $(NAMESPACE)

.PHONY: k8s-deploy
k8s-deploy:
	helm upgrade --install api ./helm/api -n $(NAMESPACE) --create-namespace
	helm upgrade --install backend ./helm/backend -n $(NAMESPACE) --create-namespace
	helm upgrade --install frontend ./helm/frontend -n $(NAMESPACE) --create-namespace

.PHONY: k8s-rollout
k8s-rollout:
	kubectl rollout status deployment/api-api -n $(NAMESPACE)
	kubectl rollout status deployment/backend-backend -n $(NAMESPACE)
	kubectl rollout status deployment/frontend-frontend -n $(NAMESPACE)

.PHONY: k8s-restart
k8s-restart:
	kubectl rollout restart deployment/api-api -n $(NAMESPACE)
	kubectl rollout restart deployment/backend-backend -n $(NAMESPACE)
	kubectl rollout restart deployment/frontend-frontend -n $(NAMESPACE)

.PHONY: k8s-events
k8s-events:
	kubectl get events -n $(NAMESPACE) --sort-by=.lastTimestamp

.PHONY: k8s-delete
k8s-delete:
	kubectl delete namespace $(NAMESPACE)

# ============================================================
# HELM
# ============================================================

.PHONY: helm-lint
helm-lint:
	helm lint ./helm/api
	helm lint ./helm/backend
	helm lint ./helm/frontend

.PHONY: helm-template
helm-template:
	helm template api ./helm/api
	helm template backend ./helm/backend
	helm template frontend ./helm/frontend

.PHONY: helm-status
helm-status:
	helm list -A

.PHONY: helm-deploy
helm-deploy:
	helm upgrade --install api ./helm/api -n $(NAMESPACE) --create-namespace
	helm upgrade --install backend ./helm/backend -n $(NAMESPACE) --create-namespace
	helm upgrade --install frontend ./helm/frontend -n $(NAMESPACE) --create-namespace

.PHONY: helm-uninstall
helm-uninstall:
	helm uninstall api -n $(NAMESPACE) || true
	helm uninstall backend -n $(NAMESPACE) || true
	helm uninstall frontend -n $(NAMESPACE) || true

# ============================================================
# MONITORING
# ============================================================

.PHONY: monitoring-status
monitoring-status:
	kubectl get pods -n $(MONITORING_NAMESPACE)
	kubectl get svc -n $(MONITORING_NAMESPACE)
	kubectl get prometheus -n $(MONITORING_NAMESPACE)
	kubectl get servicemonitors -n $(MONITORING_NAMESPACE)

.PHONY: monitoring-install
monitoring-install:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
		-n $(MONITORING_NAMESPACE) \
		--create-namespace \
		--set grafana.enabled=true \
		--set prometheus.enabled=true

.PHONY: grafana
grafana:
	kubectl port-forward svc/monitoring-grafana 3001:80 -n $(MONITORING_NAMESPACE)

.PHONY: prometheus
prometheus:
	kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 -n $(MONITORING_NAMESPACE)

.PHONY: monitoring-targets
monitoring-targets:
	kubectl get servicemonitors -n $(MONITORING_NAMESPACE)
	kubectl get prometheus -n $(MONITORING_NAMESPACE)

# ============================================================
# CI/CD
# ============================================================

.PHONY: ci-status
ci-status:
	gh run list --repo $(REPO) --workflow CI --limit 5

.PHONY: cd-status
cd-status:
	gh run list --repo $(REPO) --workflow CD --limit 5

.PHONY: workflows
workflows:
	gh run list --repo $(REPO) --limit 10

.PHONY: ci-watch
ci-watch:
	gh run watch $$(gh run list --repo $(REPO) --workflow CI --limit 1 --json databaseId --jq '.[0].databaseId') --repo $(REPO)

.PHONY: cd-watch
cd-watch:
	gh run watch $$(gh run list --repo $(REPO) --workflow CD --limit 1 --json databaseId --jq '.[0].databaseId') --repo $(REPO)

# ============================================================
# VALIDATION
# ============================================================

.PHONY: validate
validate:
	terraform -chdir=terraform validate
	helm lint ./helm/api
	helm lint ./helm/backend
	helm lint ./helm/frontend
	kubectl get nodes
	kubectl get pods -n $(NAMESPACE)

.PHONY: status
status:
	@echo "=============================================="
	@echo " PROJECT STATUS"
	@echo "=============================================="
	@echo ""
	@echo "=== Kubernetes Nodes ==="
	kubectl get nodes
	@echo ""
	@echo "=== Application Pods ==="
	kubectl get pods -n $(NAMESPACE)
	@echo ""
	@echo "=== Deployments ==="
	kubectl get deployments -n $(NAMESPACE)
	@echo ""
	@echo "=== Services ==="
	kubectl get svc -n $(NAMESPACE)
	@echo ""
	@echo "=== Ingress ==="
	kubectl get ingress -n $(NAMESPACE)
	@echo ""
	@echo "=== Helm Releases ==="
	helm list -A
	@echo ""
	@echo "=== Monitoring ==="
	kubectl get pods -n $(MONITORING_NAMESPACE)
	@echo ""
	@echo "=== Recent CI/CD ==="
	gh run list --repo $(REPO) --limit 5

# ============================================================
# COMPLETE CHECK
# ============================================================

.PHONY: all
all: validate helm-lint k8s-status k8s-pods monitoring-status ci-status cd-status
	@echo ""
	@echo "=============================================="
	@echo " ALL CHECKS COMPLETED"
	@echo "=============================================="