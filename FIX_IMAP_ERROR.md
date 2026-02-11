# Snappymail Configuration Fix

## ❌ Error: "Can't connect to host tcp://localhost:143"

### 🔍 What This Means

Snappymail is trying to connect to:
- ❌ **localhost:143** (wrong - no IMAP server on localhost)

It should connect to:
- ✅ **imap.syscomatic.com:993** (your actual mail server)

### 🎯 Root Cause

**The admin panel is not configured yet!** You need to:
1. Access admin panel
2. Add your domain
3. Configure IMAP/SMTP settings

---

## ✅ Step-by-Step Fix

### Step 1: Access Admin Panel

```
URL: https://mailadmin.syscomatic.com/?admin
Default Password: 12345
```

⚠️ **Important:** Change this password immediately after login!

### Step 2: Configure Domain

1. **Login to admin panel**
2. **Go to:** Domains → Click "Add Domain"
3. **Fill in the form:**

```
Domain Name: syscomatic.com
```

### Step 3: Configure IMAP Settings

In the domain configuration:

```
IMAP Server: imap.syscomatic.com
IMAP Port: 993
IMAP Secure: SSL/TLS
```

**Important:** Use **SSL/TLS**, not STARTTLS for port 993

### Step 4: Configure SMTP Settings

```
SMTP Server: smtp.syscomatic.com
SMTP Port: 587
SMTP Secure: STARTTLS
SMTP Authentication: ON (checked)
Use IMAP credentials: ON (checked)
```

**Important:** Use **STARTTLS** for port 587

### Step 5: Test Configuration

1. Click **"Test"** button in admin panel
2. Should show: ✅ IMAP: Connected, ✅ SMTP: Connected
3. Click **"Save"**

### Step 6: Try Login Again

Now go to: `https://mailadmin.syscomatic.com`

Login with:
```
Email: your-email@syscomatic.com
Password: your-email-password
```

---

## 📸 Visual Guide

### Admin Panel Configuration

```
┌─────────────────────────────────────────────────────────┐
│ Snappymail Admin Panel - Add Domain                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Domain Name: [syscomatic.com                        ]   │
│                                                          │
│ ┌─ IMAP Settings ─────────────────────────────────────┐ │
│ │ Server:  [imap.syscomatic.com                    ] │ │
│ │ Port:    [993                                    ] │ │
│ │ Secure:  [●] SSL/TLS  [ ] STARTTLS  [ ] None      │ │
│ └──────────────────────────────────────────────────────┘ │
│                                                          │
│ ┌─ SMTP Settings ─────────────────────────────────────┐ │
│ │ Server:  [smtp.syscomatic.com                    ] │ │
│ │ Port:    [587                                    ] │ │
│ │ Secure:  [ ] SSL/TLS  [●] STARTTLS  [ ] None      │ │
│ │ [✓] Use authentication                            │ │
│ │ [✓] Use IMAP credentials                          │ │
│ └──────────────────────────────────────────────────────┘ │
│                                                          │
│ [Test]  [Save]  [Cancel]                                │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 Detailed Configuration

### IMAP Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| **Server** | `imap.syscomatic.com` | Your IMAP server |
| **Port** | `993` | IMAPS (secure) |
| **Security** | `SSL/TLS` | Full encryption |
| **Short Login** | ❌ Unchecked | Use full email |

### SMTP Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| **Server** | `smtp.syscomatic.com` | Your SMTP server |
| **Port** | `587` | Submission port |
| **Security** | `STARTTLS` | Upgrade to TLS |
| **Authentication** | ✅ Checked | Required |
| **Use IMAP credentials** | ✅ Checked | Same as email login |

---

## 🧪 Test IMAP/SMTP Connection

Before configuring Snappymail, test your mail server:

```bash
# Test IMAP connection
openssl s_client -connect imap.syscomatic.com:993

# Test SMTP connection
openssl s_client -starttls smtp -connect smtp.syscomatic.com:587
```

Or use the test script:
```bash
./test-smtp.sh
```

---

## ❓ Common Mistakes

### ❌ Wrong: Using localhost
```
IMAP Server: localhost  ← WRONG!
```

### ✅ Correct: Using actual server
```
IMAP Server: imap.syscomatic.com  ← CORRECT!
```

### ❌ Wrong: Port 143 without SSL
```
IMAP Port: 143
IMAP Secure: None  ← WRONG! Insecure
```

### ✅ Correct: Port 993 with SSL
```
IMAP Port: 993
IMAP Secure: SSL/TLS  ← CORRECT!
```

### ❌ Wrong: SMTP port 465
```
SMTP Port: 465
SMTP Secure: SSL/TLS  ← OLD/DEPRECATED
```

### ✅ Correct: SMTP port 587
```
SMTP Port: 587
SMTP Secure: STARTTLS  ← CORRECT!
```

---

## 🔍 Troubleshooting

### Error: "Can't connect to host"

**Cause:** Wrong server address or port

**Fix:**
1. Verify IMAP server: `ping imap.syscomatic.com`
2. Check port is open: `telnet imap.syscomatic.com 993`
3. Ensure firewall allows port 993

### Error: "Authentication failed"

**Cause:** Wrong credentials or auth not enabled

**Fix:**
1. Verify email password is correct
2. Ensure "Use authentication" is checked
3. Ensure "Use IMAP credentials" is checked

### Error: "Connection timeout"

**Cause:** Firewall blocking connection

**Fix:**
```bash
# On your mail server
sudo ufw allow 993/tcp
sudo ufw allow 587/tcp
```

### Error: "Certificate error"

**Cause:** SSL certificate mismatch

**Fix:**
1. Ensure server hostname matches certificate
2. Use correct server name (imap.syscomatic.com, not IP)
3. Check certificate: `openssl s_client -connect imap.syscomatic.com:993`

---

## 📋 Quick Checklist

Before trying to login:

- [ ] Admin panel accessed: `https://mailadmin.syscomatic.com/?admin`
- [ ] Domain added: `syscomatic.com`
- [ ] IMAP configured: `imap.syscomatic.com:993` (SSL/TLS)
- [ ] SMTP configured: `smtp.syscomatic.com:587` (STARTTLS)
- [ ] "Use authentication" checked
- [ ] "Use IMAP credentials" checked
- [ ] Configuration tested (Test button)
- [ ] Configuration saved

---

## 🎯 Complete Configuration Example

### Admin Panel → Domains → Add Domain

```yaml
Domain: syscomatic.com

IMAP:
  Server: imap.syscomatic.com
  Port: 993
  Secure: SSL/TLS
  Short login: No

SMTP:
  Server: smtp.syscomatic.com
  Port: 587
  Secure: STARTTLS
  Authentication: Yes
  Use IMAP credentials: Yes
  
Advanced:
  White list: (leave empty)
```

Click **Test** → Should show:
- ✅ IMAP: OK
- ✅ SMTP: OK

Click **Save**

---

## 🔐 Security Settings (Optional)

In admin panel, you can also configure:

### Enable 2FA
1. Go to: Security
2. Enable "Two-factor authentication"

### Change Admin Password
1. Go to: Security → Admin password
2. Change from default `12345`

### Enable Logging
1. Go to: Logs
2. Enable logging for troubleshooting

---

## 📞 Still Having Issues?

### Check Mail Server

```bash
# Verify IMAP is running
sudo netstat -tuln | grep 993

# Verify SMTP is running
sudo netstat -tuln | grep 587

# Check mail server logs
sudo tail -f /var/log/mail.log
```

### Check Snappymail Logs

```bash
# Docker logs
docker-compose logs -f snappymail

# Or in admin panel
# Go to: Logs → View logs
```

### Test with Different Client

Try connecting with Thunderbird or another email client to verify your mail server works.

---

## 🎉 After Configuration

Once configured, users can login with:

```
URL: https://mailadmin.syscomatic.com
Email: username@syscomatic.com
Password: their-email-password
```

**No admin panel needed for regular users!**

---

## 📖 Related Documentation

- **TROUBLESHOOTING.md** - Section 1: Authentication Errors
- **test-smtp.sh** - Test SMTP/IMAP connectivity
- **AAPANEL_SETUP.md** - Complete aaPanel setup

---

## 🚀 Quick Fix Summary

1. **Access:** `https://mailadmin.syscomatic.com/?admin`
2. **Login:** Password `12345`
3. **Add Domain:** `syscomatic.com`
4. **Configure IMAP:** `imap.syscomatic.com:993` (SSL/TLS)
5. **Configure SMTP:** `smtp.syscomatic.com:587` (STARTTLS)
6. **Enable:** "Use authentication" + "Use IMAP credentials"
7. **Test & Save**
8. **Try login again!**

---

**The error will disappear once you configure the domain in admin panel!** ✨
