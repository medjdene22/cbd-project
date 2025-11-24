# Architecture
This monitoring stack uses the following components:
- **Prometheus:** time-series database and scraper. Scrapes metrics from
exporters.
- **node_exporter:** exposes host-level metrics (CPU, memory, disk, kernel
stats).
- **cAdvisor:** collects container-level metrics from the Docker runtime
(per-container CPU, memory, network, filesystem).
- **Grafana:** visualization layer. Uses Prometheus as a data source.
Data flow: node_exporter / cAdvisor -> Prometheus (scrape) -> Grafana (query
+ visualize).
Networking: Docker Compose creates a bridge network where services can reach
each other by service name (e.g., `prometheus`, `grafana`, `node_exporter`,
`cadvisor`).
