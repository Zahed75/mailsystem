#!/bin/bash

# aaPanel Mail Server Diagnostic Script
# Checks mail server configuration and ports

echo "╔════════════════════════════════════════════════════════╗"
echo "║     aaPanel Mail Server Diagnostic Tool               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Note: Some checks require root. Run with sudo for full diagnostic.${NC}"
    echo ""
fi

# 1. Check IMAP Ports
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. IMAP Port Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

IMAP_143=$(sudo netstat -tuln 2>/dev/null | grep ':143 ' || echo "")
IMAP_993=$(sudo netstat -tuln 2>/dev/null | grep ':993 ' || echo "")

if [ -n "$IMAP_143" ]; then
    echo -e "${GREEN}✓ IMAP port 143 (non-SSL) is OPEN${NC}"
    echo "  Use in Snappymail: Port 143, Secure: None"
else
    echo -e "${RED}✗ IMAP port 143 is CLOSED${NC}"
fi

if [ -n "$IMAP_993" ]; then
    echo -e "${GREEN}✓ IMAP port 993 (SSL) is OPEN${NC}"
    echo "  Use in Snappymail: Port 993, Secure: SSL/TLS"
else
    echo -e "${RED}✗ IMAP port 993 is CLOSED${NC}"
fi

echo ""

# 2. Check SMTP Ports
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. SMTP Port Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

SMTP_25=$(sudo netstat -tuln 2>/dev/null | grep ':25 ' || echo "")
SMTP_587=$(sudo netstat -tuln 2>/dev/null | grep ':587 ' || echo "")
SMTP_465=$(sudo netstat -tuln 2>/dev/null | grep ':465 ' || echo "")

if [ -n "$SMTP_25" ]; then
    echo -e "${GREEN}✓ SMTP port 25 is OPEN${NC}"
    echo "  Use in Snappymail: Port 25, Secure: None"
else
    echo -e "${RED}✗ SMTP port 25 is CLOSED${NC}"
fi

if [ -n "$SMTP_587" ]; then
    echo -e "${GREEN}✓ SMTP port 587 (submission) is OPEN${NC}"
    echo "  Use in Snappymail: Port 587, Secure: STARTTLS"
else
    echo -e "${RED}✗ SMTP port 587 is CLOSED${NC}"
fi

if [ -n "$SMTP_465" ]; then
    echo -e "${GREEN}✓ SMTP port 465 (SSL) is OPEN${NC}"
    echo "  Use in Snappymail: Port 465, Secure: SSL/TLS"
else
    echo -e "${RED}✗ SMTP port 465 is CLOSED${NC}"
fi

echo ""

# 3. Check Mail Services
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Mail Service Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Dovecot
if systemctl is-active --quiet dovecot 2>/dev/null; then
    echo -e "${GREEN}✓ Dovecot (IMAP) is RUNNING${NC}"
elif pgrep dovecot > /dev/null; then
    echo -e "${GREEN}✓ Dovecot (IMAP) is RUNNING${NC}"
else
    echo -e "${RED}✗ Dovecot (IMAP) is NOT RUNNING${NC}"
    echo "  Start with: sudo systemctl start dovecot"
fi

# Check Postfix
if systemctl is-active --quiet postfix 2>/dev/null; then
    echo -e "${GREEN}✓ Postfix (SMTP) is RUNNING${NC}"
elif pgrep postfix > /dev/null; then
    echo -e "${GREEN}✓ Postfix (SMTP) is RUNNING${NC}"
else
    echo -e "${RED}✗ Postfix (SMTP) is NOT RUNNING${NC}"
    echo "  Start with: sudo systemctl start postfix"
fi

echo ""

# 4. Test Connections
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Connection Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test IMAP 993
if timeout 2 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/993" 2>/dev/null; then
    echo -e "${GREEN}✓ Can connect to IMAP SSL (993)${NC}"
else
    echo -e "${RED}✗ Cannot connect to IMAP SSL (993)${NC}"
fi

# Test IMAP 143
if timeout 2 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/143" 2>/dev/null; then
    echo -e "${GREEN}✓ Can connect to IMAP (143)${NC}"
else
    echo -e "${RED}✗ Cannot connect to IMAP (143)${NC}"
fi

# Test SMTP 587
if timeout 2 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/587" 2>/dev/null; then
    echo -e "${GREEN}✓ Can connect to SMTP (587)${NC}"
else
    echo -e "${RED}✗ Cannot connect to SMTP (587)${NC}"
fi

# Test SMTP 25
if timeout 2 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/25" 2>/dev/null; then
    echo -e "${GREEN}✓ Can connect to SMTP (25)${NC}"
else
    echo -e "${RED}✗ Cannot connect to SMTP (25)${NC}"
fi

echo ""

# 5. Check Firewall
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Firewall Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v ufw &> /dev/null; then
    if sudo ufw status 2>/dev/null | grep -q "Status: active"; then
        echo -e "${YELLOW}UFW Firewall is ACTIVE${NC}"
        echo ""
        echo "Mail ports status:"
        sudo ufw status | grep -E '(143|993|25|587|465)' || echo "  No mail port rules found"
    else
        echo -e "${GREEN}UFW Firewall is INACTIVE${NC}"
    fi
else
    echo "UFW not installed"
fi

echo ""

# 6. Server IP
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Server Information"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Server IP: $SERVER_IP"
echo "Hostname: $(hostname)"

echo ""

# 7. Recommended Snappymail Configuration
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7. Recommended Snappymail Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "Based on the diagnostic above, use this configuration:"
echo ""

# Determine best IMAP config
if [ -n "$IMAP_993" ]; then
    echo -e "${GREEN}IMAP Settings:${NC}"
    echo "  Server:  $SERVER_IP"
    echo "  Port:    993"
    echo "  Secure:  SSL/TLS"
elif [ -n "$IMAP_143" ]; then
    echo -e "${YELLOW}IMAP Settings:${NC}"
    echo "  Server:  $SERVER_IP"
    echo "  Port:    143"
    echo "  Secure:  None"
    echo "  ${YELLOW}⚠ Warning: Unencrypted connection${NC}"
else
    echo -e "${RED}IMAP: No ports available!${NC}"
    echo "  Check if Dovecot is running"
fi

echo ""

# Determine best SMTP config
if [ -n "$SMTP_587" ]; then
    echo -e "${GREEN}SMTP Settings:${NC}"
    echo "  Server:  $SERVER_IP"
    echo "  Port:    587"
    echo "  Secure:  STARTTLS"
    echo "  ☑ Use authentication"
    echo "  ☑ Use IMAP credentials"
elif [ -n "$SMTP_465" ]; then
    echo -e "${GREEN}SMTP Settings:${NC}"
    echo "  Server:  $SERVER_IP"
    echo "  Port:    465"
    echo "  Secure:  SSL/TLS"
    echo "  ☑ Use authentication"
    echo "  ☑ Use IMAP credentials"
elif [ -n "$SMTP_25" ]; then
    echo -e "${YELLOW}SMTP Settings:${NC}"
    echo "  Server:  $SERVER_IP"
    echo "  Port:    25"
    echo "  Secure:  None"
    echo "  ☑ Use authentication"
    echo "  ☑ Use IMAP credentials"
    echo "  ${YELLOW}⚠ Warning: Unencrypted connection${NC}"
else
    echo -e "${RED}SMTP: No ports available!${NC}"
    echo "  Check if Postfix is running"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo "1. Go to: https://mailadmin.syscomatic.com/?admin"
echo "2. Login with password: 12345"
echo "3. Add domain: syscomatic.com"
echo "4. Use the configuration shown above"
echo "5. Click Test, then Save"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
