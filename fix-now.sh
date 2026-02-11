#!/bin/bash

# Fix Snappymail Configuration on Running Container
# Run this AFTER docker-compose up -d

echo "🔧 Fixing Snappymail Configuration..."
echo "====================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if container is running
if ! docker ps | grep -q snappymail_webmail; then
    echo -e "${RED}❌ Snappymail container is not running!${NC}"
    echo "Start it with: docker-compose up -d"
    exit 1
fi

echo -e "${GREEN}✓ Container is running${NC}"

# Create domain configuration
echo -e "${YELLOW}Creating domain configuration...${NC}"

# Create config directory inside container
docker exec snappymail_webmail mkdir -p /var/lib/snappymail/_data_/_default_/domains 2>/dev/null || true

# Create domain config file
cat > /tmp/syscomatic.com.ini << 'EOF'
imap_host = "156.67.216.209"
imap_port = 993
imap_secure = "SSL"
imap_short_login = Off
smtp_host = "156.67.216.209"
smtp_port = 587
smtp_secure = "TLS"
smtp_auth = On
smtp_use_authentication = On
white_list = ""
EOF

# Copy into container
docker cp /tmp/syscomatic.com.ini snappymail_webmail:/var/lib/snappymail/_data_/_default_/domains/syscomatic.com.ini

# Also create as default
docker cp /tmp/syscomatic.com.ini snappymail_webmail:/var/lib/snappymail/_data_/_default_/domains/default.ini

# Clean up
rm /tmp/syscomatic.com.ini

# Set permissions
docker exec snappymail_webmail chown -R www-data:www-data /var/lib/snappymail/_data_ 2>/dev/null || \
docker exec snappymail_webmail chown -R 82:82 /var/lib/snappymail/_data_ 2>/dev/null || true

docker exec snappymail_webmail chmod -R 755 /var/lib/snappymail/_data_ 2>/dev/null || true

echo -e "${GREEN}✓ Configuration created${NC}"

# Restart container to apply changes
echo -e "${YELLOW}Restarting container...${NC}"
docker-compose restart

echo -e "${YELLOW}Waiting for restart...${NC}"
sleep 10

# Verify
if docker ps | grep -q snappymail_webmail; then
    echo -e "${GREEN}✓ Container restarted successfully${NC}"
else
    echo -e "${RED}❌ Container failed to restart${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Configuration Fixed!                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Domain configured:${NC} syscomatic.com"
echo -e "${GREEN}IMAP:${NC} 156.67.216.209:993 (SSL)"
echo -e "${GREEN}SMTP:${NC} 156.67.216.209:587 (STARTTLS)"
echo ""
echo -e "${YELLOW}Try logging in now:${NC}"
echo "  URL: https://mailadmin.syscomatic.com"
echo "  Email: asif@syscomatic.com"
echo "  Password: Asif@2026#"
echo ""
echo -e "${GREEN}The 'localhost:143' error should be gone!${NC}"
echo ""
