#!/bin/sh
# Redis Data Seeding Script
# Purpose: Populate Redis with a flag and decoy keys for enumeration training
# This script runs after Redis starts to seed the database

set -e

echo "[*] Starting Redis data seeding..."

# Wait for Redis to be fully ready
sleep 2

# Function to set a key with redis-cli
set_key() {
    redis-cli -h 127.0.0.1 -p 6379 SET "$1" "$2" > /dev/null
    if [ $? -eq 0 ]; then
        echo "[+] Set key: $1"
    else
        echo "[!] Failed to set key: $1"
    fi
}

# MAIN FLAG (Static - as required)
FLAG="LUH{R3d1s_3num3r4t10n_m4st3r_2026}"
set_key "flag" "$FLAG"

# DECOY KEYS (Force proper enumeration)
set_key "temp" "temporary_cache_data_12345"
set_key "cache:user:1001" "john.doe@example.com"
set_key "session:abcd1234" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
set_key "backup:old_flag" "LUH{th1s_1s_n0t_th3_fl4g}"

# Additional realistic keys to simulate production data
set_key "config:app:version" "v2.4.1"
set_key "cache:api:rate_limit:192.168.1.100" "45"
set_key "user:session:token:abc123" "valid_until_1738627200"
set_key "queue:tasks:pending" "17"
set_key "stats:visitors:today" "1247"
set_key "backup:config:2024" "archived_configuration_data"

# Load sample data from file
if [ -f /data/sample-data.txt ]; then
    echo "[*] Loading additional data from sample-data.txt..."
    while IFS='=' read -r key value; do
        # Skip empty lines and comments
        [ -z "$key" ] || [ "${key#\#}" != "$key" ] && continue
        set_key "$key" "$value"
    done < /data/sample-data.txt
fi

echo "[*] Redis data seeding completed!"
echo "[*] Total keys in database:"
redis-cli -h 127.0.0.1 -p 6379 DBSIZE

exit 0
