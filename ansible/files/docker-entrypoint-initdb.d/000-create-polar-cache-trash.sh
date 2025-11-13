#!/bin/bash
set -euo pipefail

if [ -z "${PGDATA:-}" ]; then
  echo "PGDATA is not set; skipping PolarDB bootstrap helpers" >&2
  exit 0
fi

# Ensure polar_cache_trash exists to avoid PolarDB WARN spam
mkdir -p "${PGDATA}/polar_cache_trash"

# Force default port back to 5432 (PolarDB binary defaults to 35504)
CONF_FILE="${PGDATA}/postgresql.conf"
if [ -w "$CONF_FILE" ]; then
  echo "port = 5432" >> "$CONF_FILE"
fi
