# 🚀 RAILWAY GA DEPLOY QILISH - FINAL GUIDE

**Vaqt:** 2026-11-11, 21:45 (Tashkent) / 16:45 (UTC)  
**Maqsad:** Backend ni exquisite-expression proyektiga deploy qilish

---

## 📋 QADAMLAR (15-20 daqiqa):

### ✅ QADAM 1: EXQUISITE-EXPRESSION NI OCHISH (1 daqiqa)

1. Railway Dashboard: https://railway.app
2. **Projects** sahifasi
3. **exquisite-expression** proyektini bosing

---

### ✅ QADAM 2: YANGI SERVICE YARATISH (3 daqiqa)

1. **"+ New"** tugmasini bosing
2. **"GitHub Repo"** ni tanlang
3. Repository tanlash:
   - `bahriddinbegmirzayev9-lang/nfc-luxury-restaurant`
4. **"Deploy Now"** bosing

Railway avtomatik:
- ✅ Code ni clone qiladi
- ✅ Dependencies o'rnatadi
- ✅ Build qiladi
- ✅ Deploy qiladi

---

### ✅ QADAM 3: SERVICE SOZLAMALARINI O'ZGARTIRISH (5 daqiqa)

Deploy bo'lgandan keyin (2-3 daqiqa):

#### 3.1 Service Settings

1. Service nomini bosing (yangi yaratilgan)
2. **Settings** tab
3. **Service Name:** `nfc-backend` (yoki boshqa nom)
4. **Root Directory:** `backend` ← MUHIM! ⭐
5. **Save**

#### 3.2 Environment Variables

1. **Variables** tab
2. PostgreSQL ni link qilish:

**USUL A - Automatic Link (OSON!):**
- Settings → Services → Add Service
- PostgreSQL ni tanlang
- Railway avtomatik `DATABASE_URL` qo'shadi

**USUL B - Manual:**
- New Variable → `DATABASE_URL`
- Value: `${{Postgres.DATABASE_URL}}`

3. Boshqa kerakli variables:
```
NODE_ENV=production
PORT=5000
API_VERSION=v1
```

---

### ✅ QADAM 4: BUILD & START COMMAND (2 daqiqa)

1. **Settings** → **Deploy** section
2. **Build Command:** (bo'sh qoldiring yoki):
   ```
   npm install
   ```
3. **Start Command:**
   ```
   npm start
   ```
4. **Save**

---

### ✅ QADAM 5: REDEPLOY (1 daqiqa)

Settings o'zgargandan keyin:

1. **Deployments** tab
2. **"Redeploy"** yoki **"Trigger Deploy"**
3. Logs ni kuzating (2-3 daqiqa)

---

### ✅ QADAM 6: PUBLIC URL OLISH (1 daqiqa)

1. **Settings** → **Networking**
2. **Generate Domain** tugmasini bosing
3. Domain olasiz: `xyz123.up.railway.app`
4. Copy qiling! Bu sizning production backend URL!

---

### ✅ QADAM 7: TEST QILISH (2 daqiqa)

Terminal da:

```bash
# Health check
curl https://SIZNING-URL.up.railway.app/health

# Menu API
curl https://SIZNING-URL.up.railway.app/api/v1/menu/categories
```

---

## 🎯 AGAR MUAMMO BO'LSA:

### ERROR: "npm: command not found"
**Yechim:** Root Directory ni `backend` ga o'zgartiring

### ERROR: "Database connection failed"
**Yechim:** `DATABASE_URL` environment variable bormi tekshiring

### ERROR: "Port already in use"
**Yechim:** Start command: `PORT=$PORT npm start`

---

## 📊 SUCCESS INDICATORS:

Deploy muvaffaqiyatli bo'lsa:

```
✅ Build: Success
✅ Deploy: Success  
✅ Status: Running
✅ Health Check: {"success":true}
```

---

## ⏱️ TAXMINIY VAQT:

- Service yaratish: 3 daqiqa
- Settings sozlash: 5 daqiqa
- Deploy & test: 5 daqiqa
- **JAMI: 13-15 daqiqa**

---

## 🎉 TAYYOR BO'LGANDAN KEYIN:

1. ✅ Backend production da
2. ✅ Database ulangan
3. ✅ API ishlayapti
4. ✅ Client ni production ga ulash qoldi!

---

**OMAD! 🚀 Men har qadamda yordam beraman!**
