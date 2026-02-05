# Enumeration Guide - Redeemer Lab

## Objective
Learn how to enumerate and interact with an exposed Redis service using standard reconnaissance and interaction tools.

---

## Lab Environment

### What You Have
- **Attacker Machine**: Debian desktop with security tools
  - Access via browser: `http://localhost:6080`
  - Tools available: `nmap`, `redis-cli`, `netcat`, `telnet`, etc.

### What You're Looking For
- A Redis service running somewhere on the network
- The service may contain sensitive data
- Your goal: Find and retrieve the flag

---

## Enumeration Methodology

### Phase 1: Network Discovery

**Objective**: Identify what hosts and services are available on the network.

#### Step 1.1: Identify Your Network
```bash
# Check your IP address
ip addr show

# Check your network range
ip route
```

**Expected**: You'll see your IP (likely `172.20.x.x`) and network range.

#### Step 1.2: Discover Active Hosts
```bash
# Ping sweep to find active hosts
nmap -sn 172.20.0.0/16

# Alternative: Faster scan of common subnet
nmap -sn 172.20.0.0/24
```

**What to look for**: Active hosts responding to ping.

---

### Phase 2: Service Detection

**Objective**: Identify what services are running on discovered hosts.

#### Step 2.1: Port Scan Common Services
```bash
# Scan common ports on a discovered host
nmap <TARGET_IP>

# More comprehensive scan
nmap -p- <TARGET_IP>

# Service version detection
nmap -sV <TARGET_IP>
```

**What to look for**: Open port 6379 (Redis default).

#### Step 2.2: Identify the Redis Service
```bash
# Target the specific Redis port
nmap -p 6379 -sV <TARGET_IP>

# Script scan for additional info
nmap -p 6379 -sC -sV <TARGET_IP>
```

**Expected Output**:
```
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 6.x
```

---

### Phase 3: Service Interaction

**Objective**: Connect to Redis and enumerate data.

#### Step 3.1: Test Connectivity
```bash
# Simple connectivity test
nc -zv <TARGET_IP> 6379

# Or with telnet
telnet <TARGET_IP> 6379
```

**Expected**: Connection established.

#### Step 3.2: Connect with Redis Client
```bash
# Connect using redis-cli
redis-cli -h <TARGET_IP>

# Alternative: specify port explicitly
redis-cli -h <TARGET_IP> -p 6379
```

**Expected**: You get a Redis prompt: `<TARGET_IP>:6379>`

#### Step 3.3: Gather Information
```bash
# Once connected to Redis, try these commands:

# Test authentication (check if password required)
PING

# Get server information
INFO

# Get configuration (reveals security settings)
CONFIG GET *

# Check current database
SELECT 0

# List all keys in the database
KEYS *

# Get database size
DBSIZE
```

**What to look for**:
- `INFO` reveals Redis version, configuration, and stats
- `CONFIG GET *` shows security settings (look for `requirepass`)
- `KEYS *` lists all keys (including potential flags)

---

### Phase 4: Data Extraction

**Objective**: Retrieve and examine data from Redis.

#### Step 4.1: Enumerate All Keys
```bash
# In redis-cli session:
KEYS *
```

**Expected**: List of keys like:
```
1) "flag"
2) "temp"
3) "cache:user:1001"
4) "session:abcd1234"
5) "backup:old_flag"
... (more keys)
```

#### Step 4.2: Retrieve Key Values
```bash
# Get the value of a specific key
GET flag

# Check data type of a key
TYPE flag

# Get all keys matching a pattern
KEYS *flag*

# Scan keys (safer for large databases)
SCAN 0 MATCH *flag* COUNT 10
```

**Mission**: Find the real flag among decoy keys.

#### Step 4.3: Examine Suspicious Keys
```bash
# Check decoy keys
GET backup:old_flag
GET temp
GET cache:user:1001

# Compare with the main flag
GET flag
```

---

## Common Redis Commands Reference

### Information Gathering
```bash
PING                    # Test connection
INFO                    # Server information
CONFIG GET *            # Get all configuration
CLIENT LIST             # List connected clients
DBSIZE                  # Number of keys in database
```

### Key Operations
```bash
KEYS *                  # List all keys (use with caution on prod)
KEYS pattern*           # List keys matching pattern
SCAN 0                  # Safer iteration over keys
EXISTS key              # Check if key exists
TYPE key                # Get key data type
TTL key                 # Time to live (expiration)
```

### Data Retrieval
```bash
GET key                 # Get string value
MGET key1 key2          # Get multiple keys
HGETALL key             # Get all fields of hash
LRANGE key 0 -1         # Get all list elements
SMEMBERS key            # Get all set members
```

### Database Operations
```bash
SELECT 0                # Switch to database 0 (default)
SELECT 1                # Switch to database 1
FLUSHDB                 # Delete all keys in current DB (DANGER!)
FLUSHALL                # Delete all keys in all DBs (DANGER!)
```

---

## Red Flags (Security Misconfigurations)

When you see these, the Redis instance is vulnerable:

1. **No Authentication**
   ```
   CONFIG GET requirepass
   Returns: ""  (empty = no password)
   ```

2. **Bound to All Interfaces**
   ```
   CONFIG GET bind
   Returns: "0.0.0.0"  (accepts connections from anywhere)
   ```

3. **Protected Mode Disabled**
   ```
   CONFIG GET protected-mode
   Returns: "no"  (security disabled)
   ```

4. **Dangerous Commands Enabled**
   - `CONFIG` command available
   - `FLUSHDB`, `FLUSHALL` not disabled
   - No command renaming

---

## Tips for Success

1. **Start Broad, Then Narrow**
   - Network scan → Host discovery → Port scan → Service enumeration

2. **Read the Output**
   - `INFO` command gives tons of useful information
   - `CONFIG GET *` reveals security posture

3. **Enumerate Thoroughly**
   - Don't assume the first key is the flag
   - Check all keys, especially ones with "flag" in the name
   - Decoys exist to teach proper enumeration

4. **Document As You Go**
   - Note IP addresses, open ports, and interesting findings
   - Keep a command history for your write-up

5. **Understand What You Find**
   - Why is this service exposed?
   - What misconfigurations allow this access?
   - How could this be secured?

---

## Learning Objectives Checklist

By completing this lab, you should be able to:

- [ ] Perform network reconnaissance with Nmap
- [ ] Identify Redis services on the network
- [ ] Connect to Redis using `redis-cli`
- [ ] Execute Redis information-gathering commands
- [ ] Enumerate keys and retrieve data
- [ ] Distinguish between real flags and decoys
- [ ] Identify security misconfigurations in Redis
- [ ] Document your enumeration process

---

## Troubleshooting

### Can't Find Any Hosts
```bash
# Check your own network first
ip addr show
ip route

# Make sure you're scanning the right subnet
nmap -sn 172.20.0.0/24
```

### Connection Refused on Port 6379
- Verify the service is running: `docker ps`
- Check if port is open: `nmap -p 6379 <TARGET_IP>`
- Ensure you're targeting the correct IP

### Redis Commands Not Working
- Make sure you're in the `redis-cli` session
- Check if authentication is required (shouldn't be in this lab)
- Verify you're connected to the right host

### Can't See All Keys
- You might be in the wrong database: `SELECT 0`
- Keys might be scattered across databases: try `SELECT 1`, `SELECT 2`, etc.

---

## Next Steps

After completing this lab:
1. Write up your methodology
2. Document all misconfigurations you found
3. Research how to properly secure Redis
4. Try other enumeration techniques

**Remember**: This lab teaches reconnaissance and enumeration, not exploitation. Focus on the information-gathering process.
