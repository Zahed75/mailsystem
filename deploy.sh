#!/bin/bash

# Roundcube Webmail Setup Script
# Works with aaPanel Mail Server

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║        Roundcube Webmail Setup                         ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Install Docker if needed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    echo -e "${GREEN}✓ Docker installed${NC}"
fi

# Install Docker Compose if needed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
fi

# Stop any existing containers
echo -e "${YELLOW}Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true

# Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p ./roundcube-data
mkdir -p ./roundcube-db
chmod -R 755 ./roundcube-data ./roundcube-db

# Pull image
echo -e "${YELLOW}Pulling Roundcube image...${NC}"
docker-compose pull

# Start Roundcube
echo -e "${YELLOW}Starting Roundcube...${NC}"
docker-compose up -d

# Wait for container to start
echo -e "${YELLOW}Waiting for Roundcube to initialize...${NC}"
sleep 15

# Check if running
if docker ps | grep -q roundcube_webmail; then
    echo -e "${GREEN}✓ Roundcube is running!${NC}"
else
    echo -e "${RED}✗ Failed to start Roundcube${NC}"
    docker-compose logs
    exit 1
fi

# Test accessibility
echo -e "${YELLOW}Testing accessibility...${NC}"
sleep 5

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo -e "${GREEN}✓ Roundcube is accessible!${NC}"
else
    echo -e "${YELLOW}⚠ Roundcube may still be initializing...${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Setup Complete!                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Roundcube is configured and running${NC}"
echo -e "${GREEN}✓ Pre-configured for your mail server${NC}"
echo -e "${GREEN}✓ IMAP: 156.67.216.209:993 (SSL)${NC}"
echo -e "${GREEN}✓ SMTP: 156.67.216.209:587 (TLS)${NC}"
echo ""
echo -e "${YELLOW}Access your webmail:${NC}"
echo "  URL: https://mailadmin.syscomatic.com"
echo ""
echo -e "${YELLOW}Login with your email accounts:${NC}"
echo "  Email: asif@syscomatic.com"
echo "  Password: Asif@2026#"
echo ""
echo "  Email: rakib@syscomatic.com"
echo "  Password: Rakib@2026#"
echo ""
echo "  Email: consult@syscomatic.com"
echo "  Password: C@nsult@2026#"
echo ""
echo "  Email: zahed@syscomatic.com"
echo "  Password: Z@hed@2026#"
echo ""
echo -e "${YELLOW}Configure aaPanel reverse proxy:${NC}"
echo "  1. Login to aaPanel"
echo "  2. Add site: mailadmin.syscomatic.com"
echo "  3. Set reverse proxy to: http://127.0.0.1:8080"
echo "  4. Add SSL certificate"
echo ""
echo -e "${GREEN}🎉 Roundcube is ready to use!${NC}"
echo ""
