FROM postgres:17-bookworm

ARG EDB_TOKEN

# 1. Install PGAA
RUN apt-get update && apt-get install -y curl ca-certificates sudo \
    && curl -1sSLf "https://downloads.enterprisedb.com/${EDB_TOKEN}/standard/setup.deb.sh" | sudo -E bash \
    && apt-get update && apt-get install -y postgresql-17-pgaa

# 2. Setup Data Directory
RUN mkdir -p /data/pg_data && chown -R postgres:postgres /data

# 3. Copy Initialization Script
COPY init-pgaa.sh /docker-entrypoint-initdb.d/init-pgaa.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-pgaa.sh

USER postgres
