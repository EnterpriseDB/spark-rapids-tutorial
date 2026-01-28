#!/bin/bash
set -e

# Update postgresql.conf with PGAA flags
echo "shared_preload_libraries = 'pgaa'" >> "$PGDATA/postgresql.conf"
echo "pgaa.autostart_seafowl = true" >> "$PGDATA/postgresql.conf"
echo "pgfs.allowed_local_fs_paths = '/'" >> "$PGDATA/postgresql.conf"
echo "pgaa.enable_maintenance_worker = true" >> "$PGDATA/postgresql.conf"
echo "pgaa.enable_metastore_sync_worker = true" >> "$PGDATA/postgresql.conf"

# Update password for remote connections
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'password';"