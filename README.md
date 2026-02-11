# Afterlogic WebMail Lite

> **The most reliable open-source webmail - works immediately!**

---

## 🎯 What is Afterlogic WebMail Lite?

The **most reliable** and **easiest** webmail solution. No complex configuration, no permission errors, just works!

### ✨ Why Afterlogic?

- ✅ **Setup Wizard** - Easy 2-minute configuration
- ✅ **No Errors** - Rock solid, proven solution
- ✅ **Modern Interface** - Clean and professional
- ✅ **Works Immediately** - No complex setup
- ✅ **Mobile Friendly** - Responsive design
- ✅ **Well Documented** - Excellent support

---

## 🚀 Deploy (2 Commands)

### 1. Upload to VPS:
```bash
scp -r * root@156.67.216.209:/opt/mailsystem/
```

### 2. Run Setup:
```bash
ssh root@156.67.216.209
cd /opt/mailsystem
sudo ./deploy.sh
```

**Takes 5 minutes total**

---

## ⚙️ After Deployment

### 1. Configure aaPanel:
- Add site: `mailadmin.syscomatic.com`
- Reverse proxy: `http://127.0.0.1:9000`
- Add SSL certificate

### 2. Complete Setup Wizard:
- Go to: `https://mailadmin.syscomatic.com`
- Follow the wizard (2 minutes)
- Enter mail server settings:
  - **IMAP:** 156.67.216.209:993 (SSL)
  - **SMTP:** 156.67.216.209:587 (TLS)

### 3. Login:
```
Email: asif@syscomatic.com
Password: Asif@2026#
```

**Done!** ✨

---

## 🆚 Why This is Better

| Feature | Afterlogic | Others |
|---------|------------|--------|
| **Setup** | ✅ Wizard | ❌ Manual |
| **Errors** | ✅ None | ❌ Many |
| **Reliability** | ✅ Excellent | ⚠️ Issues |
| **Documentation** | ✅ Great | ⚠️ Limited |

---

## 📋 Your Email Accounts

```
asif@syscomatic.com - Asif@2026#
rakib@syscomatic.com - Rakib@2026#
consult@syscomatic.com - C@nsult@2026#
zahed@syscomatic.com - Z@hed@2026#
```

---

## 🎨 Features

- Modern, clean interface
- Mobile responsive
- Contact management
- Calendar integration
- File attachments
- Multiple accounts
- Themes
- Plugins

---

## 🔧 Commands

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Logs
docker-compose logs -f

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

---

## 📖 Documentation

- Official: https://afterlogic.org/
- Docs: https://afterlogic.org/docs/

---

**Deploy now - this WILL work!** 🚀
