#!/bin/bash

# Snappymail Deployment Script for VPS
# Usage: ./deploy.sh

set -e

echo "🚀 Snappymail Deployment Script"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker not found. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    echo -e "${GREEN}Docker installed successfully${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose not found. Installing...${NC}"
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose installed successfully${NC}"
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    cp .env.example .env
    echo -e "${YELLOW}Please edit .env file with your settings${NC}"
    read -p "Press enter to continue after editing .env..."
fi

# Create data directory
echo -e "${YELLOW}Creating data directory...${NC}"
mkdir -p ./data
chmod 755 ./data

# Pull latest image
echo -e "${YELLOW}Pulling latest Snappymail image...${NC}"
docker-compose pull

# Start services
echo -e "${YELLOW}Starting Snappymail...${NC}"
docker-compose up -d

# Wait for service to be ready
echo -e "${YELLOW}Waiting for Snappymail to start...${NC}"
sleep 10

# Check if service is running
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Snappymail is running!${NC}"
    echo ""
    echo -e "${GREEN}Access your webmail at:${NC}"
    echo -e "  User interface: http://$(hostname -I | awk '{print $1}'):8888"
    echo -e "  Admin panel: http://$(hostname -I | awk '{print $1}'):8888/?admin"
    echo ""
    echo -e "${YELLOW}Default admin password: 12345${NC}"
    echo -e "${RED}⚠️  CHANGE THIS IMMEDIATELY!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Access admin panel and change password"
    echo "2. Configure your mail server settings (IMAP/SMTP)"
    echo "3. Set up Nginx reverse proxy with SSL"
    echo "4. Configure firewall rules"
else
    echo -e "${RED}✗ Failed to start Snappymail${NC}"
    echo "Check logs with: docker-compose logs"
    exit 1
fi

# Configure firewall (if ufw is installed)
if command -v ufw &> /dev/null; then
    echo ""
    read -p "Configure firewall rules? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ufw allow 8888/tcp comment 'Snappymail'
        ufw allow 587/tcp comment 'SMTP'
        ufw allow 993/tcp comment 'IMAPS'
        ufw allow 80/tcp comment 'HTTP'
        ufw allow 443/tcp comment 'HTTPS'
        echo -e "${GREEN}Firewall rules configured${NC}"
    fi
fi

# Check if aaPanel is installed
if [ -d "/www/server/panel" ] || command -v bt &> /dev/null; then
    echo ""
    echo -e "${GREEN}✓ aaPanel detected!${NC}"
    echo -e "${YELLOW}Since you have aaPanel, you don't need standalone Nginx.${NC}"
    echo ""
    echo -e "${YELLOW}Next steps for aaPanel:${NC}"
    echo "1. Login to aaPanel web interface"
    echo "2. Go to Website → Add site"
    echo "3. Domain: mailadmin.syscomatic.com"
    echo "4. Configure reverse proxy to: http://127.0.0.1:8888"
    echo "5. Add SSL certificate via aaPanel SSL manager"
    echo ""
    echo -e "${GREEN}See AAPANEL_SETUP.md for detailed instructions${NC}"
else
    # Nginx setup prompt (for non-aaPanel servers)
    echo ""
    read -p "Install and configure Nginx reverse proxy? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Install Nginx
        if ! command -v nginx &> /dev/null; then
            apt update
            apt install -y nginx
        fi
        
        # Copy Nginx config
        cp nginx.conf /etc/nginx/sites-available/snappymail
        ln -sf /etc/nginx/sites-available/snappymail /etc/nginx/sites-enabled/
        
        # Install Certbot
        if ! command -v certbot &> /dev/null; then
            apt install -y certbot python3-certbot-nginx
        fi
        
        # Get domain name
        read -p "Enter your domain (e.g., mailadmin.syscomatic.com): " DOMAIN
        
        # Update Nginx config with domain
        sed -i "s/mailadmin.syscomatic.com/$DOMAIN/g" /etc/nginx/sites-available/snappymail
        
        # Test Nginx config
        nginx -t
        
        # Reload Nginx
        systemctl reload nginx
        
        echo -e "${GREEN}Nginx configured${NC}"
        echo ""
        echo -e "${YELLOW}To get SSL certificate, run:${NC}"
        echo "sudo certbot --nginx -d $DOMAIN"
    fi
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Deployment completed!${NC}"
echo -e "${GREEN}================================${NC}"
