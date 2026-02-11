#!/bin/bash

# Snappymail Admin Password Reset Script

echo "🔐 Snappymail Admin Password Reset"
echo "==================================="
echo ""

# Check if Docker container is running
if ! docker ps | grep -q snappymail_webmail; then
    echo "❌ Snappymail container is not running!"
    echo "Start it with: docker-compose up -d"
    exit 1
fi

echo "Stopping Snappymail container..."
docker-compose down

echo ""
echo "Removing admin password file..."

# Remove admin password file
if [ -f "./data/_data_/_default_/admin_password.txt" ]; then
    rm -f ./data/_data_/_default_/admin_password.txt
    echo "✅ Admin password file removed"
else
    echo "⚠️  Admin password file not found (this is OK)"
fi

# Also check alternative locations
if [ -f "./data/_data_/admin_password.txt" ]; then
    rm -f ./data/_data_/admin_password.txt
    echo "✅ Alternative admin password file removed"
fi

echo ""
echo "Starting Snappymail container..."
docker-compose up -d

echo ""
echo "Waiting for container to start..."
sleep 5

echo ""
echo "✅ Admin password has been reset!"
echo ""
echo "You can now login with:"
echo "  URL: https://mailadmin.syscomatic.com/?admin"
echo "  Login: admin (or leave empty)"
echo "  Password: 12345"
echo ""
echo "⚠️  IMPORTANT: Change this password immediately after login!"
echo ""
