# Utility Scripts

This directory contains helper scripts to manage the Redeemer lab.

## Available Scripts

### `build-and-validate.sh`
**Purpose**: Complete build, start, and validation process

**Usage**:
```bash
./scripts/build-and-validate.sh
```

**What it does**:
- Checks Docker prerequisites
- Builds all images from scratch
- Starts all services
- Validates Redis is working
- Validates OS instance is working
- Checks network connectivity
- Displays access information

**When to use**: First-time setup or after major changes

---

### `start.sh`
**Purpose**: Quick start the lab

**Usage**:
```bash
./scripts/start.sh
```

**What it does**:
- Starts all services with `docker-compose up -d`
- Shows access URLs

**When to use**: Daily lab startup

---

### `stop.sh`
**Purpose**: Stop the lab

**Usage**:
```bash
./scripts/stop.sh
```

**What it does**:
- Stops all containers with `docker-compose down`
- Provides options for cleanup

**When to use**: When done with the lab session

---

### `status.sh`
**Purpose**: Check lab health and status

**Usage**:
```bash
./scripts/status.sh
```

**What it does**:
- Shows container status
- Queries health API
- Checks Redis connectivity
- Verifies tools are installed
- Displays access URLs

**When to use**: To verify lab is ready or troubleshoot issues

---

### `reset.sh`
**Purpose**: Complete lab reset

**Usage**:
```bash
./scripts/reset.sh
```

**What it does**:
- Stops all containers
- Removes volumes (deletes all data)
- Removes images
- Rebuilds everything from scratch

**When to use**: 
- Lab is corrupted
- Want a completely clean state
- Testing changes to Dockerfiles

**⚠️ WARNING**: This deletes all data!

---

### `logs.sh`
**Purpose**: View container logs

**Usage**:
```bash
./scripts/logs.sh
```

**What it does**:
- Interactive menu to select which logs to view
- Options: all services, Redis only, OS only, or Health API only

**When to use**: Debugging or monitoring

---

## Quick Reference

```bash
# First time setup
./scripts/build-and-validate.sh

# Daily use
./scripts/start.sh          # Start lab
./scripts/status.sh         # Check if ready
./scripts/stop.sh           # Stop when done

# Troubleshooting
./scripts/logs.sh           # View logs
./scripts/status.sh         # Check status
./scripts/reset.sh          # Nuclear option

# Manual Docker commands
docker-compose up -d        # Start
docker-compose down         # Stop
docker-compose ps           # Status
docker-compose logs -f      # Logs
```

---

## Script Dependencies

All scripts require:
- Docker installed and running
- Docker Compose installed
- Bash shell
- Run from project root directory

Some scripts use optional tools:
- `curl` - for API checks
- `jq` - for pretty JSON output (optional)

---

## Execution Permissions

All scripts should be executable. If not:

```bash
chmod +x scripts/*.sh
```

---

## Troubleshooting Scripts

### Script shows "Permission Denied"
```bash
chmod +x scripts/*.sh
```

### "Docker not found"
Ensure Docker is installed and running:
```bash
docker --version
docker ps
```

### "docker-compose not found"
Install Docker Compose or use `docker compose` (v2):
```bash
docker-compose --version
# OR
docker compose version
```

---

## Adding Custom Scripts

Feel free to add your own scripts here! Follow these guidelines:

1. **Use descriptive names**: `action-description.sh`
2. **Add help text**: Echo usage instructions
3. **Make executable**: `chmod +x scripts/your-script.sh`
4. **Update this README**: Document your script

Example template:
```bash
#!/bin/bash
# Your Script Name - Brief description

echo "=========================================="
echo "  Your Script Name"
echo "=========================================="
echo ""

# Your logic here

echo "Done!"
```

---

## Script Best Practices

These scripts follow these conventions:

- ✅ Clear, descriptive output
- ✅ Error checking (set -e when appropriate)
- ✅ Confirmation prompts for destructive actions
- ✅ Display access URLs after operations
- ✅ Colored output for better readability
- ✅ Help text and usage examples

---

**Happy Scripting! 🚀**
