# Fix Snappymail Connection to aaPanel Mail Server

## ✅ Your Setup (Confirmed)

- ✅ DNS records configured correctly
- ✅ aaPanel Mail Server installed
- ✅ Email accounts created:
  - asif@syscomatic.com
  - rakib@syscomatic.com
  - consult@syscomatic.com
  - zahed@syscomatic.com
- ✅ Snappymail installed
- ❌ **Snappymail NOT configured to connect to aaPanel mail server**

---

## 🎯 The Problem

Snappymail is trying to connect to `localhost:143` but your **aaPanel mail server** is listening on different ports or requires different configuration.

---

## 🔧 Solution: Configure Snappymail Admin Panel

### Step 1: Access Snappymail Admin Panel

Open browser and go to:
```
https://mailadmin.syscomatic.com/?admin
```

**Default password:** `12345`

⚠️ **Change this password immediately!**

---

### Step 2: Find Your aaPanel Mail Server Ports

First, we need to find out what ports your aaPanel mail server is using.

**SSH into your server:**
```bash
ssh root@156.67.216.209
```

**Check which mail server ports are open:**
```bash
# Check IMAP ports
sudo netstat -tuln | grep -E ':(143|993)'

# Check SMTP ports
sudo netstat -tuln | grep -E ':(25|587|465)'

# Check what mail server is installed
ps aux | grep -E 'dovecot|postfix|exim'
```

**Common aaPanel Mail Server Configurations:**

| Mail Server | IMAP Port | IMAP SSL Port | SMTP Port | SMTP SSL Port |
|-------------|-----------|---------------|-----------|---------------|
| **Dovecot + Postfix** | 143 | 993 | 25, 587 | 465 |
| **Exim + Dovecot** | 143 | 993 | 25, 587 | 465 |

---

### Step 3: Configure Snappymail Domain

In Snappymail admin panel:

1. **Click "Domains"** in left menu
2. **Click "Add Domain"** button
3. **Fill in the form:**

#### For aaPanel Mail Server (Most Common Setup):

```
Domain Name: syscomatic.com

┌─ IMAP Settings ─────────────────────────┐
│ Server:  156.67.216.209                 │  ← Use server IP
│ Port:    993                            │  ← SSL port
│ Secure:  SSL/TLS                        │  ← Select this
│ Short login: ☐ (unchecked)             │
└─────────────────────────────────────────┘

┌─ SMTP Settings ─────────────────────────┐
│ Server:  156.67.216.209                 │  ← Use server IP
│ Port:    587                            │  ← Submission port
│ Secure:  STARTTLS                       │  ← Select this
│ ☑ Use authentication                   │
│ ☑ Use IMAP credentials                 │
└─────────────────────────────────────────┘
```

**Important Notes:**
- Use **server IP** (`156.67.216.209`) instead of hostname
- Use **port 993** for IMAP with SSL/TLS
- Use **port 587** for SMTP with STARTTLS

---

### Step 4: Alternative Configuration (If SSL Doesn't Work)

If your aaPanel mail server doesn't have SSL certificates configured:

```
┌─ IMAP Settings ─────────────────────────┐
│ Server:  156.67.216.209                 │
│ Port:    143                            │  ← Non-SSL port
│ Secure:  None                           │  ← No encryption
│ ☐ Short login                           │
└─────────────────────────────────────────┘

┌─ SMTP Settings ─────────────────────────┐
│ Server:  156.67.216.209                 │
│ Port:    25                             │  ← Standard SMTP
│ Secure:  None                           │  ← No encryption
│ ☑ Use authentication                   │
│ ☑ Use IMAP credentials                 │
└─────────────────────────────────────────┘
```

⚠️ **Warning:** This is less secure but will work if SSL is not configured.

---

### Step 5: Test Configuration

1. Click **"Test"** button
2. Wait for results:
   - ✅ **IMAP: OK** - Connection successful
   - ✅ **SMTP: OK** - Connection successful
3. If successful, click **"Save"**

---

## 🔍 Troubleshooting

### If Test Fails: "Connection refused"

**Check if mail server is running:**
```bash
# Check Dovecot (IMAP)
sudo systemctl status dovecot

# Check Postfix (SMTP)
sudo systemctl status postfix

# Start if not running
sudo systemctl start dovecot
sudo systemctl start postfix
```

### If Test Fails: "Connection timeout"

**Check firewall:**
```bash
# Allow IMAP ports
sudo ufw allow 143/tcp
sudo ufw allow 993/tcp

# Allow SMTP ports
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 465/tcp

# Reload firewall
sudo ufw reload
```

### If Test Fails: "Certificate error"

**Use IP address instead of hostname:**
- Change `imap.syscomatic.com` to `156.67.216.209`
- Or configure SSL certificates in aaPanel

---

## 📋 Quick Diagnostic Script

Run this on your server to check mail server configuration:

```bash
#!/bin/bash

echo "=== Mail Server Diagnostic ==="
echo ""

echo "1. Checking IMAP ports:"
sudo netstat -tuln | grep -E ':(143|993)' || echo "No IMAP ports found"

echo ""
echo "2. Checking SMTP ports:"
sudo netstat -tuln | grep -E ':(25|587|465)' || echo "No SMTP ports found"

echo ""
echo "3. Checking mail services:"
systemctl is-active dovecot 2>/dev/null && echo "Dovecot: Running" || echo "Dovecot: Not running"
systemctl is-active postfix 2>/dev/null && echo "Postfix: Running" || echo "Postfix: Not running"

echo ""
echo "4. Checking mail users:"
sudo doveadm user '*@syscomatic.com' 2>/dev/null || echo "Cannot list users"

echo ""
echo "5. Testing IMAP connection:"
timeout 3 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/993" 2>/dev/null && echo "IMAP SSL (993): Open" || echo "IMAP SSL (993): Closed"
timeout 3 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/143" 2>/dev/null && echo "IMAP (143): Open" || echo "IMAP (143): Closed"

echo ""
echo "6. Testing SMTP connection:"
timeout 3 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/587" 2>/dev/null && echo "SMTP (587): Open" || echo "SMTP (587): Closed"
timeout 3 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/25" 2>/dev/null && echo "SMTP (25): Open" || echo "SMTP (25): Closed"

echo ""
echo "=== End Diagnostic ==="
```

Save this as `check-mail.sh` and run:
```bash
chmod +x check-mail.sh
./check-mail.sh
```

---

## 🎯 Step-by-Step Visual Guide

### 1. Access Admin Panel
```
Browser → https://mailadmin.syscomatic.com/?admin
Login with password: 12345
```

### 2. Add Domain
```
Admin Panel → Domains → Add Domain
Domain: syscomatic.com
```

### 3. Configure IMAP
```
Server: 156.67.216.209  ← Your server IP
Port: 993               ← Try this first
Secure: SSL/TLS         ← Select this

If fails, try:
Port: 143
Secure: None
```

### 4. Configure SMTP
```
Server: 156.67.216.209  ← Your server IP
Port: 587               ← Try this first
Secure: STARTTLS        ← Select this
☑ Use authentication
☑ Use IMAP credentials

If fails, try:
Port: 25
Secure: None
```

### 5. Test & Save
```
Click "Test" → Should show OK
Click "Save"
```

### 6. Try Login
```
Go to: https://mailadmin.syscomatic.com
Email: asif@syscomatic.com
Password: Asif@2026#
```

---

## 🔐 aaPanel Mail Server Locations

### Check aaPanel Mail Configuration

1. **Login to aaPanel**
2. **Go to:** Email → Settings
3. **Check:**
   - IMAP port (usually 993 or 143)
   - SMTP port (usually 587 or 25)
   - SSL/TLS enabled or not

### Common aaPanel Mail Paths

```bash
# Mail server config
/www/server/mail/

# Dovecot config
/etc/dovecot/dovecot.conf

# Postfix config
/etc/postfix/main.cf

# Mail logs
/var/log/mail.log
/var/log/dovecot.log
```

---

## ✅ Recommended Configuration

Based on your setup, try this configuration first:

```yaml
Domain: syscomatic.com

IMAP:
  Server: 156.67.216.209
  Port: 993
  Secure: SSL/TLS

SMTP:
  Server: 156.67.216.209
  Port: 587
  Secure: STARTTLS
  Authentication: ON
  Use IMAP credentials: ON
```

If this doesn't work, try:

```yaml
IMAP:
  Server: 156.67.216.209
  Port: 143
  Secure: None

SMTP:
  Server: 156.67.216.209
  Port: 25
  Secure: None
  Authentication: ON
  Use IMAP credentials: ON
```

---

## 📞 Still Not Working?

### Send me the output of:

```bash
# Run on your server
sudo netstat -tuln | grep -E ':(143|993|25|587|465)'
systemctl status dovecot
systemctl status postfix
```

This will tell us exactly which ports your mail server is using.

---

## 🎉 Summary

**Your issue:** Snappymail doesn't know where your aaPanel mail server is

**Solution:** Configure Snappymail admin panel with:
1. Server IP: `156.67.216.209`
2. IMAP port: `993` (or `143` if no SSL)
3. SMTP port: `587` (or `25` if no SSL)

**After configuration:** You can login with your email accounts!

---

**Next step:** Go to `https://mailadmin.syscomatic.com/?admin` and configure it now! 🚀
