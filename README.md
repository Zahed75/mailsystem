# SOGo Webmail

> **Enterprise-grade webmail - Mozilla Thunderbird's web companion**

## 🎯 What is SOGo?

**SOGo** - Enterprise-grade groupware server with a modern web interface. Used by thousands of organizations worldwide. **This is what Mozilla recommends as Thunderbird's web companion!**

### ✨ Why SOGo?

- ✅ **Enterprise-Grade** - Rock solid, proven
- ✅ **Thunderbird Compatible** - Mozilla's choice
- ✅ **Pre-Configured** - Ready to use
- ✅ **No Errors** - Professional solution
- ✅ **Full-Featured** - Email, Calendar, Contacts

---

## 🚀 Deploy (2 Commands)

### 1. Upload:
```bash
scp -r * root@156.67.216.209:/opt/mailsystem/
```

### 2. Deploy:
```bash
ssh root@156.67.216.209
cd /opt/mailsystem
sudo ./deploy.sh
```

---

## ⚙️ After Deployment

### 1. Configure aaPanel:
- Site: `mailadmin.syscomatic.com`
- Proxy: `http://127.0.0.1:9000`
- Add SSL

### 2. Login:
```
URL: https://mailadmin.syscomatic.com
Email: asif@syscomatic.com
Password: Asif@2026#
```

---

## 📋 Email Accounts

```
asif@syscomatic.com - Asif@2026#
rakib@syscomatic.com - Rakib@2026#
consult@syscomatic.com - C@nsult@2026#
zahed@syscomatic.com - Z@hed@2026#
```

---

## 🎨 Features

- Modern web interface
- Email, Calendar, Contacts
- Mobile responsive
- Thunderbird sync
- ActiveSync support
- CardDAV/CalDAV

---

## 🔧 Commands

```bash
docker-compose up -d    # Start
docker-compose down     # Stop
docker-compose logs -f  # Logs
```

---

**Deploy now!** 🚀
