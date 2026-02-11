# aaPanel Setup Guide for Snappymail

## 🎯 Overview

Since you already have **aaPanel with Nginx**, you don't need the standalone `nginx.conf` file. Instead, you'll:

1. Deploy Snappymail with Docker (port 8888)
2. Configure reverse proxy in aaPanel
3. Add SSL certificate through aaPanel

---

## 🚀 Quick Setup

### Step 1: Deploy Snappymail

```bash
# SSH into your server
ssh root@156.67.216.209

# Create directory
mkdir -p /opt/mailsystem
cd /opt/mailsystem

# Upload files (or use the deploy script)
# Just start Docker container
docker-compose up -d
```

**Note:** Skip the Nginx installation part in `deploy.sh` since aaPanel handles it.

---

### Step 2: Configure aaPanel Reverse Proxy

#### A. Create Website in aaPanel

1. **Login to aaPanel**
   - URL: `http://156.67.216.209:7800` (or your aaPanel port)
   - Login with your credentials

2. **Add Website**
   - Go to: **Website** → **Add site**
   - Domain: `mailadmin.syscomatic.com`
   - Document root: `/www/wwwroot/mailadmin.syscomatic.com` (can be empty)
   - PHP version: Not needed (we're using reverse proxy)
   - Click **Submit**

#### B. Configure Reverse Proxy

1. **Go to Site Settings**
   - Click on your site `mailadmin.syscomatic.com`
   - Go to **Reverse Proxy** tab

2. **Add Proxy Configuration**
   - Target URL: `http://127.0.0.1:8888`
   - Enable: **Send domain** (optional)
   - Enable: **Cache** (optional)
   - Click **Submit**

#### C. Alternative: Manual Nginx Config in aaPanel

If reverse proxy tab doesn't work, use **Config File** tab:

1. Click on `mailadmin.syscomatic.com` → **Config File**
2. Add this inside the `server` block:

```nginx
location / {
    proxy_pass http://127.0.0.1:8888;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # WebSocket support
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    
    # Timeouts
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
}

# Increase client body size for attachments
client_max_body_size 50M;
```

3. Click **Save**
4. Test Nginx: `nginx -t`
5. Reload Nginx in aaPanel

---

### Step 3: Add SSL Certificate

#### Option A: Using aaPanel SSL Manager (Recommended)

1. **Go to Site Settings**
   - Click on `mailadmin.syscomatic.com`
   - Go to **SSL** tab

2. **Get Let's Encrypt Certificate**
   - Select **Let's Encrypt**
   - Domain: `mailadmin.syscomatic.com`
   - Email: Your email
   - Click **Apply**

3. **Enable Force HTTPS**
   - Toggle **Force HTTPS** to ON

#### Option B: Using Cloudflare SSL

Since you use Cloudflare:

1. **In Cloudflare Dashboard**
   - Go to SSL/TLS
   - Set to **Full** or **Full (strict)**

2. **In aaPanel**
   - You can use Cloudflare Origin Certificate
   - Or use Let's Encrypt (recommended)

---

## 📝 Modified Docker Compose

Since aaPanel handles Nginx, use this simplified `docker-compose.yml`:

```yaml
version: '3.8'

services:
  snappymail:
    image: djmaze/snappymail:latest
    container_name: snappymail_webmail
    restart: unless-stopped
    ports:
      - "127.0.0.1:8888:8888"  # Only localhost (aaPanel Nginx will proxy)
    volumes:
      - ./data:/var/lib/snappymail
    environment:
      - TZ=Asia/Dhaka
    networks:
      - mailnet

networks:
  mailnet:
    driver: bridge
```

**Key difference:** Port is bound to `127.0.0.1:8888` (localhost only), not public.

---

## 🔧 Complete Setup Steps

### 1. Prepare Server

```bash
# SSH into server
ssh root@156.67.216.209

# Create directory
mkdir -p /opt/mailsystem
cd /opt/mailsystem

# Upload your files
# (Use SCP, SFTP, or aaPanel File Manager)
```

### 2. Start Snappymail

```bash
# Start container
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 3. Configure aaPanel

1. **Add website** in aaPanel
2. **Configure reverse proxy** to `http://127.0.0.1:8888`
3. **Add SSL certificate**
4. **Enable Force HTTPS**

### 4. Configure Snappymail

1. Access admin panel: `https://mailadmin.syscomatic.com/?admin`
2. Default password: `12345` (change immediately!)
3. Add domain: `syscomatic.com`
4. Configure IMAP/SMTP settings

---

## 🎯 aaPanel-Specific Configuration

### Firewall Settings

In aaPanel:

1. **Security** → **Firewall**
2. Ensure these ports are open:
   - `80` (HTTP)
   - `443` (HTTPS)
   - `587` (SMTP)
   - `993` (IMAPS)
3. **Port 8888 should NOT be open** (only localhost access)

### PHP Not Required

Since Snappymail runs in Docker, you don't need PHP in aaPanel for this site.

### Database Not Required

Snappymail uses file-based storage, no MySQL/PostgreSQL needed.

---

## 📊 Architecture with aaPanel

```
Internet
    ↓
Cloudflare DNS (mailadmin.syscomatic.com → 156.67.216.209)
    ↓
aaPanel Nginx (Port 80/443)
    ↓ Reverse Proxy
Docker Container (Snappymail on localhost:8888)
    ↓
Mail Server (IMAP:993, SMTP:587)
```

---

## 🔍 Testing

### 1. Test Docker Container

```bash
# Check if running
docker ps | grep snappymail

# Test localhost access
curl http://localhost:8888
```

### 2. Test aaPanel Proxy

```bash
# Test from server
curl http://mailadmin.syscomatic.com

# Should return Snappymail HTML
```

### 3. Test SSL

```bash
# Test HTTPS
curl https://mailadmin.syscomatic.com

# Check SSL certificate
openssl s_client -connect mailadmin.syscomatic.com:443
```

---

## 🛠️ Troubleshooting

### Issue: 502 Bad Gateway

**Cause:** Nginx can't connect to Docker container

**Solution:**
```bash
# Check if container is running
docker ps

# Check if port 8888 is listening
netstat -tuln | grep 8888

# Restart container
docker-compose restart
```

### Issue: Can't Access Admin Panel

**Cause:** Reverse proxy not configured correctly

**Solution:**
1. Check aaPanel reverse proxy settings
2. Ensure target is `http://127.0.0.1:8888`
3. Check Nginx error logs in aaPanel

### Issue: SSL Certificate Error

**Cause:** Certificate not properly installed

**Solution:**
1. Re-apply Let's Encrypt in aaPanel
2. Ensure domain points to correct IP
3. Check Cloudflare SSL settings (should be Full or Full Strict)

---

## 📋 aaPanel Nginx Config Template

If you need to manually edit Nginx config in aaPanel, use this template:

```nginx
server {
    listen 80;
    server_name mailadmin.syscomatic.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name mailadmin.syscomatic.com;
    
    # SSL managed by aaPanel
    ssl_certificate /www/server/panel/vhost/cert/mailadmin.syscomatic.com/fullchain.pem;
    ssl_certificate_key /www/server/panel/vhost/cert/mailadmin.syscomatic.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    # Client body size for attachments
    client_max_body_size 50M;
    
    # Reverse proxy to Snappymail
    location / {
        proxy_pass http://127.0.0.1:8888;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Logging
    access_log /www/wwwlogs/mailadmin.syscomatic.com.log;
    error_log /www/wwwlogs/mailadmin.syscomatic.com.error.log;
}
```

---

## 🎯 Quick Commands for aaPanel

```bash
# Restart Nginx (via aaPanel or command line)
systemctl restart nginx

# Check Nginx status
systemctl status nginx

# Test Nginx config
nginx -t

# View Nginx error logs
tail -f /www/wwwlogs/mailadmin.syscomatic.com.error.log

# View Snappymail logs
docker-compose logs -f
```

---

## ✅ Checklist

- [ ] Docker installed
- [ ] Snappymail container running on localhost:8888
- [ ] Website added in aaPanel
- [ ] Reverse proxy configured
- [ ] SSL certificate installed
- [ ] Force HTTPS enabled
- [ ] Firewall configured (8888 NOT open to public)
- [ ] Snappymail admin panel accessible
- [ ] Mail server configured in Snappymail
- [ ] Test email sent/received

---

## 🎉 Summary

**What you DON'T need:**
- ❌ Standalone `nginx.conf` file
- ❌ Manual Nginx installation
- ❌ Manual SSL certificate setup (aaPanel handles it)

**What you DO need:**
- ✅ Docker container running on localhost:8888
- ✅ aaPanel reverse proxy configuration
- ✅ SSL certificate via aaPanel
- ✅ Firewall configuration in aaPanel

---

## 📞 Need Help?

- **aaPanel Issues:** Check aaPanel logs in Security → System Logs
- **Docker Issues:** Run `./health-check.sh`
- **Email Issues:** Run `./test-smtp.sh`
- **General Issues:** See `TROUBLESHOOTING.md`

---

**You're all set!** aaPanel makes this even easier than standalone Nginx.
