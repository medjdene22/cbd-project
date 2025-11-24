#!/usr/bin/env bash
set -euo pipefail

# Create data dirs and fix permissions
mkdir -p ./prometheus ./grafana/dashboards
chown -R $(id -u):$(id -g) ./prometheus ./grafana

echo "Setup complete. Start with: docker-compose up -d"
