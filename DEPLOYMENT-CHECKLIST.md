# Redeemer Lab - Pre-Deployment Checklist

Use this checklist before deploying the lab to students.

---

## 📋 Pre-Deployment Validation

### System Prerequisites

- [ ] Docker installed and running
  ```bash
  docker --version
  docker ps
  ```

- [ ] Docker Compose installed
  ```bash
  docker-compose --version
  ```

- [ ] At least 4GB RAM available
  ```bash
  free -h
  ```

- [ ] At least 10GB disk space
  ```bash
  df -h
  ```

- [ ] Ports 6080, 9001, 6379 are free
  ```bash
  lsof -i :6080
  lsof -i :9001
  lsof -i :6379
  ```

---

## 🏗️ Build & Start

- [ ] Navigate to project directory
  ```bash
  cd /home/joyboy/THINGS/Internship/Redeemer
  ```

- [ ] Run build and validation script
  ```bash
  ./scripts/build-and-validate.sh
  ```

- [ ] Wait for all checks to pass (green ✓)

- [ ] All services show as "running"
  ```bash
  docker-compose ps
  ```

---

## ✅ Service Validation

### Redis Service

- [ ] Redis container is running
  ```bash
  docker ps | grep redeemer-redis
  ```

- [ ] Redis responds to PING
  ```bash
  docker exec redeemer-redis redis-cli PING
  ```
  Expected: `PONG`

- [ ] Database is seeded (25+ keys)
  ```bash
  docker exec redeemer-redis redis-cli DBSIZE
  ```
  Expected: `(integer) 25` or more

- [ ] Flag exists and is correct
  ```bash
  docker exec redeemer-redis redis-cli GET flag
  ```
  Expected: `"LUH{R3d1s_3num3r4t10n_m4st3r_2026}"`

- [ ] Decoy keys exist
  ```bash
  docker exec redeemer-redis redis-cli GET backup:old_flag
  ```
  Expected: `"LUH{th1s_1s_n0t_th3_fl4g}"`

- [ ] No authentication required (vulnerable)
  ```bash
  docker exec redeemer-redis redis-cli CONFIG GET requirepass
  ```
  Expected: `1) "requirepass" 2) ""`

- [ ] Protected mode is off (vulnerable)
  ```bash
  docker exec redeemer-redis redis-cli CONFIG GET protected-mode
  ```
  Expected: `1) "protected-mode" 2) "no"`

- [ ] Bound to all interfaces (vulnerable)
  ```bash
  docker exec redeemer-redis redis-cli CONFIG GET bind
  ```
  Expected: `1) "bind" 2) "0.0.0.0"`

### OS Instance

- [ ] OS container is running
  ```bash
  docker ps | grep redeemer-os
  ```

- [ ] Nmap is installed
  ```bash
  docker exec redeemer-os which nmap
  ```
  Expected: `/usr/bin/nmap`

- [ ] redis-cli is installed
  ```bash
  docker exec redeemer-os which redis-cli
  ```
  Expected: `/usr/bin/redis-cli`

- [ ] Health API is responding
  ```bash
  curl -sf http://localhost:9001/api/health
  ```
  Expected: JSON with `"status": "healthy"`

- [ ] Lab status shows ready
  ```bash
  curl -sf http://localhost:9001/api/status | grep -o '"lab_status":"ready"'
  ```
  Expected: `"lab_status":"ready"`

- [ ] noVNC is accessible
  ```bash
  curl -sf http://localhost:6080 | grep -o "noVNC"
  ```
  Expected: `noVNC`

---

## 🌐 Network Validation

- [ ] OS can ping Redis
  ```bash
  docker exec redeemer-os ping -c 1 redis
  ```
  Expected: 1 packet received

- [ ] OS can connect to Redis port
  ```bash
  docker exec redeemer-os nc -zv redis 6379
  ```
  Expected: Connection succeeded

- [ ] OS can query Redis
  ```bash
  docker exec redeemer-os redis-cli -h redis PING
  ```
  Expected: `PONG`

- [ ] Both containers on same network
  ```bash
  docker network inspect redeemer_redeemer-net
  ```
  Expected: Both containers listed

---

## 🎓 Enumeration Path Test

Simulate student workflow:

- [ ] Access desktop in browser
  - Open: http://localhost:6080
  - Expected: See Debian desktop

- [ ] Open terminal in desktop
  - Click Terminal icon
  - Expected: Terminal opens

- [ ] Network discovery works
  ```bash
  # In desktop terminal:
  nmap -sn 172.20.0.0/24
  ```
  Expected: Shows 2-3 hosts

- [ ] Service scan works
  ```bash
  # In desktop terminal:
  nmap -p 6379 -sV 172.20.0.2
  ```
  Expected: Shows Redis on port 6379

- [ ] redis-cli connection works
  ```bash
  # In desktop terminal:
  redis-cli -h redis
  ```
  Expected: Redis prompt appears

- [ ] Commands work in redis-cli
  ```bash
  # In redis-cli:
  INFO
  KEYS *
  GET flag
  ```
  Expected: All commands execute, flag retrieved

---

## 📚 Documentation Check

- [ ] Main README.md exists and is complete
- [ ] redis/README.md explains Redis setup
- [ ] scripts/README.md documents all scripts
- [ ] attacker-notes/enumeration.md provides methodology
- [ ] attacker-notes/expected-solution.md has full walkthrough
- [ ] QUICKSTART.md provides quick reference
- [ ] DEVELOPMENT.md explains project structure
- [ ] .gitignore excludes sensitive files

---

## 🛠️ Script Validation

- [ ] All scripts are executable
  ```bash
  ls -l scripts/*.sh
  ```
  Expected: All show -rwxr-xr-x

- [ ] start.sh works
  ```bash
  docker-compose down
  ./scripts/start.sh
  ```
  Expected: Services start

- [ ] stop.sh works
  ```bash
  ./scripts/stop.sh
  ```
  Expected: Services stop

- [ ] status.sh shows correct info
  ```bash
  ./scripts/start.sh
  sleep 30
  ./scripts/status.sh
  ```
  Expected: All checks green

- [ ] logs.sh accessible
  ```bash
  ./scripts/logs.sh
  ```
  Expected: Menu appears

---

## 🔒 Security Misconfiguration Verification

Confirm these vulnerabilities exist (they're intentional!):

- [ ] ❌ No authentication on Redis
- [ ] ❌ Redis exposed to 0.0.0.0
- [ ] ❌ Protected mode disabled
- [ ] ❌ All commands available (CONFIG, FLUSHDB, etc.)
- [ ] ❌ Default port (6379) with no firewall

These are **expected** and **required** for the lab!

---

## 👥 Student Preparation

- [ ] URL to access lab: `http://localhost:6080` (or your server IP:6080)
- [ ] VNC password: `debian` (if needed)
- [ ] Expected completion time: 15-30 minutes
- [ ] Difficulty level communicated: Very Easy
- [ ] enumeration.md shared with students
- [ ] Solution kept private until after completion

---

## 🎯 Success Criteria

Students should be able to:

- [ ] Access the desktop environment
- [ ] Open a terminal
- [ ] Use nmap to discover hosts
- [ ] Identify Redis service
- [ ] Connect with redis-cli
- [ ] Execute INFO, CONFIG GET, KEYS commands
- [ ] Retrieve the flag
- [ ] Identify 3+ security misconfigurations

---

## 🆘 Troubleshooting Prepared

- [ ] Know how to check logs: `./scripts/logs.sh`
- [ ] Know how to restart: `./scripts/stop.sh && ./scripts/start.sh`
- [ ] Know how to reset: `./scripts/reset.sh`
- [ ] Can manually reseed Redis:
  ```bash
  docker exec redeemer-redis sh /docker-entrypoint-initdb.d/seed-data.sh
  ```

---

## 📊 Performance Check

- [ ] Services start in < 60 seconds
- [ ] Desktop loads in browser quickly
- [ ] Terminal opens without lag
- [ ] nmap scans complete in < 10 seconds
- [ ] Redis responds instantly
- [ ] No container restarts in logs
  ```bash
  docker-compose ps
  ```
  Expected: All show "Up" not "Restarting"

---

## 🎉 Final Checks

- [ ] Can access lab: http://localhost:6080
- [ ] Health API shows ready: http://localhost:9001/api/status
- [ ] Flag is retrievable by students
- [ ] All documentation is accessible
- [ ] Backup plan ready (reset script)
- [ ] Confident to demo to students

---

## ✅ DEPLOYMENT APPROVED

Once all items are checked:

**Lab is ready for students! 🚀**

Deploy command:
```bash
cd /home/joyboy/THINGS/Internship/Redeemer
./scripts/build-and-validate.sh
```

Give students:
```
URL: http://localhost:6080
Guide: attacker-notes/enumeration.md
Time: 30 minutes
Difficulty: Very Easy
```

---

## 📝 Notes Section

Use this space for deployment-specific notes:

**Date deployed**: ___________

**Number of students**: ___________

**Server IP (if remote)**: ___________

**Any issues encountered**: 

___________________________________________

___________________________________________

---

**Checklist Complete: Ready for Deployment! ✅**
