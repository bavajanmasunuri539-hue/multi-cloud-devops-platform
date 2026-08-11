# Monitoring

This directory contains the monitoring configuration for the
Multi-Cloud DevOps Platform.

## Monitoring Stack

The project uses:

- Prometheus for metrics collection
- Grafana for visualization and dashboards

## Architecture

```text
Microservices
     |
     v
Application Metrics
     |
     v
Prometheus
     |
     v
Grafana
     |
     v
Dashboards