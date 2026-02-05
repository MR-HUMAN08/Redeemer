#!/bin/bash
# Redeemer Lab - Build and Validation Script
# Purpose: Build images, start lab, and validate everything works

set -e

echo "=========================================="
echo "  Redeemer Lab - Build & Validation"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}[✓]${NC} $2"
    else
        echo -e "${RED}[✗]${NC} $2"
    fi
}

print_info() {
    echo -e "${YELLOW}[*]${NC} $1"
}

# Check prerequisites
print_info "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    print_status 1 "Docker not found"
    exit 1
fi
print_status 0 "Docker installed"

if ! docker compose version &> /dev/null; then
    print_status 1 "Docker Compose not found"
    exit 1
fi
print_status 0 "Docker Compose installed"

echo ""

# Build images
print_info "Building Docker images..."
docker compose build --no-cache
print_status $? "Images built successfully"

echo ""

# Start services
print_info "Starting lab services..."
docker compose up -d
print_status $? "Services started"

echo ""

# Wait for services to be ready
print_info "Waiting for services to initialize (30 seconds)..."
sleep 30

echo ""

# Validate Redis
print_info "Validating Redis service..."

if docker exec redeemer-redis redis-cli PING &> /dev/null; then
    print_status 0 "Redis is responding"
else
    print_status 1 "Redis is not responding"
fi

# Check if data is seeded
KEY_COUNT=$(docker exec redeemer-redis redis-cli DBSIZE | grep -oE '[0-9]+')
if [ "$KEY_COUNT" -gt 10 ]; then
    print_status 0 "Redis data seeded ($KEY_COUNT keys found)"
else
    print_status 1 "Redis data not properly seeded (only $KEY_COUNT keys)"
fi

# Check flag exists
FLAG=$(docker exec redeemer-redis redis-cli GET flag 2>/dev/null)
if echo "$FLAG" | grep -q "LUH{"; then
    print_status 0 "Flag exists in Redis"
else
    print_status 1 "Flag not found in Redis"
fi

# Check Redis configuration vulnerabilities
NO_AUTH=$(docker exec redeemer-redis redis-cli CONFIG GET requirepass | grep -c '""' || echo 0)
if [ "$NO_AUTH" -gt 0 ]; then
    print_status 0 "Redis has no authentication (vulnerable as intended)"
else
    print_status 1 "Redis has authentication (lab may not work correctly)"
fi

echo ""

# Validate OS Instance
print_info "Validating OS instance..."

# Check if container is running
if docker ps | grep -q redeemer-os; then
    print_status 0 "OS container is running"
else
    print_status 1 "OS container is not running"
fi

# Check health API
if curl -sf http://localhost:9001/api/health &> /dev/null; then
    print_status 0 "Health API is accessible"
else
    print_status 1 "Health API is not accessible (still starting up?)"
fi

# Check if nmap exists
if docker exec redeemer-os which nmap &> /dev/null; then
    print_status 0 "Nmap is installed in OS container"
else
    print_status 1 "Nmap is not installed"
fi

# Check if redis-cli exists
if docker exec redeemer-os which redis-cli &> /dev/null; then
    print_status 0 "redis-cli is installed in OS container"
else
    print_status 1 "redis-cli is not installed"
fi

echo ""

# Network validation
print_info "Validating network connectivity..."

# Check if OS can reach Redis
if docker exec redeemer-os ping -c 1 redis &> /dev/null; then
    print_status 0 "OS container can reach Redis via hostname"
else
    print_status 1 "OS container cannot reach Redis"
fi

# Check if OS can connect to Redis port
if docker exec redeemer-os nc -zv redis 6379 &> /dev/null; then
    print_status 0 "OS container can connect to Redis port 6379"
else
    print_status 1 "OS container cannot connect to Redis port"
fi

echo ""
echo "=========================================="
echo "  Lab Status Summary"
echo "=========================================="

# Get comprehensive status
LAB_STATUS=$(curl -sf http://localhost:9001/api/status 2>/dev/null || echo "{}")

if echo "$LAB_STATUS" | grep -q '"lab_status":"ready"'; then
    echo -e "${GREEN}Lab Status: READY ✓${NC}"
else
    echo -e "${YELLOW}Lab Status: STARTING (may need more time)${NC}"
fi

echo ""
echo "=========================================="
echo "  Access Information"
echo "=========================================="
echo ""
echo "  Desktop (noVNC):  http://localhost:6080"
echo "  Health API:       http://localhost:9001/api/status"
echo "  Redis Direct:     localhost:6379"
echo ""
echo "=========================================="
echo "  Quick Start Commands"
echo "=========================================="
echo ""
echo "  # Access desktop in browser"
echo "  Open: http://localhost:6080"
echo ""
echo "  # Check lab status"
echo "  curl http://localhost:9001/api/status | jq"
echo ""
echo "  # View logs"
echo "  docker-compose logs -f"
echo ""
echo "  # Stop lab"
echo "  docker-compose down"
echo ""
echo "=========================================="
echo "  Next Steps"
echo "=========================================="
echo ""
echo "  1. Open browser to http://localhost:6080"
echo "  2. Open terminal in the desktop"
echo "  3. Start enumeration: nmap -sn 172.20.0.0/16"
echo "  4. Follow guide: attacker-notes/enumeration.md"
echo ""
echo "Happy Hacking! 🚀"
echo ""
