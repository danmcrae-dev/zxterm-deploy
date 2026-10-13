# Linux Setup Guide

## Prerequisites

- Docker 20+ installed
- docker-compose v2+ installed
- Git
- 4GB+ RAM

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/danmcrae-dev/zxterm-deploy/main/deploy-zxterm.sh | bash
```

On Linux, the script detects that Docker is already installed and skips the Homebrew/Colima steps. It uses the original Docker Compose files directly with `network_mode: host` (native Linux supports this).

## Server Deployment (e.g., Maximus)

For a dedicated server deployment:

```bash
# Clone the deploy repo
git clone git@github.com:danmcrae-dev/zxterm-deploy.git
cd zxterm-deploy

# Run with default settings
./deploy-zxterm.sh /opt/zxterm

# Or specify a custom install directory
./deploy-zxterm.sh /home/deploy/zxterm
```

## Network Configuration

The SaaS and MCP containers use `network_mode: host`, binding directly to the host's network interfaces. Ensure:

- Port 8000 (SaaS) and 8443 (MCP) are available
- Firewall allows access from client machines
- Network devices are reachable from the server (direct or via routing)

## systemd Service (optional)

To auto-start Zxterm on boot:

```bash
cat > /etc/systemd/system/zxterm.service << 'EOF'
[Unit]
Description=Zxterm Platform
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/zxterm/zxterm/deployment
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
ExecStopPost=/usr/bin/docker compose -f /opt/zxterm/zxterm-mcp/docker-compose.yml down

[Install]
WantedBy=multi-user.target
EOF

systemctl enable zxterm
systemctl start zxterm
```

## Backup

The PostgreSQL data volume contains all assessment data, device configs, and user accounts:

```bash
# Backup
docker exec deployment-postgres-1 pg_dump -U zxterm zxterm > backup.sql

# Restore
docker exec -i deployment-postgres-1 psql -U zxterm zxterm < backup.sql
```