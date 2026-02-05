# Redis Service - Target Container

## Purpose

This directory contains the **intentionally vulnerable Redis instance** that serves as the target for the Redeemer lab.

---

## Structure

```
redis/
├── Dockerfile              # Build instructions for Redis container
├── redis.conf              # Vulnerable Redis configuration
├── init/
│   └── seed-data.sh        # Script to populate Redis with data
├── data/
│   └── sample-data.txt     # Additional keys to load
├── scripts/
│   └── entrypoint.sh       # Custom startup script
└── README.md               # This file
```

---

## Configuration Highlights

### Intentional Vulnerabilities

The `redis.conf` file is configured with these security issues:

1. **No Authentication**
   ```conf
   # No requirepass set
   ```

2. **Exposed to All Interfaces**
   ```conf
   bind 0.0.0.0
   ```

3. **Protected Mode Disabled**
   ```conf
   protected-mode no
   ```

4. **All Commands Enabled**
   - No dangerous commands renamed or disabled
   - Full CONFIG access available

---

## Data Seeding

### How It Works

1. Redis starts via `entrypoint.sh`
2. After Redis is ready, `seed-data.sh` runs
3. Script creates:
   - Main flag key
   - Decoy flag keys
   - Realistic application keys
4. Additional keys loaded from `sample-data.txt`

### Flag Information

- **Key Name**: `flag`
- **Value**: `LUH{R3d1s_3num3r4t10n_m4st3r_2026}`
- **Location**: Database 0 (default)

### Decoy Keys

- `backup:old_flag` - Contains fake flag
- `temp` - Temporary cache data
- `cache:user:1001` - User email
- `session:abcd1234` - Session token
- Various other realistic keys

---

## Building Locally

```bash
# From the redis/ directory
docker build -t redeemer-redis .

# Run standalone (for testing)
docker run -d \
  --name test-redis \
  -p 6379:6379 \
  redeemer-redis

# Test connection
redis-cli -h localhost PING

# Check keys
redis-cli -h localhost KEYS \*

# Get flag
redis-cli -h localhost GET flag
```

---

## Customization

### Adding More Decoy Data

Edit `data/sample-data.txt`:
```
your_key=your_value
another_key=another_value
```

Format: `key=value` (one per line)

### Changing the Flag

Edit `init/seed-data.sh`:
```bash
FLAG="LUH{your_new_flag_here}"
set_key "flag" "$FLAG"
```

### Modifying Configuration

Edit `redis.conf` to change Redis behavior:
- Change port
- Add authentication (breaks the lab!)
- Modify persistence settings
- Adjust memory limits

---

## Verification

### Check Redis is Running

```bash
# Inside container
redis-cli PING
# Expected: PONG

# Check configuration
redis-cli CONFIG GET bind
# Expected: 0.0.0.0

redis-cli CONFIG GET protected-mode
# Expected: no

redis-cli CONFIG GET requirepass
# Expected: (empty)
```

### Verify Data is Seeded

```bash
# Count keys
redis-cli DBSIZE
# Expected: ~25+ keys

# List all keys
redis-cli KEYS \*

# Get flag
redis-cli GET flag
# Expected: LUH{R3d1s_3num3r4t10n_m4st3r_2026}
```

---

## Security Notes

### Why This Configuration is Dangerous

1. **No Authentication**: Anyone can connect
2. **Network Exposure**: Reachable from anywhere
3. **Data Exposure**: All keys readable by anyone
4. **Data Modification**: Anyone can change/delete data
5. **Potential RCE**: Some Redis versions allow code execution

### Production Best Practices

**DO**:
- Set strong `requirepass`
- Bind to `127.0.0.1` or specific IPs only
- Enable `protected-mode`
- Disable dangerous commands (CONFIG, FLUSHDB, etc.)
- Use Redis ACLs (v6+)
- Enable TLS/SSL for encryption
- Run in a firewalled network
- Implement connection limits
- Monitor access logs

**DON'T**:
- Expose Redis to the internet
- Use default ports without firewall
- Store sensitive data without encryption
- Grant full access to all databases
- Run as root user

---

## Redis Version

- **Base Image**: `redis:6.2-alpine`
- **Why 6.2**: Balance of realism and availability
- **Alpine**: Smaller image size, faster builds

---

## Troubleshooting

### Redis Won't Start

```bash
# Check logs
docker logs redeemer-redis

# Common issues:
# - Port 6379 already in use
# - Invalid redis.conf syntax
# - Permission issues on /data
```

### Data Not Seeded

```bash
# Re-run seed script manually
docker exec -it redeemer-redis sh /docker-entrypoint-initdb.d/seed-data.sh

# Check if redis-cli is available
docker exec -it redeemer-redis which redis-cli
```

### Can't Connect from OS Container

```bash
# Check network
docker network inspect redeemer_redeemer-net

# Verify both containers are on same network
docker inspect redeemer-redis | grep NetworkMode
docker inspect redeemer-os | grep NetworkMode

# Test connectivity
docker exec -it redeemer-os ping redis
```

---

## Educational Value

This Redis container teaches:
- Common misconfiguration patterns
- Redis enumeration techniques
- NoSQL database interaction
- Security implications of default configs

**Remember**: This is intentionally vulnerable for education!

---

## References

- [Redis Configuration](https://redis.io/topics/config)
- [Redis Security](https://redis.io/topics/security)
- [Redis Commands](https://redis.io/commands)
