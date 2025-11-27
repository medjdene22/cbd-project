# Troubleshooting

**Prometheus can't scrape target**
- Check `prometheus/prometheus.yml` and ensure targets ause the service name. Use `docker compose logs prometheus` to inspect logs.
- From Prometheus container run `apt update && apt install -y curl` then `curl http://node_exporter:9100/metrics` to test connectivity.

**node_exporter metrics missing or incorrect**
- Ensure `node_exporter` mounts `/proc` and `/sys` as read-only. Missing mounts will result in partial metrics.

**Grafana shows an empty dashboard**
- Confirm datasource is configured: Grafana -> Configuration -> Data Sources -> Prometheus. Should be `http://prometheus:9090`.
- Check Grafana logs `docker compose logs grafana`.
