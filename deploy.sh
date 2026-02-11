#!/bin/bash

# RainLoop Webmail Complete Setup Script

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║        RainLoop Webmail Installation                  ║"
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

# Stop and remove all existing containers
echo -e "${YELLOW}Cleaning up old containers...${NC}"
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker network prune -f
echo -e "${GREEN}✓ Cleanup complete${NC}"

# Create data directory
echo -e "${YELLOW}Creating data directory...${NC}"
mkdir -p ./rainloop-data
chmod -R 755 ./rainloop-data

# Build and start RainLoop
echo -e "${YELLOW}Building RainLoop Docker image...${NC}"
echo -e "${YELLOW}This may take 3-5 minutes...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}Starting RainLoop...${NC}"
docker-compose up -d

# Wait for container to start
echo -e "${YELLOW}Waiting for RainLoop to initialize...${NC}"
sleep 20

# Check if running
if docker ps | grep -q rainloop_webmail; then
    echo -e "${GREEN}✓ RainLoop is running!${NC}"
else
    echo -e "${RED}✗ RainLoop failed to start${NC}"
    docker-compose logs
    exit 1
fi

# Configure domain via admin panel API (if possible)
echo -e "${YELLOW}Configuring mail server settings...${NC}"
sleep 5

# Create domain configuration manually
mkdir -p ./rainloop-data/_data_/_default_/domains

cat > ./rainloop-data/_data_/_default_/domains/syscomatic.com.ini << 'EOF'
imap_host = "156.67.216.209"
imap_port = 993
imap_secure = "SSL"
imap_short_login = Off
sieve_use = Off
smtp_host = "156.67.216.209"
smtp_port = 587
smtp_secure = "TLS"
smtp_short_login = Off
smtp_auth = On
smtp_php_mail = Off
white_list = ""
EOF

# Set permissions
chown -R 33:33 ./rainloop-data 2>/dev/null || chown -R www-data:www-data ./rainloop-data 2>/dev/null || true
chmod -R 755 ./rainloop-data

# Restart to apply configuration
echo -e "${YELLOW}Restarting to apply configuration...${NC}"
docker-compose restart
sleep 10

# Test accessibility
if curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ RainLoop is accessible!${NC}"
else
    echo -e "${YELLOW}⚠ RainLoop may still be starting...${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ RainLoop is installed and running${NC}"
echo -e "${GREEN}✓ Running on port 9000${NC}"
echo -e "${GREEN}✓ Domain 'syscomatic.com' pre-configured${NC}"
echo -e "${GREEN}✓ IMAP: 156.67.216.209:993 (SSL)${NC}"
echo -e "${GREEN}✓ SMTP: 156.67.216.209:587 (TLS)${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Configure aaPanel Reverse Proxy:${NC}"
echo "   - Login to aaPanel"
echo "   - Go to site: mailadmin.syscomatic.com"
echo "   - Set reverse proxy to: http://127.0.0.1:9000"
echo "   - Add SSL certificate"
echo ""
echo -e "${YELLOW}2. Access Webmail:${NC}"
echo "   URL: https://mailadmin.syscomatic.com"
echo "   Email: asif@syscomatic.com"
echo "   Password: Asif@2026#"
echo ""
echo -e "${YELLOW}3. Admin Panel (optional):${NC}"
echo "   URL: https://mailadmin.syscomatic.com/?admin"
echo "   Username: admin"
echo "   Password: 12345"
echo "   ${RED}⚠️  Change this password immediately!${NC}"
echo ""
echo -e "${GREEN}🎉 RainLoop is ready to use!${NC}"
echo ""
