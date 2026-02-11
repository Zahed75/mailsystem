# Docker Performance Optimization Guide

## 🐌 Why is Docker Slow?

Common reasons for slow Docker operations:

1. **Slow image download** - Pulling from Docker Hub
2. **Network issues** - Slow internet connection
3. **No local cache** - Re-downloading every time
4. **VPS limitations** - Low bandwidth or CPU
5. **Docker daemon issues** - Not optimized

---

## ⚡ Quick Fixes

### 1. Use Pre-pulled Image (Fastest)

Instead of pulling every time, pull once and use cached image:

```bash
# Pull image once
docker pull djmaze/snappymail:latest

# Then start (uses cached image)
docker-compose up -d
```

### 2. Optimize docker-compose.yml

The updated `docker-compose.yml` now includes:

```yaml
pull_policy: missing  # Only pull if image doesn't exist
```

This prevents re-downloading if image exists locally.

### 3. Use Specific Version Tag

Instead of `:latest`, use a specific version:

```yaml
image: djmaze/snappymail:v2.29.1  # Specific version
```

Benefits:
- ✅ Faster (smaller, specific image)
- ✅ Predictable (won't change)
- ✅ Cacheable (won't re-download)

---

## 🚀 Speed Up Image Pulls

### Option 1: Use Docker Mirror (For Slow Regions)

If you're in a region with slow Docker Hub access:

```bash
# Edit Docker daemon config
sudo nano /etc/docker/daemon.json
```

Add mirror:
```json
{
  "registry-mirrors": [
    "https://mirror.gcr.io",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

### Option 2: Parallel Downloads

Enable parallel layer downloads:

```bash
# Edit /etc/docker/daemon.json
{
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10
}
```

Restart:
```bash
sudo systemctl restart docker
```

### Option 3: Use Faster DNS

```bash
# Edit /etc/docker/daemon.json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

---

## 📊 Diagnose Slow Performance

### Check Docker Pull Speed

```bash
# Time the pull
time docker pull djmaze/snappymail:latest
```

### Check Network Speed

```bash
# Test download speed
curl -o /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip
```

### Check Docker Daemon

```bash
# Check Docker status
systemctl status docker

# Check Docker info
docker info

# Check for errors
journalctl -u docker --since "1 hour ago"
```

---

## 🎯 Optimized Workflow

### First Time Setup

```bash
# 1. Pull image manually (shows progress)
docker pull djmaze/snappymail:latest

# 2. Start container (instant, uses cached image)
docker-compose up -d
```

### Subsequent Starts

```bash
# Just start (no pulling needed)
docker-compose up -d
```

### Update to Latest

```bash
# Only when you want to update
docker-compose pull
docker-compose up -d
```

---

## 🔧 Alternative: Build Locally (Advanced)

If pulling is consistently slow, build a minimal image locally:

### Create Minimal Dockerfile

```dockerfile
FROM alpine:latest

# Install minimal dependencies
RUN apk add --no-cache \
    php81 \
    php81-fpm \
    php81-curl \
    php81-iconv \
    php81-xml \
    php81-openssl \
    wget

# Download Snappymail
RUN wget https://github.com/the-djmaze/snappymail/releases/latest/download/snappymail-latest.tar.gz \
    && tar -xzf snappymail-latest.tar.gz -C /app \
    && rm snappymail-latest.tar.gz

WORKDIR /app
EXPOSE 8888

CMD ["php", "-S", "0.0.0.0:8888"]
```

### Build Locally

```bash
# Build once (5-10 minutes)
docker build -t snappymail-local .

# Update docker-compose.yml
# image: snappymail-local
```

---

## 💾 Use Smaller Base Image

### Option: Use Alpine Version

```yaml
services:
  snappymail:
    image: djmaze/snappymail:latest-alpine  # Smaller image
```

Alpine images are typically:
- ✅ 50-70% smaller
- ✅ Faster to download
- ✅ Less disk space

---

## 🌐 Network Optimization

### 1. Check VPS Network

```bash
# Test VPS network speed
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
```

### 2. Use VPS Provider's Mirror

Some VPS providers have Docker mirrors:
- DigitalOcean: Has Docker registry cache
- AWS: Use ECR Public
- Alibaba Cloud: Has Docker mirror

### 3. Download via Proxy (If Blocked)

```bash
# Set proxy for Docker
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
```

Add:
```
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:8080"
Environment="HTTPS_PROXY=http://proxy.example.com:8080"
```

---

## 📈 Performance Benchmarks

### Expected Times

| Operation | Good | Acceptable | Slow |
|-----------|------|------------|------|
| First pull | 1-2 min | 3-5 min | >5 min |
| Cached start | <5 sec | 5-10 sec | >10 sec |
| Container ready | 10-20 sec | 30-40 sec | >1 min |

### If Slower Than Expected

1. **Check internet speed** - Run speedtest
2. **Check VPS specs** - Ensure adequate resources
3. **Use Docker mirror** - Configure registry mirror
4. **Use specific version** - Instead of `:latest`

---

## 🛠️ Troubleshooting Commands

```bash
# Check what's taking time
docker-compose up -d --verbose

# Check image layers
docker history djmaze/snappymail:latest

# Check disk space
df -h
docker system df

# Clean up old images
docker system prune -a

# Check Docker daemon logs
journalctl -u docker -f

# Monitor resource usage
docker stats snappymail_webmail
```

---

## ✅ Recommended Configuration

### For aaPanel Users (Best Performance)

```yaml
version: '3.8'

services:
  snappymail:
    image: djmaze/snappymail:v2.29.1  # Specific version
    container_name: snappymail_webmail
    restart: unless-stopped
    pull_policy: missing  # Don't re-pull
    ports:
      - "127.0.0.1:8888:8888"
    volumes:
      - ./data:/var/lib/snappymail
    environment:
      - TZ=Asia/Dhaka
    networks:
      - mailnet
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8888"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  mailnet:
    driver: bridge
```

---

## 🎯 Quick Performance Checklist

- [ ] Pull image manually first: `docker pull djmaze/snappymail:latest`
- [ ] Use `pull_policy: missing` in docker-compose.yml
- [ ] Bind to localhost only: `127.0.0.1:8888:8888`
- [ ] Configure Docker mirrors (if in slow region)
- [ ] Enable parallel downloads in Docker daemon
- [ ] Use specific version tag instead of `:latest`
- [ ] Clean up old images: `docker system prune`
- [ ] Check VPS network speed
- [ ] Monitor with: `docker stats`

---

## 🚀 Fastest Deployment Method

```bash
# 1. Pull image in background (one time)
docker pull djmaze/snappymail:latest &

# 2. While pulling, prepare files
cd /opt/mailsystem
cp .env.example .env
mkdir -p data

# 3. Wait for pull to complete
wait

# 4. Start instantly
docker-compose up -d

# Total time: ~2-3 minutes (instead of 5-10)
```

---

## 📞 Still Slow?

If Docker is still slow after optimization:

1. **Check VPS specs** - Ensure 1GB+ RAM, 1+ CPU
2. **Check disk I/O** - Run `iostat` to check disk performance
3. **Check network** - Test with `speedtest-cli`
4. **Contact VPS provider** - May have network issues
5. **Consider different VPS** - Some providers have faster Docker pulls

---

**Most common fix:** Just pull the image once manually, then use cached version!

```bash
docker pull djmaze/snappymail:latest
docker-compose up -d  # Instant!
```
