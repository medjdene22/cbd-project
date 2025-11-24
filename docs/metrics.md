# Metrics explained

Key metrics you will see and what they mean:

- `container_cpu_usage_seconds_total` (cAdvisor): cumulative CPU seconds consumed by the container.
- `container_memory_usage_bytes` (cAdvisor): current memory usage of the container.
- `node_cpu_seconds_total` (node_exporter): per-CPU cumulative seconds in different modes.
- `node_load1`, `node_load5`, `node_load15` (node_exporter): system load averages.
- `node_filesystem_avail_bytes` / `node_filesystem_size_bytes` (node_exporter): filesystem capacity and available bytes.

Common PromQL examples:

- **CPU percent (per container)**
