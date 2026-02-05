# Redis Dockerfile for Redeemer Lab
# Purpose: Create an intentionally vulnerable Redis instance for enumeration training
# Based on Redis 6.x (realistic but with security misconfiguration)

FROM redis:6.2-alpine

LABEL maintainer="Redeemer Lab"
LABEL description="Vulnerable Redis instance for security training"

# Copy custom Redis configuration (no auth, exposed)
COPY redis.conf /usr/local/etc/redis/redis.conf

# Copy custom entrypoint
COPY scripts/entrypoint.sh /usr/local/bin/redis-entrypoint.sh

# Create directory for initialization scripts
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy init script and sample data
COPY init/seed-data.sh /docker-entrypoint-initdb.d/seed-data.sh
COPY data/sample-data.txt /data/sample-data.txt

# Make scripts executable
RUN chmod +x /docker-entrypoint-initdb.d/seed-data.sh && \
    chmod +x /usr/local/bin/redis-entrypoint.sh

# Expose Redis default port
EXPOSE 6379

# Use custom entrypoint to seed data
ENTRYPOINT ["/usr/local/bin/redis-entrypoint.sh"]
