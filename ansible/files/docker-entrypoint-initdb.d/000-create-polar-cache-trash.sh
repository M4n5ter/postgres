#!/bin/bash
set -euo pipefail

if [ -z "${PGDATA:-}" ]; then
  echo "PGDATA is not set; skipping PolarDB bootstrap helpers" >&2
  exit 0
fi

# Ensure polar_cache_trash exists to avoid PolarDB WARN spam
mkdir -p "${PGDATA}/polar_cache_trash"

# Disable Polar resource manager to avoid noisy "Failed to get the instance memory usage" warnings
append_disable_resource_manager() {
  local conf_file="$1"
  if [ -w "$conf_file" ] && ! grep -q '^polar_resource_manager\.enable_resource_manager' "$conf_file"; then
    echo "polar_resource_manager.enable_resource_manager=off" >> "$conf_file"
  fi
}

append_disable_resource_manager "${PGDATA}/postgresql.conf"
append_disable_resource_manager "/etc/postgresql/postgresql.conf"
