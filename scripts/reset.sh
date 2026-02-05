#!/bin/bash
# Reset script for Redeemer Lab
# Completely removes everything and rebuilds

echo "=========================================="
echo "  Redeemer Lab - Complete Reset"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will:"
echo "  - Stop all containers"
echo "  - Remove all volumes (data loss)"
echo "  - Remove all images"
echo "  - Rebuild from scratch"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Reset cancelled."
    exit 1
fi

echo ""
echo "Stopping containers..."
docker compose down

echo "Removing volumes..."
docker compose down -v

echo "Removing images..."
docker compose down --rmi all

echo ""
echo "Rebuilding..."
docker compose build --no-cache

echo ""
echo "✓ Reset complete!"
echo ""
echo "To start the lab:"
echo "  ./scripts/start.sh"
echo ""
