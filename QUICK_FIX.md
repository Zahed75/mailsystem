# Quick Fix - Port Conflict Resolved

## ✅ Issue Fixed

Port 8080 was already in use. Changed to port 8888.

---

## 🚀 Run These Commands on Your Server

```bash
# 1. Stop everything
docker stop $(docker ps -aq) 2>/dev/null || true

# 2. Pull latest changes
cd /www/wwwroot/mailadmin.syscomatic.com/mailsystem
git pull

# 3. Start Roundcube
docker-compose up -d
```

---

## ⚙️ Update aaPanel Reverse Proxy

Change reverse proxy target to:
```
http://127.0.0.1:8888
```

(Changed from 8080 to 8888)

---

## ✅ After Running

Access: `https://mailadmin.syscomatic.com`

Login with:
```
Email: asif@syscomatic.com
Password: Asif@2026#
```

---

**Run the commands above now!** 🚀
