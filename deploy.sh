#!/bin/bash

# SOGo Webmail - Enterprise-Grade Setup
# Mozilla Thunderbird's recommended web solution

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║          SOGo Webmail - Enterprise Setup               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Install Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Clean up
echo -e "${YELLOW}Cleaning up old containers...${NC}"
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker network prune -f

# Start SOGo
echo -e "${YELLOW}Starting SOGo...${NC}"
docker-compose up -d

echo -e "${YELLOW}Waiting for SOGo to start...${NC}"
sleep 15

if docker ps | grep -q sogo_webmail; then
    echo -e "${GREEN}✓ SOGo is running!${NC}"
else
    echo -e "${RED}✗ Failed to start${NC}"
    docker-compose logs
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ SOGo is running on port 9000${NC}"
echo -e "${GREEN}✓ Pre-configured for your mail server${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Configure aaPanel:${NC}"
echo "   - Site: mailadmin.syscomatic.com"
echo "   - Proxy: http://127.0.0.1:9000"
echo "   - Add SSL"
echo ""
echo -e "${YELLOW}2. Login:${NC}"
echo "   URL: https://mailadmin.syscomatic.com"
echo "   Email: asif@syscomatic.com"
echo "   Password: Asif@2026#"
echo ""
echo -e "${GREEN}🎉 SOGo is ready!${NC}"
echo ""
