#!/bin/bash
# Quick start script for Redeemer Lab

echo "Starting Redeemer Lab..."
echo ""

# Check if already running
if docker ps | grep -q redeemer; then
    echo "⚠️  Lab appears to be already running."
    echo "    Run './scripts/stop.sh' first if you want to restart."
    echo ""
    exit 1
fi

# Start services
docker compose up -d

echo ""
echo "✓ Lab is starting up..."
echo ""
echo "Please wait 30-60 seconds for services to initialize."
echo ""
echo "Access the lab:"
echo "  Landing Page: http://localhost:8080"
echo "  Direct Desktop: http://localhost:6080"
echo "  Health API: http://localhost:9001/api/status"
echo ""
echo "Check status: curl http://localhost:9001/api/status"
echo "View logs:    docker compose logs -f"
echo ""
