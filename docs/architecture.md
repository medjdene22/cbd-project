# Architecture Overview

This document describes the **architecture and data flow** of the monitoring stack built with Docker Compose, Prometheus, Grafana, Node Exporter, Logporter, and Cloudflare Tunnel.

---

## 🧱 High-Level Architecture

```text
                    ┌──────────────────────────┐
                    │        Internet          │
                    └────────────┬─────────────┘
                                 │
                         Cloudflare Tunnel
                                 │
                    ┌────────────▼─────────────┐
                    │         Grafana          │
                    │     (Visualization)      │
                    │        :3000             │
                    └────────────┬─────────────┘
                                 │
                        Prometheus Query
                                 │
        ┌────────────────────────▼────────────────────────┐
        │                   Prometheus                    │
        │             (Metrics Storage & Query)           │
        │                     :9090                       │
        └───────────────┬───────────────┬─────────────────┘
                        │               │
                Scrape Metrics     Scrape Metrics
                        │               │
        ┌───────────────▼───┐     ┌─────▼───────────────┐
        │   Node Exporter   │     │      Logporter       │
        │   Host Metrics    │     │   Docker Log Metrics │
        │      :9100        │     │        :9333         │
        └───────────────────┘     └──────────────────────┘
```

---

## 🔄 Data Flow

1. **Node Exporter**
   - Collects host-level metrics (CPU, RAM, disk, network)
   - Exposes metrics at `/metrics`

2. **Logporter**
   - Reads Docker logs via read-only Docker socket
   - Extracts error-related metrics from container logs
   - Exposes metrics in Prometheus format

3. **Prometheus**
   - Periodically scrapes metrics from:
     - Node Exporter
     - Logporter
     - Itself
   - Stores metrics in a time-series database
   - Provides PromQL query interface

4. **Grafana**
   - Queries Prometheus using PromQL
   - Displays metrics via dashboards
   - Sends alerts via SMTP

5. **Cloudflare Tunnel**
   - Securely exposes Grafana to the public internet
   - No inbound ports required on the host

---

## 🐳 Container Networking

- All services run on the same Docker network (default bridge)
- Containers communicate using **service names** as hostnames:
  - `prometheus`
  - `grafana`
  - `node_exporter`
  - `logporter`

---

## 💾 Persistence Layer

| Component | Volume | Purpose |
|--------|--------|--------|
| Prometheus | `prometheus_data` | Metric retention |
| Grafana | `grafana_data` | Dashboards, users, settings |

---

## 🔐 Security Architecture

- Grafana exposed only via **Cloudflare Tunnel**
- Docker socket mounted **read-only**
- SMTP credentials injected via environment variables
- No direct public access to Prometheus or exporters

---

## ⚙️ Observability Scope

### Metrics
- Host system performance
- Docker container logs and errors
- Prometheus internal health

### Alerts
- Configured in Grafana (email via SMTP)
- Extendable with Prometheus Alertmanager

---

## 🚀 Scalability Considerations

- Add more exporters (e.g., cAdvisor, Blackbox Exporter)
- Externalize Prometheus storage (Thanos / Cortex)
- Use Grafana Cloud or managed Prometheus if needed

---

## 🧭 Future Enhancements

- Alertmanager integration
- Named Cloudflare tunnel with authentication
- TLS for internal services
- RBAC and SSO for Grafana

---

## 📄 Notes

This architecture is suitable for:
- Single-host monitoring
- Small to medium infrastructure
- Secure remote access to dashboards
