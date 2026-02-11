#!/bin/bash

# Afterlogic WebMail Lite - One-Click Setup
# The most reliable webmail solution

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║     Afterlogic WebMail Lite - Complete Setup          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Install Docker if needed
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

# Clean up everything
echo -e "${YELLOW}Cleaning up old containers...${NC}"
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker network prune -f

# Create data directory
mkdir -p ./data
chmod -R 777 ./data

# Build and start
echo -e "${YELLOW}Building Afterlogic WebMail...${NC}"
echo -e "${YELLOW}This will take 3-5 minutes...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}Starting webmail...${NC}"
docker-compose up -d

echo -e "${YELLOW}Waiting for initialization...${NC}"
sleep 20

if docker ps | grep -q afterlogic_webmail; then
    echo -e "${GREEN}✓ Webmail is running!${NC}"
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
echo -e "${GREEN}✓ Afterlogic WebMail is running on port 9000${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Configure aaPanel Reverse Proxy:${NC}"
echo "   - Site: mailadmin.syscomatic.com"
echo "   - Proxy to: http://127.0.0.1:9000"
echo "   - Add SSL certificate"
echo ""
echo -e "${YELLOW}2. Complete Setup Wizard:${NC}"
echo "   - Go to: https://mailadmin.syscomatic.com"
echo "   - Follow the setup wizard (takes 2 minutes)"
echo "   - Enter your mail server details:"
echo "     IMAP: 156.67.216.209:993 (SSL)"
echo "     SMTP: 156.67.216.209:587 (TLS)"
echo ""
echo -e "${YELLOW}3. Login with your email:${NC}"
echo "   Email: asif@syscomatic.com"
echo "   Password: Asif@2026#"
echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
