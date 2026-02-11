# Troubleshooting Guide

## Common Issues and Solutions

### 1. Authentication Error When Sending Emails

**Symptoms:**
- "Authentication failed" error
- "SMTP Error: Could not authenticate"
- Emails not sending

**Solutions:**

#### A. Check SMTP Configuration in Snappymail Admin

1. Access admin panel: `http://your-server:8888/?admin`
2. Go to **Domains** → Select your domain
3. Verify SMTP settings:
   ```
   SMTP Server: smtp.syscomatic.com
   Port: 587
   Secure: STARTTLS (or TLS)
   Authentication: ON
   Use IMAP credentials: ON
   ```

#### B. Test SMTP Connection Manually

```bash
# Run the test script
chmod +x test-smtp.sh
./test-smtp.sh
```

Or manually test:

```bash
# Test SMTP connection
openssl s_client -starttls smtp -connect smtp.syscomatic.com:587

# After connection, type:
EHLO test
AUTH LOGIN
# Then enter base64 encoded username and password
```

#### C. Common SMTP Port Issues

| Port | Encryption | Use Case |
|------|------------|----------|
| 25   | None/STARTTLS | Server-to-server (often blocked by ISPs) |
| 465  | SSL/TLS | Legacy, implicit SSL |
| 587  | STARTTLS | **Recommended** for mail clients |

**Fix:** Always use port **587** with **STARTTLS** for Snappymail.

#### D. Check Mail Server Logs

On your mail server (156.67.216.209):

```bash
# Check mail logs
tail -f /var/log/mail.log
# or
tail -f /var/log/maillog

# Check for authentication failures
grep "authentication failed" /var/log/mail.log
```

### 2. Cannot Receive Emails (IMAP Issues)

**Solutions:**

#### A. Verify IMAP Settings

```
IMAP Server: imap.syscomatic.com
Port: 993
Secure: SSL/TLS
```

#### B. Test IMAP Connection

```bash
# Test IMAP SSL connection
openssl s_client -connect imap.syscomatic.com:993

# After connection, type:
a1 LOGIN username@syscomatic.com password
a2 LIST "" "*"
a3 LOGOUT
```

#### C. Check Firewall Rules

```bash
# On your VPS server
sudo ufw status

# Ensure these ports are open:
sudo ufw allow 993/tcp  # IMAPS
sudo ufw allow 587/tcp  # SMTP submission
sudo ufw allow 25/tcp   # SMTP (if needed)
```

### 3. Snappymail Not Loading

**Solutions:**

#### A. Check Docker Container Status

```bash
docker-compose ps
docker-compose logs snappymail
```

#### B. Restart Container

```bash
docker-compose restart
# or
docker-compose down && docker-compose up -d
```

#### C. Check Port Conflicts

```bash
# See what's using port 8888
sudo lsof -i :8888
sudo netstat -tulpn | grep 8888
```

### 4. SSL/TLS Certificate Issues

**Solutions:**

#### A. Get Let's Encrypt Certificate

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d mailadmin.syscomatic.com

# Auto-renewal test
sudo certbot renew --dry-run
```

#### B. Manual Certificate Installation

```bash
# Create SSL directory
mkdir -p /etc/nginx/ssl

# Copy your certificates
cp fullchain.pem /etc/nginx/ssl/
cp privkey.pem /etc/nginx/ssl/

# Set permissions
chmod 600 /etc/nginx/ssl/privkey.pem
chmod 644 /etc/nginx/ssl/fullchain.pem
```

### 5. Emails Going to Spam

**Solutions:**

#### A. Verify DNS Records (Already Configured)

Your DNS records look good! Verify they're active:

```bash
# Check SPF
dig +short TXT syscomatic.com

# Check DKIM
dig +short TXT default._domainkey.syscomatic.com

# Check DMARC
dig +short TXT _dmarc.syscomatic.com
```

#### B. Test Email Deliverability

Send a test email to:
- mail-tester.com
- mxtoolbox.com/deliverability

#### C. Check Reverse DNS (PTR Record)

```bash
# Check reverse DNS for your IP
dig +short -x 156.67.216.209
```

Should return: `mail.syscomatic.com` or similar

Contact your VPS provider to set up PTR record if not configured.

### 6. Attachment Upload Issues

**Solutions:**

#### A. Increase PHP Upload Limits

Create `php.ini` configuration:

```bash
# Add to docker-compose.yml
volumes:
  - ./php-custom.ini:/usr/local/etc/php/conf.d/custom.ini
```

Create `php-custom.ini`:
```ini
upload_max_filesize = 50M
post_max_size = 50M
max_execution_time = 300
```

#### B. Increase Nginx Client Body Size

Already configured in `nginx.conf`:
```nginx
client_max_body_size 50M;
```

### 7. Mobile Access Issues

**Solutions:**

#### A. Enable Mobile-Friendly Settings

In Snappymail admin:
1. Go to **Settings** → **Interface**
2. Enable "Mobile version"
3. Set "Auto-detect mobile devices"

#### B. Add to Home Screen (iOS/Android)

**iOS:**
1. Open Safari → mailadmin.syscomatic.com
2. Tap Share → Add to Home Screen

**Android:**
1. Open Chrome → mailadmin.syscomatic.com
2. Menu → Add to Home Screen

### 8. Performance Issues

**Solutions:**

#### A. Enable Caching

In Snappymail admin:
1. Go to **Settings** → **Caching**
2. Enable all caching options

#### B. Optimize Docker

```bash
# Limit container resources
docker-compose.yml:
  services:
    snappymail:
      deploy:
        resources:
          limits:
            cpus: '1.0'
            memory: 512M
```

#### C. Use Redis for Sessions (Advanced)

Add Redis to `docker-compose.yml`:
```yaml
services:
  redis:
    image: redis:alpine
    restart: always
```

### 9. Lost Admin Password

**Solutions:**

```bash
# Stop container
docker-compose down

# Remove admin password file
rm -f ./data/_data_/_default_/admin_password.txt

# Restart - default password will be '12345'
docker-compose up -d
```

### 10. Debugging Tools

#### A. Enable Debug Mode

In Snappymail admin:
1. Go to **Settings** → **Logs**
2. Enable "Enable logging"
3. Set log level to "Debug"

View logs:
```bash
docker-compose logs -f snappymail
```

#### B. Check Browser Console

Open browser DevTools (F12) and check:
- Console for JavaScript errors
- Network tab for failed requests

#### C. Test Email Sending via Command Line

```bash
# Install swaks (Swiss Army Knife for SMTP)
sudo apt install swaks

# Test sending email
swaks --to recipient@example.com \
      --from sender@syscomatic.com \
      --server smtp.syscomatic.com:587 \
      --auth LOGIN \
      --auth-user sender@syscomatic.com \
      --auth-password 'yourpassword' \
      --tls
```

## Getting Help

If issues persist:

1. **Check Snappymail logs:**
   ```bash
   docker-compose logs -f
   ```

2. **Check mail server logs** on your VPS

3. **Community support:**
   - Snappymail Forum: https://forum.snappymail.eu/
   - GitHub Issues: https://github.com/the-djmaze/snappymail/issues

4. **Professional support:**
   - Consider hiring a mail server administrator
   - Check with your VPS provider's support

## Quick Diagnostic Commands

```bash
# All-in-one diagnostic
echo "=== Docker Status ==="
docker-compose ps

echo "=== Container Logs ==="
docker-compose logs --tail=50 snappymail

echo "=== Port Check ==="
sudo netstat -tulpn | grep -E ':(587|993|8888)'

echo "=== DNS Records ==="
dig +short MX syscomatic.com
dig +short TXT syscomatic.com

echo "=== Nginx Status ==="
sudo systemctl status nginx

echo "=== SSL Certificate ==="
echo | openssl s_client -connect mailadmin.syscomatic.com:443 2>/dev/null | openssl x509 -noout -dates
```

Save this as `diagnose.sh` and run when troubleshooting.
