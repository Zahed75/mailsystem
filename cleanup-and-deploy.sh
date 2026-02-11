#!/bin/bash

# Complete Cleanup and SOGo Deployment

echo "🧹 Cleaning up old containers..."
echo ""

# Stop and remove ALL containers
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true

# Remove all images
docker rmi -f $(docker images -aq) 2>/dev/null || true

# Clean up networks and volumes
docker network prune -f
docker volume prune -f

echo "✅ Cleanup complete!"
echo ""

# Pull latest code
echo "📥 Pulling latest code..."
git pull

# Start SOGo
echo "🚀 Starting SOGo..."
docker-compose up -d

echo ""
echo "⏳ Waiting for SOGo to start..."
sleep 20

if docker ps | grep -q sogo_webmail; then
    echo "✅ SOGo is running!"
    echo ""
    echo "Access: https://mailadmin.syscomatic.com"
    echo "Login: asif@syscomatic.com / Asif@2026#"
else
    echo "❌ Failed to start"
    docker-compose logs
fi
