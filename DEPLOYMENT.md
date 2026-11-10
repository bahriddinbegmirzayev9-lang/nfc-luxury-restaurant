# 🚀 PRODUCTION DEPLOYMENT GUIDE
## NFC Luxury Restaurant - Deploy to Production

---

## 📦 DEPLOYMENT CHECKLIST

### Pre-Deployment:
- [ ] Backend tested locally
- [ ] Database schema finalized
- [ ] Client built successfully
- [ ] Environment variables configured
- [ ] SSL certificates ready
- [ ] Domain name purchased
- [ ] Payment gateway configured (optional)

---

## 1️⃣ DATABASE DEPLOYMENT

### Option A: DigitalOcean Managed PostgreSQL (Recommended)

**Setup:**
```bash
# 1. Create account at digitalocean.com
# 2. Create Managed PostgreSQL Database
# 3. Get connection string:
#    postgresql://user:password@host:port/database?sslmode=require
```

**Migrate Schema:**
```bash
# Connect to remote database
psql "postgresql://user:password@host:port/database?sslmode=require" \
  -f /home/hacker/nfc-luxury-restaurant/database/schema.sql
```

**Cost:** ~$15/month for basic tier

### Option B: Railway PostgreSQL (Easy)

**Setup:**
```bash
# 1. Go to railway.app
# 2. Create new project → PostgreSQL
# 3. Get DATABASE_URL from variables
```

**Cost:** Free tier available, then ~$5/month

### Option C: Supabase (Free tier)

**Setup:**
```bash
# 1. Go to supabase.com
# 2. Create new project
# 3. Copy connection string
# 4. Run SQL in SQL Editor
```

**Cost:** Free up to 500MB, then $25/month

---

## 2️⃣ BACKEND API DEPLOYMENT

### Option A: Railway (Easiest - Recommended for you!)

**Steps:**
```bash
# 1. Go to railway.app
# 2. "New Project" → "Deploy from GitHub repo"
# 3. Connect your GitHub
# 4. Select nfc-luxury-restaurant/backend
# 5. Add environment variables
```

**Environment Variables (Railway):**
```env
PORT=5000
NODE_ENV=production
DB_HOST=your-db-host
DB_PORT=5432
DB_NAME=nfc_luxury_restaurant
DB_USER=postgres
DB_PASSWORD=your-password
JWT_SECRET=super-secret-key-change-this-12345
CORS_ORIGIN=https://your-domain.vercel.app
```

**Cost:** Free $5 credit/month, then pay-as-you-go

### Option B: DigitalOcean App Platform

**Steps:**
```bash
# 1. Create Droplet or use App Platform
# 2. Upload backend folder
# 3. Install Node.js
# 4. Configure nginx
# 5. Use PM2 for process management
```

**Setup on Droplet:**
```bash
# SSH to server
ssh root@your-server-ip

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
npm install -g pm2

# Clone repo
git clone your-repo-url
cd nfc-luxury-restaurant/backend

# Install dependencies
npm install --production

# Start with PM2
pm2 start server.js --name nfc-restaurant
pm2 save
pm2 startup
```

**Cost:** $6-12/month for droplet

### Option C: Render

**Steps:**
```bash
# 1. Go to render.com
# 2. "New Web Service"
# 3. Connect GitHub repo
# 4. Select backend folder
# 5. Set build command: npm install
# 6. Set start command: npm start
```

**Cost:** Free tier available (slow), $7/month for faster

---

## 3️⃣ CLIENT WEB APP DEPLOYMENT

### Option A: Vercel (Recommended - Best for React!)

**Steps:**
```bash
# 1. Go to vercel.com
# 2. "Add New Project"
# 3. Import from GitHub
# 4. Select client folder
# 5. Framework: Vite
# 6. Build: npm run build
# 7. Output: dist
# 8. Deploy!
```

**Environment Variables (Vercel):**
```env
VITE_API_URL=https://your-backend.railway.app/api/v1
VITE_SOCKET_URL=https://your-backend.railway.app
```

**Custom Domain:**
```bash
# 1. Buy domain (namecheap.com, godaddy.com)
# 2. Add domain in Vercel dashboard
# 3. Update DNS records (Vercel provides instructions)
# Example: restaurant-nfc.com
```

**Cost:** FREE! (Hobby plan)

### Option B: Netlify

**Steps:**
```bash
# 1. Go to netlify.com
# 2. "Add new site" → "Import from Git"
# 3. Build command: npm run build
# 4. Publish directory: dist
```

**Cost:** FREE!

---

## 4️⃣ ADMIN DESKTOP APP DISTRIBUTION

### Build EXE for Windows:

```bash
cd /home/hacker/nfc-luxury-restaurant/admin-desktop

# Build for Windows
npm run build-win

# Output: dist/nfc-luxury-restaurant-setup.exe
```

### Distribution Options:

**A. Direct Download:**
```bash
# Upload EXE to:
# - Google Drive
# - Dropbox
# - Your website
# Share link with waiters
```

**B. Auto-Update Setup:**
```bash
# Use electron-updater
npm install electron-updater

# Configure in main.js:
const { autoUpdater } = require('electron-updater');
autoUpdater.checkForUpdatesAndNotify();
```

---

## 🔒 SECURITY CHECKLIST

### Backend:
- [ ] Change JWT_SECRET to strong random string
- [ ] Enable HTTPS/SSL
- [ ] Set strong database password
- [ ] Enable CORS only for your domain
- [ ] Rate limiting enabled
- [ ] SQL injection protection (using Prisma/parameterized queries)
- [ ] Helmet.js for security headers

### Database:
- [ ] Strong password
- [ ] SSL/TLS enabled
- [ ] Limited IP access (whitelist backend IP)
- [ ] Regular backups enabled
- [ ] Monitoring enabled

### Client:
- [ ] HTTPS only
- [ ] Environment variables for API URLs
- [ ] No sensitive data in frontend code
- [ ] CSP headers configured

---

## 🌐 DOMAIN & SSL

### Get Domain:
```bash
# Buy from:
# - Namecheap.com (~$12/year)
# - GoDaddy.com (~$15/year)
# - Domain.com (~$10/year)

# Example domains:
# - nfc-restaurant.com
# - luxury-dining.app
# - smart-restaurant.io
```

### SSL Certificate:
```bash
# Automatic with Vercel/Netlify (FREE)
# Or use Let's Encrypt (FREE)

# For custom server:
sudo apt install certbot
sudo certbot --nginx -d yourdomain.com
```

---

## 📊 MONITORING & ANALYTICS

### Backend Monitoring:
```bash
# Use:
# - Railway built-in logs
# - Sentry.io for error tracking
# - LogRocket for session replay
```

### Client Analytics:
```bash
# Add to client:
npm install @vercel/analytics
# Or Google Analytics
```

---

## 💰 ESTIMATED MONTHLY COSTS

### Budget Option (Total: ~$7/month):
- Database: Railway PostgreSQL (Free tier)
- Backend: Railway ($5/month)
- Client: Vercel (FREE)
- Domain: $1/month (annual)

### Professional Option (Total: ~$50/month):
- Database: DigitalOcean Managed DB ($15/month)
- Backend: DigitalOcean Droplet ($12/month)
- Client: Vercel Pro ($20/month)
- Domain: $1/month
- SSL: FREE (Let's Encrypt)

### Enterprise Option (Total: ~$200/month):
- Database: DigitalOcean DB Cluster ($40/month)
- Backend: Multiple droplets + Load balancer ($100/month)
- Client: Vercel Enterprise ($50/month)
- CDN: Cloudflare ($5/month)
- Monitoring: Datadog ($5/month)

---

## 🚀 QUICK START - EASIEST PATH

### For First-Time Deploy (15 minutes):

**1. Database:**
```bash
# Go to railway.app
# Create account
# New Project → PostgreSQL
# Copy DATABASE_URL
```

**2. Backend:**
```bash
# Same Railway account
# New Service → GitHub repo
# Point to backend folder
# Add environment variables
# Deploy!
```

**3. Client:**
```bash
# Go to vercel.com
# Import GitHub repo
# Select client folder
# Add VITE_API_URL (from Railway)
# Deploy!
```

**4. Admin App:**
```bash
cd admin-desktop
npm run build-win
# Upload EXE to Google Drive
# Share with team
```

**Total time:** 15-30 minutes  
**Total cost:** FREE (using free tiers)

---

## 📱 FINAL URLs

After deployment:
- **Client:** https://your-project.vercel.app
- **Backend API:** https://your-backend.railway.app/api/v1
- **Admin:** Desktop EXE file

---

## 🎯 POST-DEPLOYMENT

### Test Everything:
```bash
# 1. Open client URL
# 2. Scan NFC / Enter table number
# 3. Browse menu
# 4. Add to cart
# 5. Place order
# 6. Check order in database
# 7. Open admin app
# 8. Verify order appears
# 9. Update order status
# 10. Check real-time updates
```

### Monitor:
```bash
# Backend logs: Railway dashboard
# Client analytics: Vercel analytics
# Database: Railway database metrics
```

### Backup:
```bash
# Database backups (daily):
pg_dump DATABASE_URL > backup.sql

# Or use Railway automatic backups
```

---

## 🆘 TROUBLESHOOTING

### Common Issues:

**CORS Error:**
```bash
# Add client domain to backend .env:
CORS_ORIGIN=https://your-vercel-app.vercel.app
```

**Database Connection Failed:**
```bash
# Check DATABASE_URL in backend env
# Verify SSL mode: ?sslmode=require
# Check IP whitelist in database settings
```

**Build Failed:**
```bash
# Check Node version (use v20)
# Clear cache: npm cache clean --force
# Reinstall: rm -rf node_modules && npm install
```

---

## 📞 SUPPORT RESOURCES

- Railway Docs: docs.railway.app
- Vercel Docs: vercel.com/docs
- DigitalOcean Docs: docs.digitalocean.com
- PostgreSQL Docs: postgresql.org/docs

---

**READY TO DEPLOY?** Follow the "Quick Start - Easiest Path" section above! 🚀
