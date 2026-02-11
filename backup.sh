#!/bin/bash

# Snappymail Backup Script
# Run this script to backup your Snappymail data

set -e

# Configuration
BACKUP_DIR="/opt/mailsystem/backups"
DATA_DIR="/opt/mailsystem/data"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="snappymail-backup-${DATE}.tar.gz"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔄 Snappymail Backup Script${NC}"
echo "=============================="

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo -e "${RED}❌ Data directory not found: $DATA_DIR${NC}"
    exit 1
fi

# Get current directory
CURRENT_DIR=$(pwd)

# Stop container (optional - uncomment if you want to stop during backup)
# echo -e "${YELLOW}Stopping Snappymail container...${NC}"
# docker-compose down

# Create backup
echo -e "${YELLOW}Creating backup...${NC}"
cd /opt/mailsystem
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" data/

# Check if backup was successful
if [ -f "${BACKUP_DIR}/${BACKUP_FILE}" ]; then
    BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_FILE}" | cut -f1)
    echo -e "${GREEN}✅ Backup created successfully${NC}"
    echo -e "   File: ${BACKUP_FILE}"
    echo -e "   Size: ${BACKUP_SIZE}"
    echo -e "   Location: ${BACKUP_DIR}"
else
    echo -e "${RED}❌ Backup failed${NC}"
    exit 1
fi

# Restart container if it was stopped
# echo -e "${YELLOW}Starting Snappymail container...${NC}"
# docker-compose up -d

# Remove old backups
echo -e "${YELLOW}Cleaning old backups (older than ${RETENTION_DAYS} days)...${NC}"
find "$BACKUP_DIR" -name "snappymail-backup-*.tar.gz" -mtime +$RETENTION_DAYS -delete

# List remaining backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/snappymail-backup-*.tar.gz 2>/dev/null | wc -l)
echo -e "${GREEN}Current backups: ${BACKUP_COUNT}${NC}"

# Optional: Upload to remote storage
# Uncomment and configure if you want to upload to S3, rsync, etc.
# echo -e "${YELLOW}Uploading to remote storage...${NC}"
# aws s3 cp "${BACKUP_DIR}/${BACKUP_FILE}" s3://your-bucket/snappymail-backups/
# or
# rsync -avz "${BACKUP_DIR}/${BACKUP_FILE}" user@remote-server:/backups/

echo ""
echo -e "${GREEN}=============================="
echo -e "Backup completed successfully!${NC}"
echo ""
echo "To restore this backup:"
echo "  1. Stop container: docker-compose down"
echo "  2. Extract backup: tar -xzf ${BACKUP_DIR}/${BACKUP_FILE}"
echo "  3. Start container: docker-compose up -d"
