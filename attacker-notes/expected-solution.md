# Expected Solution - Redeemer Lab

## Lab Overview
- **Difficulty**: Very Easy
- **Focus**: Redis enumeration
- **Skills Tested**: Nmap, Redis interaction, data enumeration
- **Expected Time**: 15-30 minutes

---

## Solution Walkthrough

### Step 1: Access the Lab Environment

1. Open browser and navigate to: `http://localhost:6080`
2. Access the noVNC desktop environment
3. Open a terminal (icon on desktop or via Applications menu)

---

### Step 2: Network Discovery

#### Find Your Network
```bash
ip addr show
# Expected: 172.20.0.x interface
```

#### Discover Active Hosts
```bash
nmap -sn 172.20.0.0/16
```

**Expected Output**:
```
Starting Nmap scan...
Nmap scan report for 172.20.0.2
Host is up (0.00010s latency).

Nmap scan report for 172.20.0.3
Host is up (0.00012s latency).
```

**Note**: One IP is your machine (attacker), the other is the target (redis).

---

### Step 3: Service Enumeration

#### Scan for Open Ports
```bash
nmap -sV 172.20.0.2
```

**Expected Output**:
```
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 6.2.x
```

**Key Findings**:
- Port 6379 is open (Redis default)
- Service is Redis 6.2.x
- No authentication mentioned

---

### Step 4: Connect to Redis

#### Test Connectivity
```bash
nc -zv 172.20.0.2 6379
# Expected: Connection succeeded
```

#### Connect with Redis CLI
```bash
redis-cli -h 172.20.0.2
```

**Expected**: Redis prompt appears:
```
172.20.0.2:6379>
```

---

### Step 5: Information Gathering

#### Test Authentication
```bash
172.20.0.2:6379> PING
```

**Expected Output**: `PONG`

**Significance**: No authentication required (vulnerability!)

#### Get Server Information
```bash
172.20.0.2:6379> INFO
```

**Expected Output** (partial):
```
# Server
redis_version:6.2.x
redis_mode:standalone
os:Linux
...

# Clients
connected_clients:1
...

# Keyspace
db0:keys=XX,expires=0,avg_ttl=0
```

**Key Findings**:
- Redis version confirmed
- Database 0 has multiple keys
- No expiration set on keys

#### Check Security Configuration
```bash
172.20.0.2:6379> CONFIG GET requirepass
```

**Expected Output**:
```
1) "requirepass"
2) ""
```

**Significance**: Empty password = no authentication (VULNERABLE!)

```bash
172.20.0.2:6379> CONFIG GET protected-mode
```

**Expected Output**:
```
1) "protected-mode"
2) "no"
```

**Significance**: Protected mode disabled (VULNERABLE!)

```bash
172.20.0.2:6379> CONFIG GET bind
```

**Expected Output**:
```
1) "bind"
2) "0.0.0.0"
```

**Significance**: Listening on all interfaces (VULNERABLE!)

---

### Step 6: Key Enumeration

#### List All Keys
```bash
172.20.0.2:6379> KEYS *
```

**Expected Output**:
```
 1) "flag"
 2) "temp"
 3) "cache:user:1001"
 4) "session:abcd1234"
 5) "backup:old_flag"
 6) "config:app:version"
 7) "cache:api:rate_limit:192.168.1.100"
 8) "user:session:token:abc123"
 9) "queue:tasks:pending"
10) "stats:visitors:today"
11) "backup:config:2024"
12) "legacy:api:endpoint"
... (and more from sample-data.txt)
```

**Key Observations**:
- Multiple keys present
- Key named `flag` (suspicious!)
- Key named `backup:old_flag` (decoy?)
- Various realistic application keys

#### Check Database Size
```bash
172.20.0.2:6379> DBSIZE
```

**Expected Output**: `(integer) 25` (approximately)

---

### Step 7: Data Retrieval

#### Investigate Flag-Related Keys
```bash
172.20.0.2:6379> GET flag
```

**Expected Output**:
```
"LUH{R3d1s_3num3r4t10n_m4st3r_2026}"
```

**THIS IS THE FLAG!** ✅

#### Check Decoy Keys (Learning Exercise)
```bash
172.20.0.2:6379> GET backup:old_flag
```

**Expected Output**:
```
"LUH{th1s_1s_n0t_th3_fl4g}"
```

**Note**: This is a decoy to teach proper verification.

#### Examine Other Keys
```bash
172.20.0.2:6379> GET temp
"temporary_cache_data_12345"

172.20.0.2:6379> GET cache:user:1001
"john.doe@example.com"

172.20.0.2:6379> GET session:abcd1234
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
```

**Learning Point**: Real databases contain lots of data. Proper enumeration is key.

---

## Security Misconfigurations Found

### Critical Issues

1. **No Authentication**
   - `requirepass` is not set
   - Anyone can connect without credentials
   - **Fix**: `CONFIG SET requirepass "strong-password"`

2. **Exposed to Network**
   - Bound to `0.0.0.0` (all interfaces)
   - Accepts connections from anywhere
   - **Fix**: `bind 127.0.0.1` or use specific IP

3. **Protected Mode Disabled**
   - `protected-mode no`
   - Security features disabled
   - **Fix**: `protected-mode yes`

4. **Dangerous Commands Enabled**
   - `CONFIG` command accessible
   - `FLUSHDB`, `FLUSHALL` available
   - **Fix**: Rename or disable dangerous commands

### Impact

With these misconfigurations:
- Attackers can read all data
- Attackers can modify or delete data
- Attackers could potentially use Redis for other attacks (RCE in some versions)
- No audit log of who accessed what

---

## Alternative Approaches

### Approach 1: Direct IP Scan
If you know the Redis container might be nearby:
```bash
nmap -p 6379 172.20.0.2
redis-cli -h 172.20.0.2
```

### Approach 2: Container Name Resolution
Docker networks support DNS:
```bash
redis-cli -h redis
# Works because container hostname is 'redis'
```

### Approach 3: Health Check API
Check the lab status programmatically:
```bash
curl http://localhost:9001/api/status
```

**Expected Output**:
```json
{
  "lab_status": "ready",
  "services": {
    "redis": {
      "reachable": true,
      "service": "redis",
      "port": 6379
    }
  },
  "tools": {
    "nmap": true,
    "redis-cli": true,
    ...
  }
}
```

---

## Expected Commands Summary

```bash
# 1. Network Discovery
nmap -sn 172.20.0.0/16
nmap -sV 172.20.0.2

# 2. Connect to Redis
redis-cli -h 172.20.0.2

# 3. Information Gathering
PING
INFO
CONFIG GET requirepass
CONFIG GET bind
CONFIG GET protected-mode

# 4. Enumerate Keys
KEYS *
DBSIZE

# 5. Retrieve Flag
GET flag
```

---

## Flag

**Static Flag** (as required):
```
LUH{R3d1s_3num3r4t10n_m4st3r_2026}
```

**Location**: Redis key `flag` on database 0

---

## Validation Checklist

Students should demonstrate:

- [ ] Successfully discovered the Redis service using Nmap
- [ ] Identified the service as Redis on port 6379
- [ ] Connected using `redis-cli`
- [ ] Executed `INFO` command
- [ ] Identified lack of authentication
- [ ] Used `KEYS *` to list all keys
- [ ] Retrieved the correct flag
- [ ] Distinguished flag from decoy
- [ ] Documented at least 3 security misconfigurations

---

## Common Mistakes

### Mistake 1: Wrong Subnet
- **Symptom**: No hosts found
- **Solution**: Check `ip route` for correct subnet

### Mistake 2: Incomplete Enumeration
- **Symptom**: Retrieved decoy flag
- **Solution**: Check ALL flag-related keys

### Mistake 3: Wrong Database
- **Symptom**: No keys found
- **Solution**: Ensure you're in database 0 (`SELECT 0`)

### Mistake 4: Not Reading INFO Output
- **Symptom**: Missing key findings
- **Solution**: Carefully review INFO command output

---

## Instructor Notes

### Lab Validation
Before students start:
```bash
# Start the lab
docker-compose up -d

# Verify services are running
docker ps

# Check Redis is seeded
docker exec -it redeemer-redis redis-cli KEYS \*

# Check OS instance health
curl http://localhost:9001/api/status

# Verify flag exists
docker exec -it redeemer-redis redis-cli GET flag
```

### Expected Output
```bash
# Flag should return:
"LUH{R3d1s_3num3r4t10n_m4st3r_2026}"
```

### Troubleshooting
```bash
# If Redis isn't seeded:
docker exec -it redeemer-redis sh /docker-entrypoint-initdb.d/seed-data.sh

# Check Redis logs:
docker logs redeemer-redis

# Check OS logs:
docker logs redeemer-os
```

---

## Learning Outcomes

After completing this lab, students understand:

1. **Reconnaissance Methodology**
   - Network discovery techniques
   - Service identification with Nmap
   - Port scanning strategies

2. **Service Interaction**
   - Connecting to network services
   - Using service-specific clients (redis-cli)
   - Command execution and output interpretation

3. **Security Analysis**
   - Identifying misconfigurations
   - Understanding authentication requirements
   - Recognizing vulnerable service exposure

4. **Data Enumeration**
   - Systematic key discovery
   - Differentiating between real and decoy data
   - Complete information gathering

---

## Recommended Write-Up Structure

Students should document:

1. **Methodology**
   - Step-by-step approach
   - Tools used
   - Commands executed

2. **Findings**
   - Network topology
   - Services discovered
   - Security misconfigurations

3. **Flag Capture**
   - How the flag was found
   - Validation of authenticity

4. **Remediation**
   - How to secure this Redis instance
   - Best practices for Redis security

---

**End of Solution Guide**
