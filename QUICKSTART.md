# 🚀 Quick Start Guide - Redeemer Lab

## TL;DR

```bash
cd /home/joyboy/THINGS/Internship/Redeemer
./scripts/build-and-validate.sh
# Wait 60 seconds
# Open browser: http://localhost:8080
# Click "START OS INSTANCE"
# Start hacking!
```

---

## For Instructors

### Deploy the Lab

```bash
# 1. Build and start (first time)
./scripts/build-and-validate.sh

# 2. Verify it's ready
curl http://localhost:9001/api/status | jq

# 3. Give students this URL
echo "Access the lab: http://localhost:8080"
```

### Validate Flag

```bash
# Check the flag is correct
docker exec redeemer-redis redis-cli GET flag
# Expected: LUH{R3d1s_3num3r4t10n_m4st3r_2026}
```

### Daily Operation

```bash
./scripts/start.sh     # Morning
./scripts/status.sh    # Check health
./scripts/stop.sh      # End of day
```

---

## For Students

### Access the Lab

1. **Open browser** → `http://localhost:8080`
2. **You'll see a professional landing page** (red/black HTB-style)
3. **Click "START OS INSTANCE"** button
4. **OS loads inline** in the browser
5. **Start enumeration!**

### Your First Commands

```bash
# 1. Find your network
ip addr show

# 2. Discover hosts
nmap -sn 172.20.0.0/16

# 3. Scan for Redis
nmap -p 6379 -sV <target_ip>

# 4. Connect
redis-cli -h <target_ip>

# 5. Enumerate
INFO
KEYS *
GET flag
```

### Get Help

- **Methodology**: See `attacker-notes/enumeration.md` in repo
- **Stuck**: Check `attacker-notes/expected-solution.md` (after trying!)
- **Lab broken**: Ask instructor to run `./scripts/status.sh`

---

## For Developers

### First Time Setup

```bash
git clone <repo>
cd Redeemer
./scripts/build-and-validate.sh
```

### Development Workflow

```bash
# Make changes to files
vim redis/redis.conf

# Rebuild specific service
docker-compose build redis

# Restart
docker-compose down
docker-compose up -d

# Test
./scripts/status.sh
```

### Clean Slate

```bash
./scripts/reset.sh
# Removes everything and rebuilds
```

---

## Ports Reference

| Port | Service | Access |
|-8080 | Landing Page | http://localhost:8080 |
| -----|---------|--------|
| 6080 | noVNC Desktop | http://localhost:6080 |
| 9001 | Health API | http://localhost:9001/api/status |
| 6379 | Redis (direct) | redis-cli -h localhost |
| 5900 | VNC (direct) | VNC client (optional) |

---

## Common Issues

### "Port already in use"

```bash
# Find what's using the port
lsof -i :6080  # or :6379, :9001

# Kill it or change docker-compose.yml ports
```

### "Services not ready"

```bash
# Wait longer (can take 60 seconds)
./scripts/status.sh

# Check logs
./scripts/logs.sh
```

### "Can't connect to Redis"

```bash
# Verify it's running
docker ps | grep redis

# Check if seeded
docker exec redeemer-redis redis-cli KEYS \*

# Re-seed if needed
docker exec redeemer-redis sh /docker-entrypoint-initdb.d/seed-data.sh
```

---

## Useful Commands

```bash
# Quick status
curl http://localhost:9001/api/status

# View all logs
docker-compose logs -f

# Restart everything
docker-compose restart

# Complete cleanup
./scripts/reset.sh

# Just Redis logs
docker-compose logs -f redis

# Execute command in OS container
docker exec -it redeemer-os <command>

# Get flag directly (for validation)
docker exec redeemer-redis redis-cli GET flag
```

---

## Expected Timeline

- **Setup**: 5 minutes (first time)
- **Startup**: 30-60 seconds
- **Enumeration**: 15-30 minutes (for students)
- **Shutdown**: 5 seconds

---

## Success Criteria

✅ You should be able to:
- Access desktop at http://localhost:6080
- Run `nmap` in the terminal
- Discover Redis service
- Connect with `redis-cli`
- Retrieve the flag

---

## Help Resources

| Resource | Location |
|----------|----------|
| Main docs | README.md |
| Redis docs | redis/README.md |
| Enumeration guide | attacker-notes/enumeration.md |
| Full solution | attacker-notes/expected-solution.md |
| Script help | scripts/README.md |
| Dev notes | DEVELOPMENT.md |

---

## One-Line Commands

```bash
# Full setup
./scripts/build-and-validate.sh && echo "Ready at http://localhost:6080"

# Quick start (after first build)
./scripts/start.sh && sleep 30 && curl -s http://localhost:9001/api/status | jq .lab_status

# Status check
./scripts/status.sh

# Verify flag
docker exec redeemer-redis redis-cli GET flag

# Complete teardown
./scripts/stop.sh && docker-compose down -v
```

---

**You're ready to go! 🎉**

Open `http://localhost:6080` and start hacking!
