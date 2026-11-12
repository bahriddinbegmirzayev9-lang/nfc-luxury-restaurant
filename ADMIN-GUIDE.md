# 👨‍💼 BO'LIM 5: ADMIN PANEL ISHLATISH

## 5.1. KIRISH (LOGIN)

### Birinchi ofitsiantni yaratish:

Railway Console'da SQL bajaring:

```sql
-- Admin foydalanuvchi yaratish
INSERT INTO waiters (name, phone, email, password, role, status) VALUES
('Admin', '+998901234567', 'admin@restaurant.uz', 
'$2b$10$YourHashedPasswordHere', 'admin', 'online');

-- Oddiy ofitsiant
INSERT INTO waiters (name, phone, email, password, role, status) VALUES
('Sardor', '+998901111111', 'sardor@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'waiter', 'offline');
```

**Parolni hash qilish uchun:**
```javascript
const bcrypt = require('bcrypt');
const password = 'admin123'; // O'zgartiring!
const hash = await bcrypt.hash(password, 10);
console.log(hash); // Bu hash'ni SQL'ga qo'ying
```

### Login sahifasi:
```
Backend URL: https://your-backend.railway.app/admin
```

**Kirish ma'lumotlari:**
- **Telefon:** +998901234567
- **Parol:** admin123

---

## 5.2. DASHBOARD

### Ko'rsatkichlar:

#### 📊 Bugungi statistika:
- **Faol stollar:** 8/20
- **Kutilayotgan buyurtmalar:** 5
- **Bajarilgan buyurtmalar:** 23
- **Bugungi daromad:** 5,450,000 so'm
- **O'rtacha chek:** 237,000 so'm

#### 📈 Grafik:
- Soatlik buyurtmalar
- Eng ko'p sotiladigan ovqatlar (TOP 5)
- Kunlik daromad trendi

#### ⚡ Real-time yangilanishlar:
- Yangi buyurtma kelganda - **notification**
- Mijoz ofitsiantni chaqirganda - **alert**
- Stol bo'shaganda - **status o'zgaradi**

---

## 5.3. BUYURTMALARNI BOSHQARISH

### Buyurtmalar ro'yxati:

| # | Stol | Vaqt | Summa | Status | Harakat |
|---|------|------|-------|--------|---------|
| ORD-001 | 5 | 14:25 | 235,000 | Kutilmoqda | [Ko'rish] [Tasdiqlash] |
| ORD-002 | 12 | 14:30 | 450,000 | Tayyorlanmoqda | [Ko'rish] |
| ORD-003 | 3 | 14:15 | 180,000 | Tayyor | [Yetkazildi] |

### Status o'zgartirish:

```
Kutilmoqda → Tasdiqlandi → Tayyorlanmoqda → Tayyor → Yetkazildi → To'landi
```

**Har bir statusda:**
1. Buyurtmani bosing
2. Status tugmasini tanlang
3. Mijozga notification yuboriladi (Socket.io)
4. Dashboard yangilanadi

### Buyurtma detallari:

**ORD-001 - Stol 5**

| Ovqat | Miqdor | Narx | Jami |
|-------|--------|------|------|
| Osh | 2 | 45,000 | 90,000 |
| Shashlik | 1 | 55,000 | 55,000 |
| Ko'k choy | 2 | 8,000 | 16,000 |
| **Oraliq summa** | | | **161,000** |
| **Soliq (15%)** | | | **24,150** |
| **Xizmat (10%)** | | | **16,100** |
| **JAMI** | | | **201,250** |

**Maxsus izoh:** "Shashlikni yaxshi pishirib bering"

**Harakat tugmalari:**
- ✅ Tasdiqlash
- 🍳 Tayyorlanishni boshlash
- ✔️ Tayyor
- 🚚 Yetkazildi
- 💰 To'landi
- 🖨️ Print chek
- ❌ Bekor qilish

---

## 5.4. STOLLARNI BOSHQARISH

### Stollar ro'yxati:

| Stol # | O'rindiq | Status | Sessiya | Summa | Harakat |
|--------|----------|--------|---------|-------|---------|
| 1 | 4 | 🟢 Bo'sh | - | - | [Booking] |
| 2 | 6 | 🔴 Band | 45 min | 320,000 | [Ko'rish] [Shot] |
| 3 | 2 | 🟡 Buyurtma | 15 min | 180,000 | [Ko'rish] |
| 5 | 4 | 🔴 Band | 28 min | 450,000 | [Ko'rish] [Shot] |

**Status:**
- 🟢 **Bo'sh** - Mijoz yo'q
- 🟡 **Buyurtma** - Buyurtma berilgan, lekin yana yeb turishadi
- 🔴 **Band** - Ovqat yetirilgan, to'lov kutilmoqda
- 🔵 **Rezerv** - Booking qilingan

### Stol detallari:

**STOL 5**
- **O'rindiq:** 4 kishi
- **NFC tag:** NTAG213-0001
- **QR kod:** QR-005
- **Holat:** Band
- **Sessiya:** 28 daqiqa
- **Til:** O'zbek
- **Mijozlar soni:** 3 kishi

**Faol buyurtma:**
- ORD-001 - 201,250 so'm
- ORD-002 - 145,000 so'm
- **Jami:** 346,250 so'm

**Harakat:**
- 📄 Shot yaratish
- 🔔 Ofitsiantni chaqirish
- ✖️ Sessiyani tugatish
- 🔄 Stolni tozalash

---

## 5.5. MIJOZ CHAQIRUVLARI

### Chaqiruvlar ro'yxati:

| Vaqt | Stol | Tur | Status | Ofitsiant | Harakat |
|------|------|-----|--------|-----------|---------|
| 14:45 | 12 | 🔔 Yordam | Kutilmoqda | - | [Qabul qilish] |
| 14:42 | 5 | 💰 Shot | Bajarilmoqda | Sardor | [Ko'rish] |
| 14:38 | 8 | ❗ Shikoyat | Hal qilindi | Admin | [Ko'rish] |

**Chaqiruv turlari:**
- 🔔 **Yordam** - Umumiy savol
- 💰 **Shot** - To'lov talab qilinadi
- ❗ **Shikoyat** - Muammo bor

### Chaqiruvni qabul qilish:

1. **[Qabul qilish]** tugmasini bosing
2. Sizning ismingiz ko'rinadi
3. Mijoz telefonida "Ofitsiant kelmoqda" xabari
4. Stolga boring va yordam bering
5. **[Hal qilindi]** tugmasini bosing

**Priority:**
- 🔴 **Yuqori** - 5 daqiqadan oshsa
- 🟡 **O'rtacha** - 2-5 daqiqa
- 🟢 **Past** - 2 daqiqadan kam

---

## 5.6. MENYU BOSHQARISH

### Ovqat qo'shish:

**Yangi ovqat qo'shish** tugmasini bosing:

```
Kategoriya: [Tanlang ▼]
  - Salatlar
  - Sho'rvalar
  - Issiq taomlar
  ...

Nomi (O'zbek): _____________
Nomi (Rus): _____________
Nomi (Ingliz): _____________

Tavsif (O'zbek): _______________
Tavsif (Rus): _______________
Tavsif (Ingliz): _______________

Narx (so'm): _____________

Rasm URL: _____________
[Rasm yuklash]

☐ Vegetarian
☐ Achchiq
☐ Featured (tavsiya)
☐ Mavjud

Tayyorlash vaqti (daq): _____
Kaloriya: _____

[Saqlash] [Bekor qilish]
```

### Ovqatni o'zgartirish:

Ovqat ro'yxatidan tanlang → **[Tahrirlash]**

### Narx o'zgartirish:

**TEZKOR NARX O'ZGARTIRISH:**
1. Ovqatni tanlang
2. Yangi narxni kiriting
3. [Saqlash] bosing
4. Darhol mijozlar ilovasida yangilanadi

### Mavjudligini o'chirish:

Ovqat tugab qolsa:
1. Ovqatni toping
2. **☐ Mavjud** checkboxni o'chiring
3. Mijozlar endi bu ovqatni ko'rmaydi

---

## 5.7. STATISTIKA VA HISOBOTLAR

### Kunlik hisobot:

```
📅 2026-11-10

Umumiy ma'lumotlar:
- Mijozlar soni: 87
- Buyurtmalar: 54
- O'rtacha chek: 245,000 so'm
- Umumiy daromad: 13,230,000 so'm

Eng ko'p sotilgan (TOP 5):
1. Osh - 23 dona - 1,035,000 so'm
2. Shashlik - 18 dona - 990,000 so'm
3. Lag'mon - 15 dona - 570,000 so'm
4. Manti - 12 dona - 504,000 so'm
5. Tiramisu - 10 dona - 380,000 so'm

Stollar:
- O'rtacha band vaqti: 58 daqiqa
- Eng band stol: 5-stol (4 marta)
- Eng kam: 15-stol (1 marta)

Ofitsiantlar:
- Sardor: 18 buyurtma, 4,140,000 so'm
- Aziz: 15 buyurtma, 3,675,000 so'm
- Malika: 21 buyurtma, 5,415,000 so'm
```

### Haftalik hisobot:

**2026-11-04 → 2026-11-10**

📊 **Grafik:** Kunlik daromad

```
     |
15M  |           ▄▄
     |       ▄▄▄▄██
12M  |     ▄▄██████
     |   ▄▄████████
9M   | ▄▄██████████
     |███████████████
     |_____________________
      Dush Sesh Chor Panj Jum Shan Yak
```

**Jami daromad:** 87,450,000 so'm  
**O'sish:** +12% (o'tgan haftaga nisbatan)

### Oylik hisobot:

**2026-10-01 → 2026-10-31**

- **Jami daromad:** 345,600,000 so'm
- **Xarajatlar:** 180,200,000 so'm
- **Sof foyda:** 165,400,000 so'm
- **Margin:** 47.9%

**Excel/PDF export:** [Yuklab olish]

---

## 5.8. SOZLAMALAR

### Restoran sozlamalari:

```
Restoran nomi: ___________________
Telefon: ___________________
Manzil: ___________________
Ish vaqti: 09:00 - 23:00

Soliq stavkasi: 15 %
Xizmat to'lovi: 10 %

Til (default): O'zbek ▼

NFC sozlamalari:
☑ NFC scan yoqilgan
☐ QR kod fallback
☑ Manual stol raqami

Notification:
☑ Yangi buyurtma
☑ Mijoz chaqiruvi
☑ To'lov kelib tushdi
```

### Ofitsiantlar boshqarish:

| Ism | Telefon | Email | Rol | Status | Harakat |
|-----|---------|-------|-----|--------|---------|
| Admin | +998901234567 | admin@... | Admin | 🟢 Online | [Tahrirlash] |
| Sardor | +998901111111 | sardor@... | Waiter | 🟢 Online | [Tahrirlash] |
| Aziz | +998902222222 | aziz@... | Waiter | 🔴 Offline | [Tahrirlash] |

**Yangi ofitsiant qo'shish:**
- Ism, telefon, parol kiriting
- Rol tanlang: Waiter / Manager / Admin
- Permissions belgilang

---

# 🔧 BO'LIM 6: TEXNIK QOʻLLAB-QUVVATLASH

## 6.1. MUAMMOLARNI BARTARAF QILISH

### Frontend ishlamayapti:

**Muammo:** Sahifa ochmayapti yoki xato ko'rsatyapti

**Yechim:**
1. URL to'g'rimi tekshiring: `https://your-domain.vercel.app`
2. Vercel Dashboard → Deployments → oxirgi deploy'ni tekshiring
3. Logs'ga qarang: Build xatolari bormi?
4. Environment variables to'g'rimi?
   - `VITE_API_URL` backend URL'ga to'g'ri ishora qilishi kerak

**Agar build xato bo'lsa:**
```bash
cd client
npm install
npm run build
```

Xatoliklarni to'g'rilang va qayta deploy qiling.

---

### Backend ishlamayapti:

**Muammo:** API javob bermayapti (500/503 xato)

**Yechim:**
1. Railway Dashboard → Project → Logs'ga qarang
2. Database ulanish to'g'rimi?
   ```bash
   # Railway Console
   echo $DATABASE_URL
   ```
3. Environment variables tekshiring
4. Restart qiling: Railway → Deploy → Restart

**Database connection xatosi:**
```
Error: connect ECONNREFUSED
```

**Yechim:** Database variables'ni tekshiring:
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`

---

### NFC ishlamayapti:

**Muammo:** NFC skan qilganda hech narsa bo'lmayapti

**Sabablari:**
1. **Telefon NFC'ni qo'llab-quvvatlamaydi**
   - Faqat Android 10+ va Chrome browser
   - iOS'da NFC ishlaydi (Safari)

2. **NFC yoqilmagan**
   - Settings → Connected devices → NFC → Yoqing

3. **HTTPS kerak**
   - HTTP'da NFC ishlamaydi, faqat HTTPS'da

4. **NFC tag xato**
   - Tag NDEF formatida bo'lishi kerak
   - Tag'ga to'g'ri URL yozilganmi tekshiring

**NFC tag'ni tekshirish:**
1. **NFC Tools** app yuklab oling (Android)
2. Tag'ni skanlang
3. URL ko'rining: `https://your-domain.vercel.app/nfc-scan?table=5`

**Fallback:** 
Agar NFC ishlamasa, mijoz qo'lda stol raqamini kiritishi mumkin.

---

### To'lov ishlamayapti:

**Muammo:** Click/Payme to'lov xato

**Yechim:**
1. Payment gateway credentials to'g'rimi?
2. Test mode'damisiz? Production'ga o'tkazilganmi?
3. Merchant ID va Secret Key to'g'rimi?
4. Callback URL sozlanganmi?

**Click Merchant ID topish:**
- Click merchant dashboard → Settings → Merchant ID

**Payme Merchant ID:**
- Payme dashboard → Settings → Merchant ID

---

## 6.2. BACKUP VA RESTORE

### Databasedan backup olish:

**Railway Console:**
```bash
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql
```

**Yoki Railway UI'dan:**
1. Database → **Backups** tab
2. **Create Backup** tugmasini bosing
3. Backup avtomatik yaratiladi

**Backup jadvali:**
- Har kuni: 00:00
- Har hafta: Yakshanba
- Har oy: 1-kun

**Saqlash muddati:** 30 kun

### Backup'dan tiklash:

**Agar database buzilsa:**

```bash
# Railway Console
psql $DATABASE_URL < backup-20261110.sql
```

**Yoki UI'dan:**
1. Database → Backups
2. Backup'ni tanlang
3. **Restore** tugmasini bosing
4. Tasdiqlang

⚠️ **Diqqat:** Restore qilganda hozirgi ma'lumotlar yo'qoladi!

---

## 6.3. YANGILANISHLAR

### Frontend yangilash:

**Yangi feature qo'shganda:**

1. Kodni o'zgartiring (`client/` papkada)
2. GitHub'ga push qiling:
   ```bash
   git add .
   git commit -m "feat: yangi feature qo'shildi"
   git push
   ```
3. Vercel avtomatik deploy qiladi (2-3 daqiqa)
4. Deploy'ni kuzating: Vercel Dashboard → Deployments

**Manual deploy:**
```bash
cd client
vercel --prod
```

### Backend yangilash:

**API'ga o'zgartish kirgizganda:**

1. Kodni o'zgartiring (`backend/` papkada)
2. GitHub'ga push qiling
3. Railway avtomatik deploy qiladi

**⚠️ Database migration kerak bo'lsa:**
```sql
-- Yangi ustun qo'shish
ALTER TABLE menu_items ADD COLUMN allergens TEXT;

-- Index qo'shish
CREATE INDEX idx_menu_items_price ON menu_items(price);
```

Railway Console'da SQL'ni bajaring.

### Versiyalash:

**Semantic Versioning:**
- **1.0.0** - Major (katta o'zgarishlar)
- **1.1.0** - Minor (yangi feature)
- **1.1.1** - Patch (bug fix)

**package.json'da:**
```json
{
  "version": "1.0.0"
}
```

---

## 6.4. MONITORING

### Uptime monitoring:

**UptimeRobot** (bepul):
1. https://uptimerobot.com ga kiring
2. **Add New Monitor**
3. URL: `https://your-backend.railway.app/health`
4. Interval: 5 daqiqa
5. Email notification yoqing

**Xabar keladi:**
- Site down bo'lsa
- Response time sekin bo'lsa (>2s)

### Error tracking:

**Sentry** (bepul 5000 event/oy):
1. https://sentry.io ga kiring
2. Yangi project yarating
3. DSN'ni oling
4. Environment variable qo'shing:
   ```bash
   SENTRY_DSN=https://...@sentry.io/...
   ```
5. Kodda integratsiya qiling

**Frontend (client/src/main.jsx):**
```javascript
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: "production",
});
```

### Performance monitoring:

**Google Analytics:**
- Page views
- User flow
- Popular pages
- Bounce rate

**Vercel Analytics:**
- Page load time
- Web Vitals (LCP, FID, CLS)
- Real User Monitoring (RUM)

---

# 📞 BO'LIM 7: ALOQA VA QOʻLLAB-QUVVATLASH

## Texnik qo'llab-quvvatlash:

**Email:** support@nfc-restaurant.uz  
**Telegram:** @nfc_restaurant_support  
**Telefon:** +998 90 123-45-67  

**Ish vaqti:**
- Dushanba - Juma: 09:00 - 18:00
- Dam olish: 13:00 - 14:00

**Tezkor yordam:**
- **PRO paket:** 24 soat ichida
- **ENTERPRISE:** 2 soat ichida
- **Muhim muammo:** Darhol (telefon)

---

## Video qo'llanmalar:

📹 **YouTube Playlist:**
- O'rnatish va sozlash (15 min)
- Admin panel ishlatish (20 min)
- Menyu qo'shish (10 min)
- NFC tag'larni sozlash (8 min)
- Muammolarni bartaraf qilish (12 min)

---

# 🎓 APPENDIX: FOYDALI MA'LUMOTLAR

## NFC Taglar:

**Tavsiya qilinadigan:** NTAG213/215/216

**Qayerdan sotib olish:**
- AliExpress: ~$0.20/dona
- Amazon: ~$0.50/dona
- Mahalliy: Texnomarket, Mediapark

**Miqdor:**
- BASIC: 10 tag
- PRO: 20 tag
- ENTERPRISE: 50 tag
- Zaxira: +20%

## Domen nomlari:

**Tavsiya:**
- restaurant.uz
- luxuryrestaurant.uz
- [restaurant_name].uz

**Provayderlar:**
- UzDomain.uz
- UZINFOCOM
- Namecheap (international)

## SSL Sertifikat:

Vercel avtomatik **Let's Encrypt** beradi (bepul, 90 kun)

## Hosting narxlari:

| Xizmat | Oylik | Yillik |
|--------|-------|--------|
| Railway (Backend) | $5-20 | $60-240 |
| Vercel (Frontend) | $0-20 | $0-240 |
| Domen | - | $10-50 |
| **JAMI** | **$5-40** | **$70-530** |

---

# ✅ TAYYOR!

Barcha hujjatlar to'ldirildi! 

**Fayllar:**
1. `PRESENTATION-FULL.md` - Biznes prezentatsiya
2. `SETUP-GUIDE.md` - Texnik sozlash
3. Bu fayl - To'liq qo'llanma

**Keyingi qadam:**
Demo'ga ma'lumotlar qo'shish kerak! Men SQL script tayyorlayman. Tayyor bo'lsangiz, "demo ma'lumotlarini qo'sh" deb yozing! 🚀