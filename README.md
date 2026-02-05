# Redeemer Lab - Redis Enumeration Training

![Difficulty](https://img.shields.io/badge/Difficulty-Very%20Easy-brightgreen)
![Focus](https://img.shields.io/badge/Focus-Enumeration-blue)
![Service](https://img.shields.io/badge/Service-Redis-red)

A hands-on penetration testing lab designed to teach Redis service enumeration and security misconfiguration identification. Inspired by HackTheBox's Redeemer challenge.

---

## 📋 Overview

This lab provides a realistic environment for learning:
- Network reconnaissance with Nmap
- Service identification and version detection
- Redis interaction and command execution
- Data enumeration in NoSQL databases
- Security misconfiguration analysis

**Target Audience**: Beginner security students, CTF enthusiasts, pentesting learners

**Prerequisites**: Basic Linux command-line knowledge, understanding of networking concepts

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Redeemer Lab Environment        │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────┐    ┌──────────────┐  │
│  │ OS Instance  │    │    Redis     │  │
│  │  (Attacker)  │───▶│   (Target)   │  │
│  │              │    │              │  │
│  │ • Nmap       │    │ • No Auth    │  │
│  │ • redis-cli  │    │ • Exposed    │  │
│  │ • Desktop    │    │ • Port 6379  │  │
│  └──────────────┘    └──────────────┘  │
│         ▲                               │
│         │                               │
│         └─── noVNC (Browser Access)    │
└─────────────────────────────────────────┘
```

### Components

1. **Web Landing Page** - HTB-style interface
   - Professional red/black themed UI
   - Lab information and objectives
   - Embedded OS instance (click to start)
   
2. **OS Instance** - Debian with Xfce desktop
   - Full GUI via browser (noVNC)
   - Security tools pre-installed
   - Health check API
   
3. **Redis Service** - Intentionally vulnerable
   - No authentication
   - Exposed to network
   - Contains flag and decoy data

---

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- 4GB RAM minimum
- 10GB disk space
- Modern web browser

### Setup

1. **Clone or download this repository**
```bash
cd /path/to/Redeemer
```

2. **Start the lab**
```bash
docker-compose up -d
```

3. **Wait for services to be ready** (30-60 seconds)
```bash
# Check status
docker-compose ps

# Or use the health API
curl http://localhost:9001/api/status
```

4. **Access the lab**
   - **Recommended**: Open browser: `http://localhost:8080` (Landing page)
   - **Direct**: Open browser: `http://localhost:6080` (Desktop only)
   - Click "START OS INSTANCE" on landing page
   - OS will load inline in the browser

5. **Begin enumeration**
   - Follow the guide in `attacker-notes/enumeration.md`
   - Start with network discovery: `nmap -sn 172.20.0.0/16`

---

## 📁 Project Structure

```
redeemer/
├── README.md                      # This file
├── docker-compose.yml             # Orchestration configuration
├── .gitignore                     # Git ignore patterns
│
├── OS/                            # Attacker machine
│   ├── Dockerfile                 # OS instance build file
│   ├── entrypoint.sh              # Startup script
│   ├── supervisord.conf           # Process management
│   ├── README.md                  # OS instance docs
│   └── scripts/
│       └── health_api.py          # Health check API
│
├── redis/                         # Target service
│   ├── Dockerfile                 # Redis build file
│   ├── redis.conf                 # Vulnerable configuration
│   ├── init/
│   │   └── seed-data.sh           # Data seeding script
│   ├── data/
│   │   └── sample-data.txt        # Additional sample keys
│   └── scripts/
│       └── entrypoint.sh          # Redis startup + seeding
│
└── attacker-notes/                # Student documentation
    ├── enumeration.md             # Enumeration methodology
    └── expected-solution.md       # Complete walkthrough
```

---

## 🎯 Learning Objectives

By completing this lab, you will learn to:

- ✅ Perform network reconnaissance using Nmap
- ✅ Identify services and their versions
- ✅ Connect to Redis using redis-cli
- ✅ Execute Redis information-gathering commands
- ✅ Enumerate keys and retrieve data
- ✅ Identify security misconfigurations
- ✅ Distinguish real flags from decoys
- ✅ Document penetration testing findings

---

## 🔧 Usage

### Starting the Lab

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Check service status
docker-compose ps
```

### Accessing the Environment

| Service | URL | Purpose |
|---------|-----|---------|
| noVNC Desktop | http://localhost:6080 | Main access point |
| Health API | http://localhost:9001/api/status | Lab status check |
| Redis (direct) | localhost:6379 | Direct Redis access |

### Health Check

```bash
# Check if lab is ready
curl http://localhost:9001/api/status

# Get lab information
curl http://localhost:9001/api/info

# Simple health check
curl http://localhost:9001/api/health
```

**Expected Response** (when ready):
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
    "redis-cli": true
  }
}
```

### Stopping the Lab

```bash
# Stop services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# Stop and remove images
docker-compose down --rmi all
```

---

## 🎓 Lab Workflow

### Recommended Approach

1. **Access Desktop** → Open `http://localhost:6080`
2. **Read Documentation** → Review `attacker-notes/enumeration.md`
3. **Discover Network** → Use Nmap to find hosts
4. **Identify Services** → Scan for open ports
5. **Connect to Redis** → Use redis-cli
6. **Enumerate Data** → List keys and retrieve values
7. **Capture Flag** → Find the real flag (not decoys!)
8. **Document Findings** → Write your methodology

### Hints

- The network subnet is `172.20.0.0/16`
- Redis runs on its default port
- No authentication is required (this is the vulnerability!)
- The flag key is straightforward, but verify it's not a decoy
- Use `INFO`, `CONFIG GET *`, and `KEYS *` commands

---

## 🔒 Security Misconfigurations (Educational)

This lab intentionally includes these vulnerabilities:

### 1. No Authentication
```redis
CONFIG GET requirepass
# Returns: "" (empty)
```
**Impact**: Anyone can connect without credentials

### 2. Exposed to Network
```redis
CONFIG GET bind
# Returns: "0.0.0.0"
```
**Impact**: Accepts connections from any IP

### 3. Protected Mode Disabled
```redis
CONFIG GET protected-mode
# Returns: "no"
```
**Impact**: Security safeguards disabled

### 4. Dangerous Commands Enabled
- `CONFIG` command accessible
- `FLUSHDB`, `FLUSHALL` available
- No command restrictions

**⚠️ WARNING**: Never deploy Redis like this in production!

---

## 🛠️ Troubleshooting

### Services Won't Start

```bash
# Check Docker is running
docker ps

# View detailed logs
docker-compose logs

# Rebuild images
docker-compose build --no-cache
docker-compose up -d
```

### Can't Access noVNC

- Ensure port 6080 is not in use: `lsof -i :6080`
- Try accessing: `http://127.0.0.1:6080`
- Check OS container logs: `docker logs redeemer-os`

### Redis Not Responding

```bash
# Check Redis container
docker exec -it redeemer-redis redis-cli PING

# Verify data is seeded
docker exec -it redeemer-redis redis-cli KEYS \*

# Re-seed manually
docker exec -it redeemer-redis sh /docker-entrypoint-initdb.d/seed-data.sh
```

### Health API Not Working

```bash
# Check API logs
docker logs redeemer-os | grep health_api

# Test manually
docker exec -it redeemer-os curl http://localhost:9001/api/health
```

### Nmap/Redis-CLI Not Found

This should be installed automatically. If missing:
```bash
docker exec -it redeemer-os apt-get update
docker exec -it redeemer-os apt-get install -y nmap redis-tools
```

---

## 📊 Validation

### For Students

After completion, you should have:
- [ ] Discovered the Redis service IP
- [ ] Identified port 6379 as open
- [ ] Connected using redis-cli
- [ ] Listed all keys in the database
- [ ] Retrieved the correct flag
- [ ] Documented 3+ security misconfigurations
- [ ] Written a methodology report

### For Instructors

Validate student work:
```bash
# Verify flag exists
docker exec -it redeemer-redis redis-cli GET flag
# Should return: LUH{R3d1s_3num3r4t10n_m4st3r_2026}

# Check configuration vulnerabilities
docker exec -it redeemer-redis redis-cli CONFIG GET requirepass
docker exec -it redeemer-redis redis-cli CONFIG GET bind
docker exec -it redeemer-redis redis-cli CONFIG GET protected-mode
```

---

## 🎯 Expected Flag

**Format**: `LUH{R3d1s_3num3r4t10n_m4st3r_2026}`

**Location**: Redis key `flag` in database 0

**Note**: Decoy flags exist! Verify your finding.

---

## 📚 Further Learning

### Recommended Resources

- [Redis Official Documentation](https://redis.io/documentation)
- [Redis Security Best Practices](https://redis.io/topics/security)
- [Nmap Network Scanning Guide](https://nmap.org/book/)
- [HackTheBox Academy](https://academy.hackthebox.com/)

### Related Labs

- **Redis Exploitation**: RCE via misconfigured Redis
- **Network Pivoting**: Using compromised Redis as pivot
- **Data Exfiltration**: Extracting sensitive data from databases

### Next Steps

1. Research Redis security hardening
2. Learn about Redis ACLs (Access Control Lists)
3. Explore Redis persistence mechanisms
4. Study other NoSQL databases (MongoDB, Memcached)

---

## 🤝 Contributing

This is an educational project. Improvements welcome!

### Areas for Enhancement

- [ ] Additional decoy data patterns
- [ ] Multiple database scenarios
- [ ] Network segmentation exercises
- [ ] IDS/IPS detection scenarios
- [ ] Logging and monitoring integration

---

## ⚠️ Disclaimer

**FOR EDUCATIONAL USE ONLY**

This lab contains intentionally vulnerable configurations. It is designed solely for:
- Security education and training
- Controlled learning environments
- Penetration testing practice

**DO NOT**:
- Deploy in production
- Expose to public networks
- Use for malicious purposes
- Share flags or solutions publicly (spoils learning)

---

## 📝 License

Educational use only. Not for production deployment.

---

## 🆘 Support

### Getting Help

1. Check `attacker-notes/enumeration.md` for methodology
2. Review `attacker-notes/expected-solution.md` if stuck
3. Verify lab status: `curl http://localhost:9001/api/status`
4. Check Docker logs: `docker-compose logs`

### Common Questions

**Q: How long should this take?**  
A: 15-30 minutes for complete enumeration and flag capture.

**Q: Can I use other tools?**  
A: Yes! While Nmap and redis-cli are recommended, feel free to experiment.

**Q: Is there a write-up template?**  
A: Follow the structure in `expected-solution.md` as a guide.

**Q: Can I modify the lab?**  
A: Absolutely! Fork it and customize for your needs.

---

## 🎉 Acknowledgments

- Inspired by [HackTheBox](https://www.hackthebox.com/) Redeemer challenge
- Redis project for the excellent database technology
- NoVNC team for browser-based VNC access
- Security education community

---

**Happy Hacking! 🚀**

*Remember: This is about learning methodology, not just finding the flag.*
