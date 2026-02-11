#!/bin/bash

# Snappymail Health Check & Monitoring Script
# Run this script to check the health of your Snappymail installation

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🏥 Snappymail Health Check${NC}"
echo "=============================="
echo ""

# Function to check status
check_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
        return 0
    else
        echo -e "${RED}❌ $2${NC}"
        return 1
    fi
}

ERRORS=0

# 1. Check if Docker is running
echo "1. Checking Docker..."
if systemctl is-active --quiet docker; then
    check_status 0 "Docker is running"
else
    check_status 1 "Docker is not running"
    ((ERRORS++))
fi

# 2. Check if Docker Compose is installed
echo ""
echo "2. Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    VERSION=$(docker-compose --version)
    check_status 0 "Docker Compose installed: $VERSION"
else
    check_status 1 "Docker Compose not installed"
    ((ERRORS++))
fi

# 3. Check if Snappymail container is running
echo ""
echo "3. Checking Snappymail container..."
if docker ps | grep -q snappymail; then
    CONTAINER_STATUS=$(docker ps --filter "name=snappymail" --format "{{.Status}}")
    check_status 0 "Container running: $CONTAINER_STATUS"
else
    check_status 1 "Container not running"
    ((ERRORS++))
fi

# 4. Check container health
echo ""
echo "4. Checking container health..."
if docker ps | grep -q snappymail; then
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' snappymail_webmail 2>/dev/null || echo "no healthcheck")
    if [ "$HEALTH" = "healthy" ] || [ "$HEALTH" = "no healthcheck" ]; then
        check_status 0 "Container health: $HEALTH"
    else
        check_status 1 "Container health: $HEALTH"
        ((ERRORS++))
    fi
fi

# 5. Check if port 8888 is listening
echo ""
echo "5. Checking port 8888..."
if netstat -tuln 2>/dev/null | grep -q ":8888" || ss -tuln 2>/dev/null | grep -q ":8888"; then
    check_status 0 "Port 8888 is listening"
else
    check_status 1 "Port 8888 is not listening"
    ((ERRORS++))
fi

# 6. Check HTTP response
echo ""
echo "6. Checking HTTP response..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 | grep -q "200\|302"; then
    check_status 0 "HTTP response OK"
else
    check_status 1 "HTTP response failed"
    ((ERRORS++))
fi

# 7. Check Nginx (if installed)
echo ""
echo "7. Checking Nginx..."
if command -v nginx &> /dev/null; then
    if systemctl is-active --quiet nginx; then
        check_status 0 "Nginx is running"
    else
        check_status 1 "Nginx is not running"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}⚠️  Nginx not installed (optional)${NC}"
fi

# 8. Check SSL certificate (if Nginx is configured)
echo ""
echo "8. Checking SSL certificate..."
if [ -f /etc/letsencrypt/live/mailadmin.syscomatic.com/fullchain.pem ]; then
    EXPIRY=$(openssl x509 -enddate -noout -in /etc/letsencrypt/live/mailadmin.syscomatic.com/fullchain.pem | cut -d= -f2)
    check_status 0 "SSL certificate found, expires: $EXPIRY"
else
    echo -e "${YELLOW}⚠️  SSL certificate not found (run certbot if needed)${NC}"
fi

# 9. Check disk space
echo ""
echo "9. Checking disk space..."
DISK_USAGE=$(df -h /opt/mailsystem 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//')
if [ -n "$DISK_USAGE" ] && [ "$DISK_USAGE" -lt 90 ]; then
    check_status 0 "Disk usage: ${DISK_USAGE}%"
else
    check_status 1 "Disk usage: ${DISK_USAGE}% (Warning: >90%)"
    ((ERRORS++))
fi

# 10. Check data directory
echo ""
echo "10. Checking data directory..."
if [ -d "./data" ]; then
    DATA_SIZE=$(du -sh ./data 2>/dev/null | cut -f1)
    check_status 0 "Data directory exists: $DATA_SIZE"
else
    check_status 1 "Data directory not found"
    ((ERRORS++))
fi

# 11. Check recent logs for errors
echo ""
echo "11. Checking recent logs..."
if docker ps | grep -q snappymail; then
    ERROR_COUNT=$(docker logs snappymail_webmail --since 1h 2>&1 | grep -i "error\|fatal\|critical" | wc -l)
    if [ "$ERROR_COUNT" -eq 0 ]; then
        check_status 0 "No errors in recent logs"
    else
        check_status 1 "Found $ERROR_COUNT errors in recent logs"
        echo -e "${YELLOW}   Run 'docker logs snappymail_webmail' to view${NC}"
        ((ERRORS++))
    fi
fi

# 12. Check SMTP connectivity
echo ""
echo "12. Checking SMTP connectivity..."
if timeout 5 bash -c "cat < /dev/null > /dev/tcp/smtp.syscomatic.com/587" 2>/dev/null; then
    check_status 0 "SMTP server reachable (smtp.syscomatic.com:587)"
else
    check_status 1 "Cannot reach SMTP server"
    ((ERRORS++))
fi

# 13. Check IMAP connectivity
echo ""
echo "13. Checking IMAP connectivity..."
if timeout 5 bash -c "cat < /dev/null > /dev/tcp/imap.syscomatic.com/993" 2>/dev/null; then
    check_status 0 "IMAP server reachable (imap.syscomatic.com:993)"
else
    check_status 1 "Cannot reach IMAP server"
    ((ERRORS++))
fi

# 14. Check DNS resolution
echo ""
echo "14. Checking DNS resolution..."
if dig +short mailadmin.syscomatic.com | grep -q "156.67.216.209"; then
    check_status 0 "DNS resolution correct"
else
    check_status 1 "DNS resolution issue"
    ((ERRORS++))
fi

# Summary
echo ""
echo "=============================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo -e "${GREEN}System is healthy${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $ERRORS issue(s)${NC}"
    echo -e "${YELLOW}Please review the errors above${NC}"
    echo ""
    echo "Common fixes:"
    echo "  - Container not running: docker-compose up -d"
    echo "  - Port issues: sudo ufw allow 8888/tcp"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Restart: docker-compose restart"
    exit 1
fi
