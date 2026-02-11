# Snappymail Webmail System - Project Summary

## 📧 What is This?

A modern, Gmail-like webmail client to replace Roundcube for your custom mail server at `mailadmin.syscomatic.com`.

## 🎯 Problem Solved

You had issues with Roundcube:
- ❌ Complex setup
- ❌ Bad interface
- ❌ SMTP authentication errors
- ❌ Difficult to use

**Snappymail fixes all of these!**

## 📁 Project Structure

```
mailsystem/
├── 📄 README.md                    # Full documentation
├── 📄 QUICKSTART.md                # 5-minute setup guide
├── 📄 COMPARISON.md                # Why Snappymail vs others
├── 📄 TROUBLESHOOTING.md           # Common issues & solutions
├── 🐳 docker-compose.yml           # Main Docker config (development)
├── 🐳 docker-compose.prod.yml      # Production Docker config
├── 🐳 Dockerfile                   # Custom Docker image
├── ⚙️  .env.example                # Environment variables template
├── 🌐 nginx.conf                   # Nginx reverse proxy config
├── 🚀 deploy.sh                    # Automated deployment script
├── 🔧 test-smtp.sh                 # SMTP connection tester
├── 📝 .gitignore                   # Git ignore rules
└── 📂 data/                        # Snappymail data (created on first run)
```

## 🚀 Quick Start

### Option 1: Automated Deployment (Recommended)

```bash
# 1. Upload to your VPS
scp -r * root@156.67.216.209:/opt/mailsystem/

# 2. SSH and deploy
ssh root@156.67.216.209
cd /opt/mailsystem
sudo ./deploy.sh
```

### Option 2: Manual Deployment

```bash
# 1. Start Docker container
docker-compose up -d

# 2. Access admin panel
# http://your-server:8888/?admin
# Default password: 12345

# 3. Configure mail server settings
# See QUICKSTART.md for details
```

## ⚙️ Configuration

### Your Mail Server Settings

**IMAP:**
- Server: `imap.syscomatic.com`
- Port: `993`
- Security: `SSL/TLS`

**SMTP:**
- Server: `smtp.syscomatic.com`
- Port: `587`
- Security: `STARTTLS`

### Your DNS Records (Already Configured ✅)

- ✅ A record: `mailadmin.syscomatic.com` → `156.67.216.209`
- ✅ MX record: `mail.syscomatic.com`
- ✅ SPF: `v=spf1 a mx ip4:156.67.216.209 ~all`
- ✅ DKIM: Configured
- ✅ DMARC: Configured

## 📱 Access

After deployment:

- **Webmail:** `https://mailadmin.syscomatic.com`
- **Admin Panel:** `https://mailadmin.syscomatic.com/?admin`
- **Mobile:** Same URL (fully responsive)

## 🔐 Security Checklist

- [ ] Change default admin password (12345)
- [ ] Set up SSL certificate (Let's Encrypt)
- [ ] Enable 2FA in admin panel
- [ ] Configure firewall rules
- [ ] Set up automatic backups

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| `README.md` | Complete documentation with all features |
| `QUICKSTART.md` | Get started in 5 minutes |
| `COMPARISON.md` | Why Snappymail vs Roundcube/others |
| `TROUBLESHOOTING.md` | Fix common issues |

## 🛠️ Useful Commands

```bash
# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Stop
docker-compose down

# Update
docker-compose pull && docker-compose up -d

# Backup
tar -czf backup-$(date +%Y%m%d).tar.gz ./data

# Test SMTP
./test-smtp.sh
```

## 🎨 Features

- ✅ Modern Gmail-like interface
- ✅ Mobile responsive
- ✅ Fast and lightweight
- ✅ Easy Docker deployment
- ✅ Customizable themes
- ✅ Multiple accounts support
- ✅ File attachments
- ✅ Contact management
- ✅ 2FA support
- ✅ Plugin system

## 🆚 vs Roundcube

| Feature | Snappymail | Roundcube |
|---------|-----------|-----------|
| Interface | Modern | Outdated |
| Setup | 5 minutes | 30-60 minutes |
| Performance | Fast | Slow |
| Mobile | Excellent | Poor |
| SMTP Auth | Easy | Complex |
| Resources | 50MB RAM | 100MB+ RAM |

## 🐛 Common Issues

### Authentication Error?
→ See `TROUBLESHOOTING.md` section 1

### Can't send emails?
→ Run `./test-smtp.sh` to diagnose

### Container won't start?
→ Check logs: `docker-compose logs`

### Need SSL?
→ Run: `sudo certbot --nginx -d mailadmin.syscomatic.com`

## 📞 Support

- 📖 Snappymail Docs: https://snappymail.eu/
- 💬 Community Forum: https://forum.snappymail.eu/
- 🐛 GitHub Issues: https://github.com/the-djmaze/snappymail/issues

## 🎯 Next Steps

1. **Deploy** using `deploy.sh` or `docker-compose up -d`
2. **Configure** mail server settings in admin panel
3. **Test** with your email account
4. **Set up SSL** for production use
5. **Customize** branding and themes
6. **Enable 2FA** for security

## 📊 System Requirements

**Minimum:**
- 512MB RAM
- 1 CPU core
- 1GB disk space

**Recommended:**
- 1GB RAM
- 2 CPU cores
- 5GB disk space (for emails)

## 🔄 Migration from Roundcube

1. Deploy Snappymail (keep Roundcube running)
2. Configure mail server settings
3. Test with one account
4. Inform users of new URL
5. Run both for 1 week
6. Decommission Roundcube

**Zero downtime migration!**

## 📝 License

Snappymail is licensed under AGPL-3.0

## 🙏 Credits

- **Snappymail:** https://github.com/the-djmaze/snappymail
- **Based on:** RainLoop (discontinued)

---

## 🚀 Ready to Deploy?

```bash
# Quick start
cd /opt/mailsystem
sudo ./deploy.sh
```

**Estimated setup time:** 5-10 minutes

**Good luck!** 🎉

---

*For detailed instructions, see `QUICKSTART.md`*
