#!/bin/bash

# Fix RainLoop Data Folder Permissions

echo "🔧 Fixing RainLoop Permissions..."
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Stop container
echo -e "${YELLOW}Stopping container...${NC}"
docker-compose down

# Fix permissions on host
echo -e "${YELLOW}Setting permissions...${NC}"
mkdir -p ./rainloop-data
chmod -R 777 ./rainloop-data
chown -R 33:33 ./rainloop-data 2>/dev/null || chown -R www-data:www-data ./rainloop-data 2>/dev/null || true

# Start container
echo -e "${YELLOW}Starting container...${NC}"
docker-compose up -d

# Wait for startup
sleep 10

# Fix permissions inside container
echo -e "${YELLOW}Fixing permissions inside container...${NC}"
docker exec rainloop_webmail chown -R www-data:www-data /var/www/html/data
docker exec rainloop_webmail chmod -R 777 /var/www/html/data

echo ""
echo -e "${GREEN}✅ Permissions fixed!${NC}"
echo ""
echo -e "${GREEN}Access webmail now:${NC}"
echo "  https://mailadmin.syscomatic.com"
echo ""
