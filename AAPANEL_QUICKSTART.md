# 🎯 Quick Guide for aaPanel Users

## Your Situation

- ✅ You have **aaPanel** with Nginx already installed
- ✅ Your DNS is configured correctly on Cloudflare
- ✅ You want to replace Roundcube with Snappymail

## What You Need

### Files You'll Use:
1. ✅ **docker-compose.yml** - To run Snappymail
2. ✅ **AAPANEL_SETUP.md** - Complete aaPanel guide
3. ❌ **nginx.conf** - NOT NEEDED (aaPanel handles this)

### Files You Can Ignore:
- ❌ `nginx.conf` - You have aaPanel's Nginx
- ❌ `deploy.sh` Nginx section - Skip the Nginx installation part

---

## 🚀 Quick Setup (3 Steps)

### Step 1: Deploy Snappymail Docker Container

```bash
# SSH into your server
ssh root@156.67.216.209

# Create directory
mkdir -p /opt/mailsystem
cd /opt/mailsystem

# Upload docker-compose.yml and .env.example
# Then start container
docker-compose up -d
```

### Step 2: Configure aaPanel Reverse Proxy

1. **Login to aaPanel** (usually port 7800 or 8888)
2. **Add Website:**
   - Domain: `mailadmin.syscomatic.com`
   - Don't need PHP or database
3. **Configure Reverse Proxy:**
   - Go to site settings → Reverse Proxy
   - Target: `http://127.0.0.1:8888`
   - Save

### Step 3: Add SSL in aaPanel

1. Go to site settings → SSL
2. Click "Let's Encrypt"
3. Apply for certificate
4. Enable "Force HTTPS"

**Done!** Access at `https://mailadmin.syscomatic.com`

---

## 📖 Detailed Instructions

See **[AAPANEL_SETUP.md](AAPANEL_SETUP.md)** for:
- Complete aaPanel configuration
- Nginx config examples
- Troubleshooting
- Testing procedures

---

## 🔧 Why No nginx.conf?

**aaPanel manages Nginx for you!**

- aaPanel has a web interface for Nginx configuration
- You configure reverse proxy through aaPanel GUI
- SSL certificates are managed by aaPanel
- No need for manual Nginx config files

---

## ✅ What deploy.sh Will Do

The `deploy.sh` script is **smart**:

1. ✅ Detects aaPanel automatically
2. ✅ Installs Docker (if needed)
3. ✅ Starts Snappymail container
4. ❌ **Skips Nginx installation** (you have aaPanel)
5. ✅ Shows you aaPanel-specific instructions

---

## 📋 Your Checklist

- [ ] Upload files to `/opt/mailsystem/`
- [ ] Run `docker-compose up -d`
- [ ] Add site in aaPanel
- [ ] Configure reverse proxy in aaPanel
- [ ] Add SSL certificate in aaPanel
- [ ] Access admin panel and configure mail settings
- [ ] Test sending/receiving emails

---

## 🎯 Key Points

1. **Use aaPanel's Nginx** - Don't install standalone Nginx
2. **Reverse proxy to localhost:8888** - Snappymail runs in Docker
3. **SSL via aaPanel** - Use aaPanel's SSL manager
4. **Port 8888 NOT public** - Only accessible via aaPanel proxy

---

## 📞 Need Help?

- **aaPanel-specific:** [AAPANEL_SETUP.md](AAPANEL_SETUP.md)
- **General setup:** [QUICKSTART.md](QUICKSTART.md)
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**You're all set!** aaPanel makes this even easier than standalone setup.
