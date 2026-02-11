#!/bin/bash

# Fast Docker Pull Script
# Optimizes Docker image pulling for Snappymail

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Fast Docker Setup for Snappymail${NC}"
echo "===================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed!${NC}"
    echo "Please install Docker first or run ./deploy.sh"
    exit 1
fi

# Configure Docker for faster pulls
echo -e "${YELLOW}Step 1: Optimizing Docker configuration...${NC}"

# Check if daemon.json exists
if [ ! -f /etc/docker/daemon.json ]; then
    echo -e "${YELLOW}Creating Docker daemon config...${NC}"
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10,
  "dns": ["8.8.8.8", "1.1.1.1"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
    
    echo -e "${GREEN}✓ Docker config created${NC}"
    echo -e "${YELLOW}Restarting Docker...${NC}"
    sudo systemctl restart docker
    sleep 3
else
    echo -e "${GREEN}✓ Docker config already exists${NC}"
fi

# Pull image with progress
echo ""
echo -e "${YELLOW}Step 2: Pulling Snappymail image...${NC}"
echo -e "${YELLOW}This may take 2-5 minutes depending on your connection...${NC}"
echo ""

# Pull with timeout and retry
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker pull djmaze/snappymail:latest; then
        echo -e "${GREEN}✓ Image pulled successfully!${NC}"
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo -e "${YELLOW}Pull failed, retrying ($RETRY_COUNT/$MAX_RETRIES)...${NC}"
            sleep 5
        else
            echo -e "${RED}Failed to pull image after $MAX_RETRIES attempts${NC}"
            echo ""
            echo "Troubleshooting:"
            echo "1. Check internet connection: ping -c 4 google.com"
            echo "2. Check Docker Hub status: https://status.docker.com/"
            echo "3. Try with VPN if Docker Hub is blocked"
            echo "4. See DOCKER_OPTIMIZATION.md for more solutions"
            exit 1
        fi
    fi
done

# Show image info
echo ""
echo -e "${GREEN}Image Details:${NC}"
docker images djmaze/snappymail:latest --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

# Create data directory
echo ""
echo -e "${YELLOW}Step 3: Preparing directories...${NC}"
mkdir -p ./data
chmod 755 ./data
echo -e "${GREEN}✓ Data directory created${NC}"

# Create .env if needed
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ .env file created from template${NC}"
    fi
fi

# Start container
echo ""
echo -e "${YELLOW}Step 4: Starting Snappymail container...${NC}"

if docker-compose up -d; then
    echo -e "${GREEN}✓ Container started successfully!${NC}"
else
    echo -e "${RED}Failed to start container${NC}"
    echo "Check logs: docker-compose logs"
    exit 1
fi

# Wait for container to be ready
echo ""
echo -e "${YELLOW}Waiting for Snappymail to be ready...${NC}"
sleep 5

# Check if container is running
if docker ps | grep -q snappymail_webmail; then
    echo -e "${GREEN}✓ Snappymail is running!${NC}"
else
    echo -e "${RED}Container is not running${NC}"
    echo "Check logs: docker-compose logs"
    exit 1
fi

# Test if accessible
echo ""
echo -e "${YELLOW}Testing accessibility...${NC}"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 | grep -q "200\|302"; then
    echo -e "${GREEN}✓ Snappymail is accessible!${NC}"
else
    echo -e "${YELLOW}⚠ Snappymail may still be starting...${NC}"
    echo "Wait 30 seconds and check: http://localhost:8888"
fi

# Show summary
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${GREEN}Access Snappymail:${NC}"
echo "  Local: http://localhost:8888"
echo "  Admin: http://localhost:8888/?admin"
echo ""
echo -e "${YELLOW}Default admin password: 12345${NC}"
echo -e "${RED}⚠️  CHANGE THIS IMMEDIATELY!${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Configure aaPanel reverse proxy (see AAPANEL_SETUP.md)"
echo "2. Add SSL certificate in aaPanel"
echo "3. Configure mail server in Snappymail admin panel"
echo ""
echo -e "${GREEN}Useful commands:${NC}"
echo "  View logs: docker-compose logs -f"
echo "  Restart: docker-compose restart"
echo "  Stop: docker-compose down"
echo "  Health check: ./health-check.sh"
echo ""

# Show resource usage
echo -e "${GREEN}Current resource usage:${NC}"
docker stats snappymail_webmail --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo ""
echo -e "${GREEN}🎉 All done! Enjoy your new webmail!${NC}"
