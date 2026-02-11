#!/bin/bash

# Complete Snappymail Reset and Configuration Script

echo "╔════════════════════════════════════════════════════════╗"
echo "║   Snappymail Complete Reset & Auto-Configuration      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Stop container
echo -e "${YELLOW}Step 1: Stopping Snappymail...${NC}"
docker-compose down
sleep 2

# Step 2: Completely remove data directory and start fresh
echo -e "${YELLOW}Step 2: Removing old data...${NC}"
read -p "This will delete all Snappymail data. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

rm -rf ./data
mkdir -p ./data
chmod 755 ./data

# Step 3: Start container fresh
echo -e "${YELLOW}Step 3: Starting fresh Snappymail...${NC}"
docker-compose up -d
sleep 10

# Step 4: Wait for container to be ready
echo -e "${YELLOW}Step 4: Waiting for Snappymail to initialize...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:8888 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Snappymail is ready!${NC}"
        break
    fi
    echo -n "."
    sleep 1
done
echo ""

# Step 5: Create domain configuration directly
echo -e "${YELLOW}Step 5: Creating domain configuration...${NC}"

# Create domain config directory
docker exec snappymail_webmail mkdir -p /var/lib/snappymail/_data_/_default_/domains

# Create domain configuration file
cat > /tmp/syscomatic.com.ini << 'EOF'
imap_host = "156.67.216.209"
imap_port = 993
imap_secure = "SSL"
imap_short_login = Off
smtp_host = "156.67.216.209"
smtp_port = 587
smtp_secure = "TLS"
smtp_auth = On
smtp_use_auth = On
white_list = ""
EOF

# Copy config into container
docker cp /tmp/syscomatic.com.ini snappymail_webmail:/var/lib/snappymail/_data_/_default_/domains/syscomatic.com.ini
rm /tmp/syscomatic.com.ini

echo -e "${GREEN}✓ Domain configuration created${NC}"

# Step 6: Set permissions
echo -e "${YELLOW}Step 6: Setting permissions...${NC}"
docker exec snappymail_webmail chown -R www-data:www-data /var/lib/snappymail/_data_
docker exec snappymail_webmail chmod -R 755 /var/lib/snappymail/_data_

# Step 7: Restart container
echo -e "${YELLOW}Step 7: Restarting Snappymail...${NC}"
docker-compose restart
sleep 5

# Step 8: Test
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Setup Complete!                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Admin Panel Access:${NC}"
echo "  URL: https://mailadmin.syscomatic.com/?admin"
echo "  Password: 12345"
echo ""
echo -e "${GREEN}User Login (Try Now):${NC}"
echo "  URL: https://mailadmin.syscomatic.com"
echo "  Email: asif@syscomatic.com"
echo "  Password: Asif@2026#"
echo ""
echo -e "${YELLOW}Domain 'syscomatic.com' has been pre-configured with:${NC}"
echo "  IMAP: 156.67.216.209:993 (SSL)"
echo "  SMTP: 156.67.216.209:587 (STARTTLS)"
echo ""
echo -e "${GREEN}Try logging in now!${NC}"
echo ""
