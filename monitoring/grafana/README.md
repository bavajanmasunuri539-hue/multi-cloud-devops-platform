# Grafana

Grafana is used to visualize metrics collected by Prometheus for the
Multi-Cloud DevOps Platform.

## Purpose

Grafana provides dashboards for monitoring application services,
containers, infrastructure, and Kubernetes resources.

## Monitoring Architecture

```text
                    +----------------------+
                    |   Microservices      |
                    |----------------------|
                    | Frontend             |
                    | Backend              |
                    | API                  |
                    +----------+-----------+
                               |
                               | Metrics
                               v
                    +----------------------+
                    |     Prometheus       |
                    |      Port 9090        |
                    +----------+-----------+
                               |
                               | PromQL
                               v
                    +----------------------+
                    |       Grafana        |
                    |      Port 3000        |
                    +----------+-----------+
                               |
              +----------------+----------------+
              |                |                |
              v                v                v
        Application      Infrastructure    Kubernetes
         Dashboard         Dashboard        Dashboard
         ## Prometheus Data Source

Grafana uses Prometheus as the primary metrics data source.

When Grafana and Prometheus are running in the same Docker Compose
network, use:

```text
http://prometheus:9090
## Host Access to Prometheus

When Prometheus is exposed to the host machine, it can be accessed
using:

```text
http://localhost:9090