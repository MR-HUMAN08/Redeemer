#!/bin/bash
# Status check script for Redeemer Lab

echo "=========================================="
echo "  Redeemer Lab - Status Check"
echo "=========================================="
echo ""

# Check if containers are running
echo "Container Status:"
docker compose ps
echo ""

# Check health API
echo "Lab Health:"
if command -v jq &> /dev/null; then
    curl -sf http://localhost:9001/api/status 2>/dev/null | jq . || echo "Health API not responding (lab may still be starting)"
else
    curl -sf http://localhost:9001/api/status 2>/dev/null || echo "Health API not responding (lab may still be starting)"
fi
echo ""

# Check Redis connectivity
echo "Redis Check:"
if docker exec redeemer-redis redis-cli PING &> /dev/null; then
    echo "  ✓ Redis is responding"
    KEY_COUNT=$(docker exec redeemer-redis redis-cli DBSIZE | grep -oE '[0-9]+')
    echo "  ✓ Keys in database: $KEY_COUNT"
    FLAG_EXISTS=$(docker exec redeemer-redis redis-cli EXISTS flag | grep -oE '[0-9]+')
    if [ "$FLAG_EXISTS" -eq 1 ]; then
        echo "  ✓ Flag key exists"
    else
        echo "  ✗ Flag key not found"
    fi
else
    echo "  ✗ Redis is not responding"
fi
echo ""

# Check OS container tools
echo "OS Container Tools:"
if docker exec redeemer-os which nmap &> /dev/null; then
    echo "  ✓ nmap installed"
else
    echo "  ✗ nmap not found"
fi

if docker exec redeemer-os which redis-cli &> /dev/null; then
    echo "  ✓ redis-cli installed"
else
    echo "  ✗ redis-cli not found"
fi
echo ""

echo "Access URLs:"
echo "  Landing Page: http://localhost:8080"
echo "  Desktop:      http://localhost:6080"
echo "  Health API:   http://localhost:9001/api/status"
echo ""
