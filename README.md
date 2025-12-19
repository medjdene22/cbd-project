# Monitoring Stack with Prometheus, Grafana, Node Exporter, Logporter & Cloudflare Tunnel

This repository contains a **Docker Compose–based monitoring stack** using Prometheus and Grafana, enriched with system metrics, Docker log monitoring, and secure external access via Cloudflare Tunnel.

---

## 🚀 Services Overview

> **Note on cAdvisor**
>
> This stack **intentionally does not use cAdvisor**. While cAdvisor was historically popular for container metrics, it is now **deprecated / no longer actively recommended** for new setups. Instead, this stack relies on:
>
> - **Node Exporter** for host-level metrics
> - **Logporter** for Docker log–based insights
>
> This approach reduces complexity, avoids deprecated components, and aligns better with modern Prometheus + Grafana practices.



### 1. Prometheus
- Time-series database and monitoring system
- Scrapes metrics from configured targets (Node Exporter, Logporter, etc.)
- Web UI: http://localhost:9090

**Image:** `prom/prometheus:latest`

---

### 2. Grafana
- Visualization and dashboarding tool
- Uses Prometheus as a data source
- Pre-provisioned dashboards and data sources
- SMTP enabled for alert notifications
- Web UI: http://localhost:3000

**Default credentials**
- Username: `admin`
- Password: `admin` (change in production)

**Image:** `grafana/grafana:latest`

---

### 3. Node Exporter
- Exposes host system metrics (CPU, memory, disk, network)
- Runs in host PID namespace
- Metrics endpoint: http://localhost:9100/metrics

**Image:** `prom/node-exporter:latest`

---

### 4. Logporter
- Collects and exports Docker container log metrics
- Detects error patterns in logs
- Metrics endpoint: http://localhost:9333/metrics

**Enabled features**
- Error log pattern detection: `(err|error|ERR|ERROR)`
- Read-only Docker socket access

**Image:** `lifailon/logporter:latest`

---

### 5. Cloudflare Tunnel (cloudflared)
- Securely exposes Grafana without opening ports
- Routes external traffic to `grafana:3000`

**Image:** `cloudflare/cloudflared:latest`

---

## 📁 Directory Structure

```text
.
├── docker-compose.yml
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/
│   │   └── dashboards/
│   └── dashboards/
└── README.md
```

---

## ⚙️ Configuration

### Prometheus Targets
Ensure `prometheus/prometheus.yml` includes:

- Prometheus: `prometheus:9090`
- Node Exporter: `node_exporter:9100`
- Logporter: `logporter:9333`

---

### Grafana SMTP (Gmail Example)

```env
GF_SMTP_USER=your-email@gmail.com
GF_SMTP_PASSWORD=your-app-password
GF_SMTP_FROM_ADDRESS=your-email@gmail.com
```

⚠️ Use a **Gmail App Password**, not your main Gmail password.

---

## ▶️ Getting Started

### Start the stack

```bash
docker compose up -d
```

### Access services

| Service | URL |
|------|-----|
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3000 |
| Node Exporter | http://localhost:9100/metrics |
| Logporter | http://localhost:9333/metrics |

Grafana is also accessible securely via **Cloudflare Tunnel**.

---

## 🔐 Security Notes
- Change Grafana admin password immediately
- Never commit SMTP credentials
- Docker socket is mounted read-only but still sensitive

---

## 📦 Volumes
- `prometheus_data` → Persistent Prometheus metrics
- `grafana_data` → Grafana data and dashboards

---

## 🛠️ Useful Commands

```bash
docker compose ps
docker compose logs -f grafana
docker compose down
```

---

## 📄 License
Provided as-is for learning and internal monitoring use.
