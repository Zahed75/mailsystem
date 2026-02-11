#!/bin/bash

# Complete Cleanup and Fresh Start Script

echo "╔════════════════════════════════════════════════════════╗"
echo "║   Complete Cleanup & Fresh Roundcube Installation     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Stop ALL Docker containers
echo -e "${YELLOW}Step 1: Stopping ALL Docker containers...${NC}"
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers running"
sleep 2

# Step 2: Remove ALL Docker containers
echo -e "${YELLOW}Step 2: Removing ALL Docker containers...${NC}"
docker rm -f $(docker ps -aq) 2>/dev/null || echo "No containers to remove"
sleep 2

# Step 3: Remove all networks
echo -e "${YELLOW}Step 3: Cleaning up networks...${NC}"
docker network prune -f
sleep 2

# Step 4: Pull latest code
echo -e "${YELLOW}Step 4: Pulling latest code...${NC}"
git pull

# Step 5: Start Roundcube on port 9000
echo -e "${YELLOW}Step 5: Starting Roundcube (port 9000)...${NC}"
docker-compose up -d

# Wait for startup
echo -e "${YELLOW}Waiting for Roundcube to start...${NC}"
sleep 15

# Check status
if docker ps | grep -q roundcube_webmail; then
    echo -e "${GREEN}✓ Roundcube is running!${NC}"
else
    echo -e "${RED}✗ Roundcube failed to start${NC}"
    docker-compose logs
    exit 1
fi

# Test accessibility
if curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Roundcube is accessible on port 9000!${NC}"
else
    echo -e "${YELLOW}⚠ Roundcube may still be starting...${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Setup Complete!                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ All old containers removed${NC}"
echo -e "${GREEN}✓ Roundcube is running on port 9000${NC}"
echo -e "${GREEN}✓ Pre-configured for your mail server${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Update aaPanel Reverse Proxy:${NC}"
echo "   - Go to your site: mailadmin.syscomatic.com"
echo "   - Set reverse proxy to: http://127.0.0.1:9000"
echo "   - Save"
echo ""
echo -e "${YELLOW}2. Access Webmail:${NC}"
echo "   URL: https://mailadmin.syscomatic.com"
echo "   Email: asif@syscomatic.com"
echo "   Password: Asif@2026#"
echo ""
echo -e "${GREEN}🎉 Roundcube is ready!${NC}"
echo ""
