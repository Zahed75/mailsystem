#!/bin/bash

# SMTP Connection Test Script
# Tests SMTP authentication and connection

echo "🔍 SMTP Connection Test"
echo "======================="

# Configuration
SMTP_HOST="smtp.syscomatic.com"
SMTP_PORT="587"
EMAIL=""
PASSWORD=""

# Get credentials if not set
if [ -z "$EMAIL" ]; then
    read -p "Enter your email address: " EMAIL
fi

if [ -z "$PASSWORD" ]; then
    read -sp "Enter your password: " PASSWORD
    echo
fi

echo ""
echo "Testing SMTP connection to $SMTP_HOST:$SMTP_PORT..."
echo ""

# Test 1: Check if port is open
echo "Test 1: Checking if SMTP port is accessible..."
if timeout 5 bash -c "cat < /dev/null > /dev/tcp/$SMTP_HOST/$SMTP_PORT" 2>/dev/null; then
    echo "✓ Port $SMTP_PORT is open"
else
    echo "✗ Cannot connect to port $SMTP_PORT"
    exit 1
fi

echo ""
echo "Test 2: Testing STARTTLS connection..."
echo ""

# Test 2: Test STARTTLS
{
    echo "EHLO test"
    sleep 1
    echo "STARTTLS"
    sleep 1
    echo "QUIT"
} | openssl s_client -starttls smtp -connect $SMTP_HOST:$SMTP_PORT -quiet 2>&1 | head -20

echo ""
echo "Test 3: Testing authentication..."
echo ""

# Create auth string (base64 encoded)
AUTH_PLAIN=$(printf "\0%s\0%s" "$EMAIL" "$PASSWORD" | base64)

# Test authentication
{
    echo "EHLO test"
    sleep 1
    echo "STARTTLS"
    sleep 2
    echo "EHLO test"
    sleep 1
    echo "AUTH PLAIN $AUTH_PLAIN"
    sleep 2
    echo "QUIT"
} | openssl s_client -starttls smtp -connect $SMTP_HOST:$SMTP_PORT -quiet 2>&1 | grep -i "authentication\|accepted\|failed\|235"

echo ""
echo "Test 4: Checking DNS records..."
echo ""

# Check MX record
echo "MX Record:"
dig +short MX syscomatic.com

echo ""
echo "SPF Record:"
dig +short TXT syscomatic.com | grep spf

echo ""
echo "DKIM Record:"
dig +short TXT default._domainkey.syscomatic.com

echo ""
echo "DMARC Record:"
dig +short TXT _dmarc.syscomatic.com

echo ""
echo "======================="
echo "Test completed!"
