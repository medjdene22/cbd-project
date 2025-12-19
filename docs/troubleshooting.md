# Troubleshooting Guide

This document helps diagnose **common issues** in the monitoring stack.

---

## ❌ Containers Not Starting

### Check status
```bash
docker compose ps
```

### View logs
```bash
docker compose logs <service>
```

---

## 🔴 Prometheus Targets Down

### Symptoms
- Target shows `DOWN` in Prometheus UI

### Fix
- Verify service name and port
- Check container networking
- Ensure `/metrics` endpoint is reachable

```bash
docker exec -it prometheus wget -qO- http://node_exporter:9100/metrics
```

---

## 📉 No Data in Grafana

### Possible Causes
- Prometheus data source misconfigured
- Prometheus container not running
- Incorrect PromQL query

### Fix
- Data source URL must be: `http://prometheus:9090`
- Test query in Prometheus UI first

---

## 📧 Grafana Alerts Not Sending Email

### Checklist
- SMTP enabled
- App password used (Gmail)
- Correct FROM address

### Test SMTP
```bash
docker exec -it grafana grafana-cli admin reset-admin-password test
```

Check logs:
```bash
docker compose logs grafana
```

---

## 🔐 Cloudflare Tunnel Not Working

### Symptoms
- External URL not reachable

### Fix
- Ensure tunnel container is running
- Verify command points to `grafana:3000`
- Check Cloudflare account logs

```bash
docker compose logs cloudflared
```

---

## 🐳 Logporter Not Reporting Logs

### Checklist
- Docker socket mounted read-only
- Containers producing logs
- Pattern matches log content

### Verify
```bash
docker exec -it logporter wget -qO- http://localhost:9333/metrics
```

---

## 💾 Data Loss After Restart

### Cause
- Volumes not mounted correctly

### Fix
- Ensure volumes exist:
```bash
docker volume ls
```

- Do not remove volumes unless intended:
```bash
docker compose down -v
```

---

## 🧠 General Debug Tips

- Restart stack:
```bash
docker compose restart
```

- Update images:
```bash
docker compose pull
docker compose up -d
```

---

## 📄 Notes

Always verify container logs first. Most issues are related to networking, credentials, or permissions.
