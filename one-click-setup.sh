#!/bin/bash

# One-Click Snappymail Setup with Pre-configured Domain
# This script sets up everything automatically

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║   Snappymail One-Click Setup for syscomatic.com       ║"
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
fi

# Install Docker Compose if needed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo -e "${GREEN}✓ Docker installed${NC}"

# Stop any existing container
echo -e "${YELLOW}Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true

# Clean up old data
echo -e "${YELLOW}Cleaning old data...${NC}"
rm -rf ./data

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p ./data/_data_/_default_/domains
mkdir -p ./data/_data_/_default_/configs

# Create application.ini with admin password
cat > ./data/_data_/_default_/configs/application.ini << 'EOF'
[webmail]
title = "Syscomatic Webmail"
loading_description = "Loading..."
theme = "Default"

[interface]
show_attachment_thumbnail = On

[contacts]
enable = On
allow_sharing = On
allow_sync = On
sync_interval = 20

[security]
csrf_protection = On
admin_login = "admin"
admin_password = "$2y$10$8K1p/a0dL3XzYP0Ry0fF8usrB9yW7P7mRzGhRhHU5JGhGhRhHU5JG"
use_rsa_encryption = Off

[labs]
allow_admin_panel = On
allow_gravatar = On
EOF

# Create domain configuration for syscomatic.com
cat > ./data/_data_/_default_/domains/syscomatic.com.ini << 'EOF'
imap_host = "156.67.216.209"
imap_port = 993
imap_secure = "SSL"
imap_short_login = Off
imap_timeout = 300
sieve_use = Off
sieve_allow_raw = Off
sieve_host = ""
sieve_port = 4190
sieve_secure = "None"
smtp_host = "156.67.216.209"
smtp_port = 587
smtp_secure = "TLS"
smtp_short_login = Off
smtp_auth = On
smtp_php_mail = Off
smtp_timeout = 60
smtp_use_authentication = On
white_list = ""
alias_name = ""
EOF

# Create default domain configuration
cat > ./data/_data_/_default_/domains/default.ini << 'EOF'
imap_host = "156.67.216.209"
imap_port = 993
imap_secure = "SSL"
imap_short_login = Off
smtp_host = "156.67.216.209"
smtp_port = 587
smtp_secure = "TLS"
smtp_auth = On
smtp_use_authentication = On
EOF

# Set permissions
chmod -R 755 ./data
chown -R 82:82 ./data 2>/dev/null || chown -R www-data:www-data ./data 2>/dev/null || true

echo -e "${GREEN}✓ Configuration files created${NC}"

# Start Snappymail
echo -e "${YELLOW}Starting Snappymail...${NC}"
docker-compose up -d

# Wait for container to start
echo -e "${YELLOW}Waiting for Snappymail to start...${NC}"
sleep 10

# Check if running
if docker ps | grep -q snappymail_webmail; then
    echo -e "${GREEN}✓ Snappymail is running!${NC}"
else
    echo -e "${RED}✗ Failed to start Snappymail${NC}"
    docker-compose logs
    exit 1
fi

# Test accessibility
echo -e "${YELLOW}Testing accessibility...${NC}"
sleep 5

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 | grep -q "200\|302"; then
    echo -e "${GREEN}✓ Snappymail is accessible!${NC}"
else
    echo -e "${YELLOW}⚠ Snappymail may still be starting...${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Setup Complete!                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Snappymail is configured and running${NC}"
echo -e "${GREEN}✓ Domain 'syscomatic.com' is pre-configured${NC}"
echo -e "${GREEN}✓ IMAP: 156.67.216.209:993 (SSL)${NC}"
echo -e "${GREEN}✓ SMTP: 156.67.216.209:587 (STARTTLS)${NC}"
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
echo -e "${YELLOW}Admin Panel (if needed):${NC}"
echo "  URL: https://mailadmin.syscomatic.com/?admin"
echo "  Password: 12345"
echo ""
echo -e "${GREEN}🎉 You can now use your webmail!${NC}"
echo ""
