# Quick Start Guide

## 🚀 Deploy Snappymail in 5 Minutes

### Prerequisites
- VPS server with Ubuntu/Debian
- Root or sudo access
- Domain pointing to your server (mailadmin.syscomatic.com → 156.67.216.209)

### Step 1: Upload Files to VPS

```bash
# On your local machine
cd /Users/zahedzahed/Downloads/Backend-Application/mailsystem

# Upload to VPS (replace with your VPS IP)
scp -r * root@156.67.216.209:/opt/mailsystem/
```

### Step 2: SSH into VPS and Deploy

```bash
# SSH into your VPS
ssh root@156.67.216.209

# Navigate to directory
cd /opt/mailsystem

# Run deployment script
sudo ./deploy.sh
```

The script will:
- ✅ Install Docker and Docker Compose
- ✅ Create necessary directories
- ✅ Pull Snappymail image
- ✅ Start the container
- ✅ Configure firewall (optional)
- ✅ Set up Nginx with SSL (optional)

### Step 3: Access Admin Panel

1. Open browser: `http://156.67.216.209:8888/?admin`
2. Default password: `12345`
3. **CHANGE PASSWORD IMMEDIATELY!**

### Step 4: Configure Mail Server

In admin panel:

1. **Go to Domains** → Click "Add Domain"
2. **Enter domain:** `syscomatic.com`
3. **IMAP Settings:**
   - Server: `imap.syscomatic.com`
   - Port: `993`
   - Secure: `SSL/TLS`
   
4. **SMTP Settings:**
   - Server: `smtp.syscomatic.com`
   - Port: `587`
   - Secure: `STARTTLS`
   - ✅ Check "Use authentication"
   - ✅ Check "Use IMAP credentials"

5. **Click "Test"** to verify connection
6. **Click "Save"**

### Step 5: Set Up SSL (Production)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d mailadmin.syscomatic.com

# Certificate will auto-renew
```

### Step 6: Access Your Webmail

🎉 **Done!** Access at: `https://mailadmin.syscomatic.com`

Login with any email account on your mail server:
- Email: `yourname@syscomatic.com`
- Password: Your email password

---

## Manual Deployment (Alternative)

If you prefer manual setup:

### 1. Install Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Install Docker Compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3. Create Environment File

```bash
cp .env.example .env
nano .env  # Edit with your settings
```

### 4. Start Snappymail

```bash
docker-compose up -d
```

### 5. Check Status

```bash
docker-compose ps
docker-compose logs -f
```

---

## Testing SMTP Authentication

Before configuring Snappymail, test your SMTP:

```bash
./test-smtp.sh
```

This will verify:
- ✅ SMTP port is accessible
- ✅ STARTTLS is working
- ✅ Authentication succeeds
- ✅ DNS records are correct

---

## Troubleshooting

### Container won't start?

```bash
# Check logs
docker-compose logs

# Restart
docker-compose restart
```

### Can't access admin panel?

```bash
# Check if port 8888 is open
sudo ufw allow 8888/tcp

# Check if container is running
docker ps
```

### Authentication errors?

1. Verify SMTP settings in admin panel
2. Run `./test-smtp.sh` to test connection
3. Check mail server logs
4. See `TROUBLESHOOTING.md` for detailed solutions

---

## Next Steps

1. ✅ **Customize branding** in admin panel
2. ✅ **Enable 2FA** for security
3. ✅ **Set up automatic backups**
4. ✅ **Configure mobile access**
5. ✅ **Test email sending/receiving**

---

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Restart service
docker-compose restart

# Stop service
docker-compose down

# Update to latest version
docker-compose pull
docker-compose up -d

# Backup data
tar -czf backup-$(date +%Y%m%d).tar.gz ./data

# Restore backup
tar -xzf backup-20260211.tar.gz
```

---

## Support

- 📖 Full documentation: `README.md`
- 🔧 Troubleshooting: `TROUBLESHOOTING.md`
- 🌐 Snappymail docs: https://snappymail.eu/
- 💬 Community: https://forum.snappymail.eu/

---

**Estimated setup time: 5-10 minutes** ⏱️

Good luck! 🚀
