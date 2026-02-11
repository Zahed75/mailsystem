# 📧 Snappymail Webmail System

> **Modern, Gmail-like webmail client for your custom mail server**  
> Replace Roundcube with a beautiful, fast, and easy-to-use interface

[![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-AGPL--3.0-green)](https://github.com/the-djmaze/snappymail)
[![Snappymail](https://img.shields.io/badge/Snappymail-Latest-orange)](https://snappymail.eu/)

---

## 🎯 What is This?

A complete, production-ready setup for **Snappymail** webmail client, designed to replace Roundcube on your custom mail server at `mailadmin.syscomatic.com`.

### ✨ Key Features

- 🎨 **Modern Gmail-like interface** - Beautiful and intuitive
- 📱 **Mobile responsive** - Works perfectly on all devices
- 🚀 **Fast deployment** - Get started in 5 minutes
- 🐳 **Docker-based** - Easy to deploy and maintain
- 🔒 **Secure** - SSL/TLS, 2FA support
- ⚡ **Lightweight** - Only 50MB RAM usage
- 🛠️ **Easy configuration** - Simple admin panel

---

## 🚀 Quick Start

### One-Command Deployment

```bash
# Upload to your VPS
scp -r * root@156.67.216.209:/opt/mailsystem/

# SSH and deploy
ssh root@156.67.216.209
cd /opt/mailsystem
sudo ./deploy.sh
```

**That's it!** Access at `http://your-server:8888`

For detailed instructions, see **[QUICKSTART.md](QUICKSTART.md)**

---

## 📚 Documentation

| Document | Description | Read Time |
|----------|-------------|-----------|
| **[INDEX.md](INDEX.md)** | 📑 Complete navigation guide | 5 min |
| **[QUICKSTART.md](QUICKSTART.md)** | 🚀 5-minute setup guide | 5 min |
| **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** | 📊 Project overview | 5 min |
| **[README.md](README.md)** | 📖 Full documentation | 15 min |
| **[COMPARISON.md](COMPARISON.md)** | 🆚 Why Snappymail? | 10 min |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | 🏗️ System architecture | 15 min |
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | 🔧 Problem solving | As needed |

**👉 Start with [INDEX.md](INDEX.md) for complete navigation**

---

## 📁 Project Structure

```
mailsystem/
├── 📄 Documentation
│   ├── INDEX.md                    # Navigation guide
│   ├── QUICKSTART.md               # 5-minute setup
│   ├── PROJECT_SUMMARY.md          # Overview
│   ├── README.md                   # Full docs
│   ├── COMPARISON.md               # Alternatives comparison
│   ├── ARCHITECTURE.md             # System design
│   └── TROUBLESHOOTING.md          # Problem solving
│
├── 🔧 Scripts
│   ├── deploy.sh                   # Automated deployment
│   ├── backup.sh                   # Backup automation
│   ├── health-check.sh             # System monitoring
│   └── test-smtp.sh                # SMTP testing
│
├── ⚙️ Configuration
│   ├── docker-compose.yml          # Docker config (dev)
│   ├── docker-compose.prod.yml     # Docker config (prod)
│   ├── Dockerfile                  # Custom image
│   ├── nginx.conf                  # Reverse proxy
│   └── .env.example                # Environment template
│
└── 📂 Data
    └── data/                       # Created on first run
```

---

## 🎯 Why Snappymail?

### Problems with Roundcube
- ❌ Complex setup and configuration
- ❌ Outdated, cluttered interface
- ❌ SMTP authentication issues
- ❌ Poor mobile experience
- ❌ Slow performance

### Snappymail Solutions
- ✅ 5-minute Docker deployment
- ✅ Modern, Gmail-like interface
- ✅ Easy SMTP configuration
- ✅ Excellent mobile support
- ✅ Fast and lightweight

**See [COMPARISON.md](COMPARISON.md) for detailed comparison**

---

## 🛠️ Your Mail Server Setup

### Current Configuration (Already Set Up ✅)

**DNS Records:**
- ✅ A: `mailadmin.syscomatic.com` → `156.67.216.209`
- ✅ MX: `syscomatic.com` → `mail.syscomatic.com`
- ✅ SPF: `v=spf1 a mx ip4:156.67.216.209 ~all`
- ✅ DKIM: Configured
- ✅ DMARC: Configured

**Mail Servers:**
- 📥 IMAP: `imap.syscomatic.com:993` (SSL)
- 📤 SMTP: `smtp.syscomatic.com:587` (STARTTLS)

---

## 🔧 Quick Commands

```bash
# Deploy
sudo ./deploy.sh

# Start/Stop
docker-compose up -d
docker-compose down

# View logs
docker-compose logs -f

# Health check
./health-check.sh

# Backup
./backup.sh

# Test SMTP
./test-smtp.sh

# Update
docker-compose pull && docker-compose up -d
```

---

## 📊 System Requirements

**Minimum:**
- 512MB RAM
- 1 CPU core
- 1GB disk space
- Ubuntu/Debian VPS

**Recommended:**
- 1GB RAM
- 2 CPU cores
- 5GB disk space

---

## 🔒 Security Features

- ✅ SSL/TLS encryption (HTTPS)
- ✅ Secure IMAP/SMTP connections
- ✅ 2FA support
- ✅ Security headers (HSTS, CSP, etc.)
- ✅ Docker isolation
- ✅ Regular security updates

---

## 📱 Access Points

After deployment:

- **Webmail:** `https://mailadmin.syscomatic.com`
- **Admin Panel:** `https://mailadmin.syscomatic.com/?admin`
- **Default Admin Password:** `12345` (⚠️ Change immediately!)

---

## 🎓 Getting Started Guide

### For First-Time Users

1. **Read the overview**
   - Start with [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)

2. **Quick deployment**
   - Follow [QUICKSTART.md](QUICKSTART.md)

3. **Configure your server**
   - Access admin panel
   - Add your domain
   - Configure IMAP/SMTP

4. **Set up production**
   - Install SSL certificate
   - Configure Nginx
   - Set up backups

5. **Test everything**
   - Run `./health-check.sh`
   - Send test email
   - Check mobile access

### For Experienced Users

```bash
# Clone/upload files
scp -r * root@your-server:/opt/mailsystem/

# Deploy
ssh root@your-server
cd /opt/mailsystem
./deploy.sh

# Configure
# Access http://your-server:8888/?admin
# Add domain, configure IMAP/SMTP

# Production setup
sudo certbot --nginx -d mailadmin.syscomatic.com
```

---

## 🆘 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Authentication error | See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) #1 |
| Can't send emails | Run `./test-smtp.sh` |
| Container won't start | Check `docker-compose logs` |
| Port already in use | Change port in `docker-compose.yml` |
| SSL certificate issues | Run `certbot --nginx` |

**Full troubleshooting guide:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 🔄 Migration from Roundcube

**Zero-downtime migration:**

1. Deploy Snappymail (keep Roundcube running)
2. Configure mail server settings
3. Test with one account
4. Inform users of new URL
5. Run both for 1 week
6. Decommission Roundcube

**Total time:** ~30 minutes  
**Downtime:** Zero

---

## 📦 What's Included

### Documentation (7 files)
- Complete setup guides
- Architecture diagrams
- Troubleshooting guides
- Comparison with alternatives

### Scripts (4 files)
- Automated deployment
- Backup automation
- Health monitoring
- SMTP testing

### Configuration (5 files)
- Docker Compose configs
- Nginx reverse proxy
- Environment templates
- Custom Dockerfile

---

## 🌟 Features

- ✅ Gmail-like interface
- ✅ Multiple accounts
- ✅ Contact management
- ✅ File attachments (up to 50MB)
- ✅ Search functionality
- ✅ Keyboard shortcuts
- ✅ Multiple themes
- ✅ Plugin system
- ✅ 2FA support
- ✅ Mobile responsive
- ✅ Multi-language
- ✅ Customizable branding

---

## 📈 Performance

- **Load time:** < 1 second
- **Memory usage:** ~50MB
- **CPU usage:** Minimal
- **Concurrent users:** 100+ (single server)
- **Email handling:** Fast IMAP/SMTP

---

## 🤝 Support

### Documentation
- 📖 **This project:** See [INDEX.md](INDEX.md)
- 🌐 **Snappymail:** https://snappymail.eu/
- 📚 **Wiki:** https://github.com/the-djmaze/snappymail/wiki

### Community
- 💬 **Forum:** https://forum.snappymail.eu/
- 🐛 **Issues:** https://github.com/the-djmaze/snappymail/issues

### Tools
- 🔧 **Email tester:** https://www.mail-tester.com/
- 📊 **MX toolbox:** https://mxtoolbox.com/
- 🔒 **SSL checker:** https://www.ssllabs.com/ssltest/

---

## 📝 License

- **Snappymail:** AGPL-3.0
- **This setup:** Free to use and modify

---

## 🎉 Ready to Deploy?

### Quick Start
```bash
cd /opt/mailsystem
sudo ./deploy.sh
```

### Need Help?
- 📖 Read [QUICKSTART.md](QUICKSTART.md)
- 🗺️ Check [INDEX.md](INDEX.md)
- 🔧 See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## ✅ Pre-Deployment Checklist

- [ ] VPS server ready (Ubuntu/Debian)
- [ ] Domain pointing to server
- [ ] Root/sudo access
- [ ] Read [QUICKSTART.md](QUICKSTART.md)
- [ ] Copied `.env.example` to `.env`
- [ ] Updated `.env` with settings

---

## 🏆 Success Criteria

After deployment, you should have:

- ✅ Snappymail running on port 8888
- ✅ Admin panel accessible
- ✅ Mail server configured
- ✅ SSL certificate installed
- ✅ Emails sending/receiving
- ✅ Mobile access working
- ✅ Backups configured

---

## 📞 Next Steps

1. **Deploy** - Run `./deploy.sh`
2. **Configure** - Set up mail server in admin panel
3. **Secure** - Install SSL certificate
4. **Test** - Send/receive test emails
5. **Monitor** - Set up `./health-check.sh` cron job
6. **Backup** - Configure `./backup.sh` automation

---

**Made with ❤️ for syscomatic.com**

*For complete navigation, see [INDEX.md](INDEX.md)*

---

**Quick Links:**
- 🚀 [Quick Start](QUICKSTART.md)
- 📖 [Full Documentation](README.md)
- 🆚 [Comparison](COMPARISON.md)
- 🔧 [Troubleshooting](TROUBLESHOOTING.md)
- 🏗️ [Architecture](ARCHITECTURE.md)
- 📑 [Complete Index](INDEX.md)
# mailsystem
