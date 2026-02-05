#!/bin/bash
# Stop script for Redeemer Lab

echo "Stopping Redeemer Lab..."
echo ""

docker compose down

echo ""
echo "✓ Lab stopped."
echo ""
echo "To remove all data (clean slate):"
echo "  docker compose down -v"
echo ""
echo "To restart:"
echo "  ./scripts/start.sh"
echo ""
