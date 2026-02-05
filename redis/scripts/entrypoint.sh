#!/bin/sh
# Custom Redis Entrypoint
# Purpose: Start Redis and seed data after it's running

set -e

# Start Redis server in background
echo "[*] Starting Redis server..."
redis-server /usr/local/etc/redis/redis.conf &
REDIS_PID=$!

# Wait for Redis to be ready
echo "[*] Waiting for Redis to be ready..."
sleep 3

# Check if Redis is responding
if redis-cli -h 127.0.0.1 -p 6379 PING > /dev/null 2>&1; then
    echo "[+] Redis is ready!"
    
    # Execute data seeding script
    if [ -f /docker-entrypoint-initdb.d/seed-data.sh ]; then
        echo "[*] Executing data seeding script..."
        sh /docker-entrypoint-initdb.d/seed-data.sh
    fi
else
    echo "[!] Redis failed to start properly"
    exit 1
fi

# Keep Redis running in foreground
echo "[*] Redis is running and seeded. Waiting for connections..."
wait $REDIS_PID
