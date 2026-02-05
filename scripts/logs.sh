#!/bin/bash
# View logs for Redeemer Lab components

echo "=========================================="
echo "  Redeemer Lab - Logs Viewer"
echo "=========================================="
echo ""
echo "Select which logs to view:"
echo ""
echo "  1) All services"
echo "  2) Redis only"
echo "  3) OS instance only"
echo "  4) Health API only"
echo ""
read -p "Enter choice (1-4): " -n 1 -r
echo ""
echo ""

case $REPLY in
    1)
        echo "Viewing all logs (Ctrl+C to exit)..."
        docker compose logs -f
        ;;
    2)
        echo "Viewing Redis logs (Ctrl+C to exit)..."
        docker compose logs -f redis
        ;;
    3)
        echo "Viewing OS instance logs (Ctrl+C to exit)..."
        docker compose logs -f os-instance
        ;;
    4)
        echo "Viewing Health API logs (Ctrl+C to exit)..."
        docker logs redeemer-os --follow | grep health_api
        ;;
    *)
        echo "Invalid choice. Showing all logs..."
        docker compose logs -f
        ;;
esac
