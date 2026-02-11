# RainLoop Webmail System

> **Modern, fast, and simple webmail client**  
> Custom-built for your aaPanel mail server

---

## 🎯 What is RainLoop?

**RainLoop** - A modern, fast, and simple webmail client. Pre-configured for your mail server at `mailadmin.syscomatic.com`.

### ✨ Why RainLoop?

- ✅ **Simple & Fast** - Clean, modern interface
- ✅ **Easy Setup** - Pre-configured for your server
- ✅ **Customizable** - Built from Dockerfile
- ✅ **Lightweight** - Uses minimal resources
- ✅ **No Complex Config** - Works immediately
- ✅ **Mobile Friendly** - Responsive design

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

**Takes 5 minutes** (includes Docker build time)

---

## 📦 What's Included

- ✅ **Custom Dockerfile** - Optimized RainLoop build
- ✅ **Pre-configured** - Domain settings included
- ✅ **Docker Compose** - Easy deployment
- ✅ **Auto-setup script** - One command installation

---

## ⚙️ Pre-Configured Settings

Already configured for your mail server:

```yaml
Domain: syscomatic.com

IMAP:
  Server: 156.67.216.209
  Port: 993
  Security: SSL

SMTP:
  Server: 156.67.216.209
  Port: 587
  Security: TLS
  Authentication: Enabled
```

**No manual configuration needed!**

---

## 🎯 After Deployment

### **Configure aaPanel Reverse Proxy:**

1. **Login to aaPanel**
2. **Add Website:**
   - Domain: `mailadmin.syscomatic.com`
3. **Set Reverse Proxy:**
   - Target: `http://127.0.0.1:9000`
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

## 🔧 Admin Panel (Optional)

Access admin panel at:
```
URL: https://mailadmin.syscomatic.com/?admin
Username: admin
Password: 12345
```

⚠️ **Change the password immediately!**

In admin panel you can:
- Add more domains
- Customize appearance
- Configure plugins
- Manage settings

---

## 🆚 RainLoop vs Others

| Feature | RainLoop | Roundcube | Snappymail |
|---------|----------|-----------|------------|
| **Setup** | ✅ Easy | ⚠️ Medium | ❌ Complex |
| **Speed** | ✅ Very fast | ⚠️ Medium | ✅ Fast |
| **Interface** | ✅ Modern | ⚠️ Traditional | ✅ Modern |
| **Configuration** | ✅ Pre-configured | ✅ Pre-configured | ❌ Manual |
| **Customization** | ✅ Dockerfile | ❌ Image only | ❌ Image only |
| **Admin Panel** | ✅ Simple | ❌ None | ⚠️ Complex |

**RainLoop is the best balance!**

---

## 🎨 Features

- ✅ Modern, clean interface
- ✅ Mobile responsive
- ✅ Contact management
- ✅ File attachments
- ✅ Multiple identities
- ✅ Folder management
- ✅ Search functionality
- ✅ Keyboard shortcuts
- ✅ Multiple languages
- ✅ Themes support
- ✅ Plugin system

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

# Rebuild
docker-compose build --no-cache
docker-compose up -d

# Update
git pull
docker-compose build
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

## 🔒 Security

- ✅ SSL/TLS encryption
- ✅ Secure IMAP/SMTP
- ✅ Session management
- ✅ XSS protection
- ✅ CSRF protection
- ✅ Admin panel protection

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

**Access admin panel:**
```
https://mailadmin.syscomatic.com/?admin
```

Or edit domain config:
```bash
nano ./rainloop-data/_data_/_default_/domains/syscomatic.com.ini
docker-compose restart
```

---

## 📖 Documentation

- **Official Site:** https://www.rainloop.net/
- **GitHub:** https://github.com/RainLoop/rainloop-webmail
- **Documentation:** https://www.rainloop.net/docs/

---

## ⏱️ Deployment Timeline

1. Upload files: ~1 minute
2. Build Docker image: ~3 minutes
3. Start container: ~1 minute
4. Configure aaPanel: ~2 minutes
5. **Total: ~7 minutes**

---

## 🏗️ Custom Build

This setup uses a **custom Dockerfile** which means:
- ✅ You can customize it
- ✅ Add your own plugins
- ✅ Modify PHP settings
- ✅ Add custom themes
- ✅ Full control

Edit `Dockerfile` to customize!

---

## 📁 Project Structure

```
mailsystem/
├── Dockerfile              # Custom RainLoop build
├── docker-compose.yml      # Docker configuration
├── deploy.sh              # Deployment script
├── rainloop-config.php    # RainLoop settings
├── rainloop-data/         # Data directory (created on first run)
└── README.md              # This file
```

---

## ✅ What's Different from Snappymail

**Snappymail Issues:**
- ❌ Admin panel configuration required
- ❌ localhost:143 error
- ❌ Complex setup

**RainLoop Solution:**
- ✅ Pre-configured domain
- ✅ Works immediately
- ✅ Simple admin panel
- ✅ Custom Dockerfile

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
- Admin panel: `https://mailadmin.syscomatic.com/?admin`

---

**RainLoop - Simple, fast, and works!** 🚀
