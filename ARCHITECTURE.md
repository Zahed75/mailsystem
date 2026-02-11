# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTPS (443)
                             ▼
                    ┌────────────────┐
                    │  Cloudflare    │
                    │  DNS Records   │
                    └────────┬───────┘
                             │
                             │ mailadmin.syscomatic.com
                             │ → 156.67.216.209
                             ▼
┌────────────────────────────────────────────────────────────────┐
│                    VPS Server (156.67.216.209)                  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    Nginx (Port 80/443)                    │  │
│  │  - SSL/TLS Termination                                    │  │
│  │  - Reverse Proxy                                          │  │
│  │  - Security Headers                                       │  │
│  └────────────────────────┬─────────────────────────────────┘  │
│                            │ HTTP (localhost:8888)              │
│                            ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Docker Container: Snappymail                 │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │         Snappymail Web Interface                   │  │  │
│  │  │  - User Authentication                             │  │  │
│  │  │  - Email Composition                               │  │  │
│  │  │  - Admin Panel                                     │  │  │
│  │  └────────┬───────────────────────┬───────────────────┘  │  │
│  │           │                       │                       │  │
│  │           │ IMAP (993)           │ SMTP (587)           │  │
│  │           ▼                       ▼                       │  │
│  │  ┌─────────────────┐    ┌─────────────────┐             │  │
│  │  │  IMAP Client    │    │  SMTP Client    │             │  │
│  │  └────────┬────────┘    └────────┬────────┘             │  │
│  └───────────┼──────────────────────┼──────────────────────┘  │
│              │                      │                          │
│              │                      │                          │
│  ┌───────────▼──────────────────────▼──────────────────────┐  │
│  │              Persistent Volume: ./data                   │  │
│  │  - User Settings                                         │  │
│  │  - Cache                                                 │  │
│  │  - Configurations                                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
                             │                      │
                             │ IMAP (993)          │ SMTP (587)
                             ▼                      ▼
┌────────────────────────────────────────────────────────────────┐
│                    Mail Server Infrastructure                   │
│                                                                  │
│  ┌──────────────────────┐        ┌──────────────────────┐      │
│  │  imap.syscomatic.com │        │  smtp.syscomatic.com │      │
│  │  Port: 993 (SSL)     │        │  Port: 587 (TLS)     │      │
│  └──────────────────────┘        └──────────────────────┘      │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Mail Storage & Processing                    │  │
│  │  - User Mailboxes                                        │  │
│  │  - Spam Filtering                                        │  │
│  │  - Virus Scanning                                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. User Accesses Webmail

```
User Browser
    │
    │ HTTPS Request
    ▼
Cloudflare DNS (mailadmin.syscomatic.com → 156.67.216.209)
    │
    ▼
Nginx (SSL Termination)
    │
    │ HTTP (localhost)
    ▼
Snappymail Container (Port 8888)
    │
    │ Renders Login Page
    ▼
User Browser (Login Form)
```

### 2. User Logs In

```
User enters credentials
    │
    ▼
Snappymail validates format
    │
    ▼
IMAP Connection to imap.syscomatic.com:993
    │
    ├─ Success → Load inbox
    │
    └─ Failure → Show error
```

### 3. User Sends Email

```
User composes email
    │
    ▼
Snappymail prepares message
    │
    ▼
SMTP Connection to smtp.syscomatic.com:587
    │
    ├─ STARTTLS negotiation
    │
    ├─ Authentication (user credentials)
    │
    ├─ Send message
    │
    └─ Confirmation → User notified
```

### 4. User Receives Email

```
External sender → Mail Server (smtp.syscomatic.com)
    │
    ▼
Mail processed (spam check, virus scan)
    │
    ▼
Stored in user's mailbox
    │
    ▼
User refreshes Snappymail
    │
    ▼
IMAP fetch from imap.syscomatic.com:993
    │
    ▼
New email displayed
```

## Network Ports

| Port | Protocol | Purpose | Exposed |
|------|----------|---------|---------|
| 80 | HTTP | Redirect to HTTPS | Public |
| 443 | HTTPS | Web interface | Public |
| 8888 | HTTP | Snappymail container | Localhost only |
| 587 | SMTP | Email sending (STARTTLS) | To mail server |
| 993 | IMAPS | Email receiving (SSL) | To mail server |

## DNS Records Flow

```
User types: mailadmin.syscomatic.com
    │
    ▼
DNS Lookup
    │
    ├─ A Record: mailadmin → 156.67.216.209
    │
    └─ Browser connects to 156.67.216.209:443

Email sent to: user@syscomatic.com
    │
    ▼
MX Lookup
    │
    ├─ MX Record: syscomatic.com → mail.syscomatic.com
    │
    ├─ A Record: mail → 156.67.216.209
    │
    └─ Sending server connects to 156.67.216.209:25

SPF Check
    │
    ├─ TXT Record: v=spf1 a mx ip4:156.67.216.209 ~all
    │
    └─ Validates sender IP

DKIM Check
    │
    ├─ TXT Record: default._domainkey
    │
    └─ Validates email signature

DMARC Check
    │
    ├─ TXT Record: _dmarc
    │
    └─ Policy: quarantine failed emails
```

## Docker Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Host                           │
│                                                           │
│  ┌────────────────────────────────────────────────────┐ │
│  │         Docker Network: mailnet (bridge)           │ │
│  │                                                     │ │
│  │  ┌──────────────────────────────────────────────┐ │ │
│  │  │  Container: snappymail_webmail               │ │ │
│  │  │                                               │ │ │
│  │  │  Image: djmaze/snappymail:latest            │ │ │
│  │  │                                               │ │ │
│  │  │  Volumes:                                     │ │ │
│  │  │  - ./data → /var/lib/snappymail             │ │ │
│  │  │                                               │ │ │
│  │  │  Environment:                                 │ │ │
│  │  │  - TZ=Asia/Dhaka                             │ │ │
│  │  │                                               │ │ │
│  │  │  Ports:                                       │ │ │
│  │  │  - 127.0.0.1:8888 → 8888                     │ │ │
│  │  │                                               │ │ │
│  │  │  Health Check:                                │ │ │
│  │  │  - curl http://localhost:8888                │ │ │
│  │  │  - Every 30s                                  │ │ │
│  │  └──────────────────────────────────────────────┘ │ │
│  │                                                     │ │
│  └────────────────────────────────────────────────────┘ │
│                                                           │
│  ┌────────────────────────────────────────────────────┐ │
│  │         Host Volume: ./data                        │ │
│  │  - Persistent storage                              │ │
│  │  - Survives container restarts                     │ │
│  │  - Contains user settings, cache                   │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Security Layers

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Cloudflare                                     │
│  - DDoS Protection                                       │
│  - DNS Management                                        │
│  - Optional: WAF, Rate Limiting                          │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│  Layer 2: Nginx                                          │
│  - SSL/TLS Encryption (HTTPS)                           │
│  - Security Headers (HSTS, X-Frame-Options, etc.)       │
│  - Rate Limiting                                         │
│  - Request Filtering                                     │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│  Layer 3: Docker Isolation                               │
│  - Container Isolation                                   │
│  - Network Isolation (bridge network)                    │
│  - Resource Limits                                       │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│  Layer 4: Snappymail                                     │
│  - User Authentication                                   │
│  - Session Management                                    │
│  - 2FA (optional)                                        │
│  - XSS Protection                                        │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│  Layer 5: Mail Server                                    │
│  - IMAP/SMTP Authentication                             │
│  - Encrypted Connections (SSL/TLS)                      │
│  - SPF/DKIM/DMARC Validation                            │
└─────────────────────────────────────────────────────────┘
```

## Deployment Workflow

```
┌─────────────────┐
│  Local Machine  │
│                 │
│  mailsystem/    │
│  - All files    │
└────────┬────────┘
         │
         │ scp/rsync
         ▼
┌─────────────────────────────────────────┐
│  VPS Server (156.67.216.209)            │
│                                          │
│  /opt/mailsystem/                       │
│  ┌────────────────────────────────────┐ │
│  │  1. Run deploy.sh                  │ │
│  │     ├─ Install Docker              │ │
│  │     ├─ Install Docker Compose      │ │
│  │     ├─ Create directories          │ │
│  │     ├─ Pull images                 │ │
│  │     └─ Start containers            │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  2. Configure Nginx                │ │
│  │     ├─ Copy nginx.conf             │ │
│  │     ├─ Get SSL cert (certbot)      │ │
│  │     └─ Restart Nginx               │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  3. Configure Snappymail           │ │
│  │     ├─ Access admin panel          │ │
│  │     ├─ Change password             │ │
│  │     ├─ Add domain                  │ │
│  │     └─ Configure IMAP/SMTP         │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  4. Test & Verify                  │ │
│  │     ├─ Test login                  │ │
│  │     ├─ Send test email             │ │
│  │     ├─ Receive test email          │ │
│  │     └─ Check mobile access         │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
         │
         │ Success!
         ▼
┌─────────────────────────────────────────┐
│  Production Ready                        │
│  https://mailadmin.syscomatic.com       │
└─────────────────────────────────────────┘
```

## Backup Strategy

```
┌─────────────────────────────────────────┐
│  Automated Backup (Recommended)          │
│                                          │
│  Cron Job (daily at 2 AM):              │
│  ┌────────────────────────────────────┐ │
│  │  0 2 * * * /opt/mailsystem/backup.sh│ │
│  └────────────────────────────────────┘ │
│                                          │
│  Backup Script:                          │
│  1. Stop container (optional)            │
│  2. tar -czf data-backup-DATE.tar.gz    │
│  3. Upload to remote storage             │
│  4. Keep last 7 days                     │
│  5. Restart container                    │
└─────────────────────────────────────────┘
```

## Monitoring

```
┌─────────────────────────────────────────┐
│  Health Checks                           │
│                                          │
│  Docker Health Check (every 30s):       │
│  curl http://localhost:8888             │
│                                          │
│  External Monitoring:                    │
│  - UptimeRobot                          │
│  - Pingdom                              │
│  - Custom script                        │
│                                          │
│  Logs:                                   │
│  - docker-compose logs -f               │
│  - /var/log/nginx/access.log            │
│  - /var/log/nginx/error.log             │
└─────────────────────────────────────────┘
```

## Scaling Options

```
┌─────────────────────────────────────────┐
│  Single Server (Current)                 │
│  - Good for: < 100 users                │
│  - Resources: 1GB RAM, 1 CPU            │
└─────────────────────────────────────────┘
         │
         │ Need more capacity?
         ▼
┌─────────────────────────────────────────┐
│  Load Balanced (Future)                  │
│                                          │
│  ┌─────────────┐                        │
│  │ Load Balancer│                        │
│  └──────┬───────┘                        │
│         │                                 │
│    ┌────┴────┐                           │
│    │         │                           │
│    ▼         ▼                           │
│  ┌───┐     ┌───┐                        │
│  │ S1│     │ S2│  Snappymail instances  │
│  └───┘     └───┘                        │
│    │         │                           │
│    └────┬────┘                           │
│         │                                 │
│         ▼                                 │
│  ┌─────────────┐                        │
│  │ Shared Data │  (NFS/S3)              │
│  └─────────────┘                        │
└─────────────────────────────────────────┘
```

---

This architecture provides:
- ✅ High security (multiple layers)
- ✅ Easy deployment (Docker)
- ✅ Scalability (can add more containers)
- ✅ Reliability (health checks, backups)
- ✅ Performance (Nginx caching, Docker)
