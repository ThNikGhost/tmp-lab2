#!/usr/bin/env bash
set -euo pipefail

pass() { echo -e "[OK] $1"; }
fail() { echo -e "[FAIL] $1"; exit 1; }
warn() { echo -e "[WARN] $1"; }

# 1) Docker
if ! command -v docker >/dev/null 2>&1; then fail "Docker не установлен"; else pass "docker найден"; fi

# 2) Compose v2
if docker compose version >/dev/null 2>&1; then pass "docker compose v2 доступен"; else warn "docker compose v2 недоступен; используйте docker-compose (v1)"; fi

# 3) Daemon running
if ! docker info >/dev/null 2>&1; then fail "Docker daemon не запущен"; else pass "docker daemon OK"; fi

# 4) Ports availability (best effort)
check_port() {
  local port=$1
  if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then warn "порт $port занят"; else pass "порт $port свободен"; fi
}
check_port 80
check_port 5432
check_port 6379
check_port 5672

# 5) Hosts
if grep -E "api\.localhost|traefik\.localhost|adminer\.localhost" /etc/hosts >/dev/null 2>&1; then pass "/etc/hosts содержит нужные записи"; else warn "в /etc/hosts нет записей для *.localhost"; fi

# 6) WSL2 hint
if grep -qi microsoft /proc/version 2>/dev/null; then warn "WSL2: храните проект в файловой системе WSL для стабильной работы volumes"; fi

exit 0

