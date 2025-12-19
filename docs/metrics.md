# Metrics Reference

This document describes the **metrics exposed and collected** by each component in the monitoring stack.

---

## 📊 Prometheus Metrics

Prometheus exposes its own internal metrics at:

```
http://prometheus:9090/metrics
```

### Key Metrics
- `prometheus_tsdb_head_series` – Number of active series
- `prometheus_engine_query_duration_seconds` – Query performance
- `up` – Target availability (1 = up, 0 = down)

---

## 🖥️ Node Exporter Metrics

Endpoint:
```
http://node_exporter:9100/metrics
```

### CPU
- `node_cpu_seconds_total`
- `node_load1`, `node_load5`, `node_load15`

### Memory
- `node_memory_MemTotal_bytes`
- `node_memory_MemAvailable_bytes`
- `node_memory_SwapFree_bytes`

### Disk
- `node_filesystem_avail_bytes`
- `node_filesystem_size_bytes`
- `node_disk_io_time_seconds_total`

### Network
- `node_network_receive_bytes_total`
- `node_network_transmit_bytes_total`

---

## 🐳 Logporter Metrics

Endpoint:
```
http://logporter:9333/metrics
```

### Docker Log Metrics
- `docker_log_messages_total`
- `docker_log_errors_total`
- `docker_log_matches_total`

### Custom Pattern
Configured pattern:
```
(err|error|ERR|ERROR)
```

Used to detect error logs across containers.

---

## 📈 Common PromQL Examples

### CPU Usage
```promql
100 - (avg by(instance)(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Memory Usage
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)
/ node_memory_MemTotal_bytes * 100
```

### Disk Usage
```promql
100 * (1 - node_filesystem_avail_bytes / node_filesystem_size_bytes)
```

### Error Logs Rate
```promql
rate(docker_log_errors_total[5m])
```

---

## 🚨 Alerting Ideas

- Host CPU > 80%
- Memory usage > 85%
- Disk usage > 90%
- Error log rate spike
- Target `up == 0`

---

## 📄 Notes

Metrics names may evolve with image updates. Always verify via `/metrics` endpoint.
