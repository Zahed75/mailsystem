# Roundcube Webmail System

> **Reliable, proven webmail client for your aaPanel mail server**  
> Works immediately with your existing mail accounts

---

## 🎯 What is This?

**Roundcube** - The most popular open-source webmail client. Pre-configured for your aaPanel mail server at `mailadmin.syscomatic.com`.

### ✨ Why Roundcube?

- ✅ **Works immediately** - No complex configuration
- ✅ **Proven & reliable** - Used by millions
- ✅ **Pre-configured** - Ready for your mail server
- ✅ **No admin panel issues** - Just login and use
- ✅ **Full-featured** - Everything you need

---

## 🚀 Quick Deploy (2 Commands)

### **1. Upload to VPS:**
```bash
scp -r * root@156.67.216.209:/opt/mailsystem/
```

### **2. Run Setup:**
```bash
ssh root@156.67.216.209
cd /opt/mailsystem
sudo ./deploy.sh
```

**That's it!** Takes 3 minutes.

---

## ⚙️ Pre-Configured Settings

Already configured for your mail server:

```yaml
IMAP:
  Server: 156.67.216.209
  Port: 993
  Security: SSL

SMTP:
  Server: 156.67.216.209
  Port: 587
  Security: TLS
```

**No configuration needed!**

---

## 🎯 After Deployment

### **Configure aaPanel Reverse Proxy:**

1. **Login to aaPanel**
2. **Add Website:**
   - Domain: `mailadmin.syscomatic.com`
3. **Set Reverse Proxy:**
   - Target: `http://127.0.0.1:8080`
4. **Add SSL Certificate:**
   - Use Let's Encrypt

### **Access Webmail:**

Go to: `https://mailadmin.syscomatic.com`

Login with:
```
Email: asif@syscomatic.com
Password: Asif@2026#
```

**Works immediately!** ✨

---

## 📋 Your Email Accounts

All these accounts will work:

```
asif@syscomatic.com - Asif@2026#
rakib@syscomatic.com - Rakib@2026#
consult@syscomatic.com - C@nsult@2026#
zahed@syscomatic.com - Z@hed@2026#
```

---

## 🆚 Roundcube vs Snappymail

| Feature | Roundcube | Snappymail |
|---------|-----------|------------|
| **Setup** | ✅ Works immediately | ❌ Needs admin config |
| **Reliability** | ✅ Very stable | ⚠️ Can be tricky |
| **Configuration** | ✅ Pre-configured | ❌ Manual setup |
| **Compatibility** | ✅ Works with all mail servers | ⚠️ Sometimes issues |
| **Maturity** | ✅ 15+ years | ⚠️ Newer |

**Roundcube just works!**

---

## 🔧 Useful Commands

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Restart
docker-compose restart

# View logs
docker-compose logs -f

# Update
docker-compose pull
docker-compose up -d
```

---

## 📊 System Requirements

**Minimum:**
- 512MB RAM
- 1 CPU core
- 2GB disk space

**Your server meets all requirements!**

---

## 🎨 Features

- ✅ Clean, professional interface
- ✅ Mobile responsive
- ✅ Contact management
- ✅ File attachments (50MB)
- ✅ Multiple identities
- ✅ Folder management
- ✅ Search functionality
- ✅ Keyboard shortcuts
- ✅ Multiple languages
- ✅ Plugins support

---

## 🔒 Security

- ✅ SSL/TLS encryption
- ✅ Secure IMAP/SMTP
- ✅ Session management
- ✅ XSS protection
- ✅ CSRF protection

---

## 📱 Mobile Access

Works perfectly on:
- ✅ iPhone/iPad
- ✅ Android phones/tablets
- ✅ All modern browsers

---

## 🛠️ Troubleshooting

### Can't login?

**Check:**
1. Email password is correct
2. Mail server is running
3. Ports 993 and 587 are open

### Connection error?

**Run diagnostic:**
```bash
./check-mail-server.sh
```

### Need to reconfigure?

**Edit environment variables:**
```bash
nano docker-compose.yml
# Change ROUNDCUBEMAIL_DEFAULT_HOST or SMTP settings
docker-compose restart
```

---

## 📖 Documentation

- **Official Docs:** https://roundcube.net/
- **GitHub:** https://github.com/roundcube/roundcubemail
- **Docker Image:** https://hub.docker.com/r/roundcube/roundcubemail

---

## ⏱️ Deployment Timeline

1. Upload files: ~1 minute
2. Run deploy.sh: ~3 minutes
3. Configure aaPanel: ~2 minutes
4. **Total: ~6 minutes**

---

## ✅ What's Different

**Snappymail Issues:**
- ❌ Admin panel configuration required
- ❌ Password reset issues
- ❌ Complex setup

**Roundcube Solution:**
- ✅ No admin panel needed
- ✅ Works immediately
- ✅ Simple setup

---

## 🎉 Ready to Deploy

```bash
# Upload
scp -r * root@156.67.216.209:/opt/mailsystem/

# Deploy
ssh root@156.67.216.209 "cd /opt/mailsystem && sudo ./deploy.sh"

# Configure aaPanel reverse proxy

# Done!
```

---

## 📞 Support

- Check logs: `docker-compose logs -f`
- Test mail server: `./check-mail-server.sh`
- Roundcube community: https://roundcube.net/support

---

**Roundcube is the reliable choice. Deploy now!** 🚀
