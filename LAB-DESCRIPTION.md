# Redeemer Lab - Detailed Description

## 🎯 Overview

**Redeemer Lab** is a comprehensive penetration testing training environment designed for beginners and intermediate security enthusiasts. This lab focuses on teaching essential skills for identifying and exploiting misconfigured Redis database services in production environments.

### Lab Scenario

You are a penetration tester conducting an assessment of a client's infrastructure. During the reconnaissance phase, you discover a Redis database service exposed to the network. Your mission is to:

1. Identify the Redis service on the network
2. Enumerate the service to understand its configuration
3. Determine if authentication is required
4. Extract sensitive data including the target flag
5. Document security vulnerabilities discovered

---

## 🎓 Learning Objectives

### Skills You Will Learn

#### 1. Network Reconnaissance
- Perform network discovery using ping sweeps
- Identify active hosts on a subnet
- Understand IP addressing and CIDR notation
- Map internal network topology

#### 2. Service Enumeration
- Scan for open ports using Nmap
- Identify service versions and fingerprints
- Recognize default service ports (Redis: 6379)
- Use NSE scripts for detailed service information

#### 3. Redis Interaction
- Connect to Redis using `redis-cli`
- Execute Redis commands for enumeration
- Understanding Redis data structures (strings, lists, sets, hashes)
- Navigate and query Redis databases

#### 4. Security Analysis
- Identify authentication bypass vulnerabilities
- Recognize security misconfigurations
- Understand the impact of exposed databases
- Differentiate between real and decoy data

---

## 🏗️ Lab Architecture

### Environment Components

#### 1. Web Landing Page (Port 8080)
A professional HackTheBox-style interface that provides:
- Lab overview and objectives
- Embedded OS instance access
- Visual layout of the lab environment
- One-click launch functionality

#### 2. Attacker OS Instance (Port 6080)
A fully-featured Debian Linux environment with:
- **Desktop Environment**: Xfce (lightweight and responsive)
- **Browser Access**: noVNC for browser-based interaction
- **Pre-installed Tools**:
  - `nmap` - Network scanning and enumeration
  - `redis-cli` - Redis command-line interface
  - `netcat` - Network connection utility
  - `telnet` - Telnet client
  - Standard Linux utilities

#### 3. Target Redis Service (Port 6379)
A intentionally vulnerable Redis 6.2 database configured with:
- **No Authentication**: Password protection disabled
- **Network Exposure**: Bound to all interfaces (0.0.0.0)
- **Protected Mode Disabled**: Redis safety features turned off
- **Pre-seeded Data**: Contains flag, decoys, and realistic data

### Network Topology

```
Docker Network: 172.20.0.0/16
├── OS Instance (Attacker): 172.20.0.3
└── Redis Service (Target): 172.20.0.2

External Access:
├── http://localhost:8080 → Web Landing Page
├── http://localhost:6080 → OS Instance (noVNC)
└── Port 6379 exposed only internally
```

---

## 🔍 What Makes This Lab Realistic?

### Real-World Scenarios Simulated

1. **Exposed Internal Services**
   - Mimics cloud environments with misconfigured security groups
   - Represents containerized applications with improper network isolation
   - Simulates legacy systems without proper access controls

2. **No Authentication**
   - Common misconfiguration in development environments
   - Often seen in Docker containers with default configurations
   - Represents rushed deployments without security hardening

3. **Data Exfiltration Opportunity**
   - Contains sensitive information (flag represents credentials/secrets)
   - Includes decoy data to simulate production databases
   - Tests ability to identify valuable information

---

## 🎯 Target Audience

### Ideal for:

- **Penetration Testing Students** - Learning basic enumeration techniques
- **CTF Beginners** - Getting started with capture-the-flag challenges
- **Security Analysts** - Understanding database security misconfigurations
- **DevOps Engineers** - Learning what NOT to do in production
- **Bug Bounty Hunters** - Practicing reconnaissance methodologies

### Prerequisites:

- Basic Linux command-line knowledge
- Understanding of networking fundamentals (IP addresses, ports)
- Familiarity with terminal/console usage
- No prior pentesting experience required

---

## 🚨 Vulnerabilities & Misconfigurations

### Security Issues Present in This Lab:

#### 1. No Authentication (Critical)
```bash
# Redis accepts connections without password
requirepass ""  # Empty or commented out
```
**Impact**: Anyone can connect and access data  
**Real-World Risk**: Data exfiltration, service disruption, ransomware

#### 2. Network Exposure (High)
```bash
# Redis listening on all interfaces
bind 0.0.0.0
```
**Impact**: Accessible from any network location  
**Real-World Risk**: Internet-facing databases, lateral movement

#### 3. Protected Mode Disabled (High)
```bash
protected-mode no
```
**Impact**: Redis allows external connections without authentication  
**Real-World Risk**: Easier exploitation, no warning prompts

#### 4. Dangerous Commands Enabled (Medium)
```bash
# Potentially dangerous commands not disabled
rename-command CONFIG ""  # Not implemented
rename-command FLUSHDB ""  # Not implemented
```
**Impact**: Attackers can reconfigure or destroy data  
**Real-World Risk**: Service disruption, data loss

---

## 💡 Educational Value

### What You'll Understand After Completing This Lab:

1. **Reconnaissance is Critical**
   - How to systematically discover network resources
   - The importance of understanding your target environment
   - Tools and techniques for information gathering

2. **Default Configurations are Dangerous**
   - Why default ports make services easy to find
   - The risks of running services without authentication
   - How misconfigurations lead to security breaches

3. **Data Enumeration Techniques**
   - How to navigate NoSQL databases
   - Methods for identifying valuable information
   - Strategies for distinguishing real data from decoys

4. **Security Best Practices**
   - Why authentication should always be enabled
   - The importance of network segmentation
   - How to properly secure Redis in production

---

## 📊 Lab Difficulty

**Rating**: Very Easy (Beginner)

**Estimated Completion Time**: 15-30 minutes

**Difficulty Breakdown**:
- Network Discovery: ⭐☆☆☆☆ (Very Easy)
- Service Enumeration: ⭐☆☆☆☆ (Very Easy)
- Redis Interaction: ⭐☆☆☆☆ (Very Easy)
- Flag Retrieval: ⭐☆☆☆☆ (Very Easy)

This is an introductory lab designed to build confidence and teach fundamental skills. No exploitation or complex techniques are required.

---

## 🎁 What's Included

### Documentation
- Comprehensive README with setup instructions
- Quick start guide for fast deployment
- Development documentation for customization
- Deployment checklist for validation

### Student Resources
- Enumeration methodology guide (this file)
- Complete solution walkthrough with explanations
- Example commands and expected outputs
- Troubleshooting tips and common issues

### Utility Scripts
- `start.sh` - One-command lab startup
- `stop.sh` - Clean lab shutdown
- `status.sh` - Health check verification
- `reset.sh` - Clean rebuild from scratch
- `logs.sh` - View service logs for debugging

---

## 🔧 Technical Requirements

### System Requirements
- **Operating System**: Linux, macOS, or Windows with WSL2
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 1.29 or higher
- **RAM**: 4GB minimum (6GB recommended)
- **Disk Space**: 10GB free space
- **Browser**: Modern browser (Chrome, Firefox, Edge, Safari)

### Network Requirements
- Ports 8080, 6080 must be available on host
- Port 6379 used internally (Docker network)
- Internet connection for initial Docker image pull

---

## 🌟 Key Features

### 1. Browser-Based Access
- No local tools installation required
- Access from any device with a browser
- Cross-platform compatibility (Windows, Mac, Linux)
- Instructor-friendly for classroom environments

### 2. Realistic Data
- Multiple database keys with varied content
- Decoy flags to test enumeration skills
- Session tokens, user data, and configuration samples
- Simulates production database contents

### 3. Immediate Feedback
- Health check API for status verification
- Log viewing for troubleshooting
- Quick reset for retry attempts
- Clear success indicators

### 4. Complete Isolation
- All services run in Docker containers
- No impact on host system
- Safe to experiment and make mistakes
- Easy cleanup with single command

---

## 📈 Progression Path

### After Completing Redeemer:

1. **Next Steps in Redis Security**:
   - Explore authenticated Redis enumeration
   - Learn Redis exploitation techniques (RCE)
   - Study Redis replication attacks
   - Investigate Redis module backdoors

2. **Similar Beginner Labs**:
   - MongoDB enumeration (NoSQL)
   - Memcached information disclosure
   - Elasticsearch data exfiltration
   - CouchDB authentication bypass

3. **Advanced Topics**:
   - Lateral movement in containerized environments
   - Privilege escalation via service misconfigurations
   - Web application database enumeration
   - Cloud provider metadata service attacks

---

## 🛡️ Security Notice

### Important Reminders:

⚠️ **This lab is intentionally vulnerable**  
- Contains security misconfigurations by design
- Should never be exposed to the internet
- Use only in isolated lab environments
- Do not replicate these configurations in production

⚠️ **Educational Purpose Only**  
- Designed for authorized security training
- Use skills learned responsibly and ethically
- Always obtain proper authorization before testing
- Follow responsible disclosure practices

⚠️ **Network Isolation**  
- Lab runs in isolated Docker network
- External access limited to web ports only
- Redis not directly accessible from host
- Safe for local training and education

---

## 📚 Further Reading

### Redis Security Resources:
- [Redis Security Documentation](https://redis.io/topics/security)
- [Redis ACL Tutorial](https://redis.io/topics/acl)
- [OWASP: Database Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Database_Security_Cheat_Sheet.html)

### Enumeration Techniques:
- [Nmap Network Scanning](https://nmap.org/book/man.html)
- [Redis Command Reference](https://redis.io/commands)
- [Penetration Testing Methodologies](https://www.pentest-standard.org/)

---

## 🤝 Support & Feedback

### Getting Help:
- Review the QUICKSTART.md for common issues
- Check DEVELOPMENT.md for technical details
- Use `scripts/status.sh` to verify lab health
- Review logs with `scripts/logs.sh`

### Providing Feedback:
- Report issues with detailed error messages
- Suggest improvements or additional features
- Share your learning experience
- Contribute to documentation improvements

---

## 📝 Credits

- **Inspired by**: HackTheBox Redeemer Challenge
- **Created for**: Security education and training
- **Purpose**: Teaching responsible security practices
- **License**: Educational use

---

**Happy Hacking! 🚀**

*Remember: Skills learned here should only be used for authorized security testing and education. Always practice ethical hacking.*
