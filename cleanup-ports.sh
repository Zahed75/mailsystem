#!/bin/bash

# Find and stop all containers using ports 8080 and 8888

echo "🔍 Finding what's using ports 8080 and 8888..."
echo ""

# Check port 8080
echo "Port 8080:"
sudo lsof -i :8080 || echo "  Nothing found"
echo ""

# Check port 8888
echo "Port 8888:"
sudo lsof -i :8888 || echo "  Nothing found"
echo ""

# Show all Docker containers
echo "All Docker containers:"
docker ps -a
echo ""

# Stop ALL containers
echo "Stopping ALL Docker containers..."
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"
echo ""

# Remove ALL containers
echo "Removing ALL Docker containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"
echo ""

# Remove orphan Snappymail container specifically
echo "Removing orphan containers..."
docker-compose down --remove-orphans 2>/dev/null || true
echo ""

# Clean up networks
echo "Cleaning up networks..."
docker network prune -f
echo ""

echo "✅ All containers stopped and removed!"
echo ""
echo "Now run: docker-compose up -d"
