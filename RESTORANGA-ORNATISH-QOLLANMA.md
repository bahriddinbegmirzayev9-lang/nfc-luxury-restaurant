# 🏢 NFC LUXURY RESTAURANT - RESTORANGA O'RNATISH QO'LLANMASI

**Versiya:** 1.0  
**Sana:** 2026-11-11  
**Maqsad:** Tizimni restoranga professional o'rnatish va sozlash

---

## 📋 MUNDARIJA

1. [Tayyorgarlik](#tayyorgarlik)
2. [Texnik Talablar](#texnik-talablar)
3. [O'rnatish Jarayoni](#ornatish-jarayoni)
4. [Menyu Sozlash](#menyu-sozlash)
5. [NFC Taglarni Sozlash](#nfc-taglarni-sozlash)
6. [Xodimlarni O'qitish](#xodimlarni-oqitish)
7. [Muammolarni Hal Qilish](#muammolarni-hal-qilish)
8. [Texnik Yordam](#texnik-yordam)

---

## 1️⃣ TAYYORGARLIK

### ✅ O'RNATISHDAN OLDIN KERAK BO'LGAN NARSALAR:

#### **A) Restoran Tomonidan:**

```
☐ WiFi Internet (Min 10 Mbps)
☐ Router (Guest WiFi uchun)
☐ Elektr rozetkalar (har bir stolda)
☐ Stollar soni va raqamlari
☐ Restoran logotipi (PNG/SVG)
☐ Menyu ro'yxati (Excel/PDF)
☐ Narxlar ro'yxati
☐ Rasmlar (har bir taom uchun)
```

#### **B) Siz Tomonidan:**

```
☐ NFC taglar (stollar soni + 5 ta zaxira)
☐ Laptop/Tablet (admin panel uchun)
☐ QR kod printer (agar kerak bo'lsa)
☐ USB fleysh (database backup)
☐ O'rnatish to'plami (dasturlar)
```

---

## 2️⃣ TEXNIK TALABLAR

### 🖥️ **SERVER (Railway/Hosting):**

```yaml
Minimum:
  - RAM: 512 MB
  - CPU: 1 core
  - Storage: 1 GB
  - Bandwidth: 10 GB/month

Recommended:
  - RAM: 1 GB
  - CPU: 2 cores
  - Storage: 5 GB
  - Bandwidth: 50 GB/month
```

### 📱 **Mijozlar uchun:**

```
Mobil telefonlar:
  - NFC support (Android 4.4+, iPhone 7+)
  - Yoki: Camera (QR kod scan)
  - Browser: Chrome, Safari, Firefox

Internet:
  - WiFi: 2.4 GHz yoki 5 GHz
  - Tezlik: Min 5 Mbps per user
```

### 🖥️ **Admin Panel (Ofitsiantlar):**

```
Tablet/Laptop:
  - OS: Windows 10+, macOS, Linux
  - RAM: 4 GB
  - Browser: Chrome (latest)
  - Screen: Min 1024x768
```

---

## 3️⃣ O'RNATISH JARAYONI

### 📅 **UMUMIY VAQT: 1-2 KUN**

### **KUN 1: TEXNIK O'RNATISH (4-6 soat)**

#### **QADAM 1: SERVER SOZLASH (1 soat)**

```bash
# 1. Railway ga kirish
https://railway.app

# 2. Proyekt yaratish
- New Project → Deploy from GitHub
- Repository: nfc-luxury-restaurant

# 3. Database sozlash
- Add Service → PostgreSQL
- DATABASE_URL ni ulash

# 4. Environment Variables
PORT=5000
NODE_ENV=production
API_VERSION=v1
DATABASE_URL=${{Postgres.DATABASE_URL}}
JWT_SECRET=<random-32-char-string>
CORS_ORIGIN=https://restaurant-domain.com

# 5. Deploy qilish
- Push code
- Wait for deployment
- Test: https://your-backend.up.railway.app/health
```

#### **QADAM 2: DATABASE TO'LDIRISH (1 soat)**

```bash
# 1. PostgreSQL Console ga kirish
Railway → PostgreSQL → Data → Query

# 2. Schema yuklash
# schema.sql faylini copy-paste qiling

# 3. Data yuklash
# QUICK-DATABASE-INSERT.sql faylini paste qiling

# 4. Tekshirish
SELECT COUNT(*) FROM tables;        -- 20
SELECT COUNT(*) FROM menu_items;    -- 49+
SELECT COUNT(*) FROM menu_categories; -- 14
```

#### **QADAM 3: RESTORAN MA'LUMOTLARINI SOZLASH (2 soat)**

##### **3.1 Menyu Qo'shish/O'zgartirish**

```sql
-- Kategoriya qo'shish
INSERT INTO menu_categories (name_uz, name_ru, name_en, icon, sort_order)
VALUES 
('Alkogol ichimliklar', 'Алкогольные напитки', 'Alcoholic Drinks', '🍷', 15);

-- Taom qo'shish
INSERT INTO menu_items (
    category_id,
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price,
    preparation_time,
    image_url
)
SELECT 
    c.id,
    'Kebab', 'Кебаб', 'Kebab',
    'Maxsus kebab', 'Особый кебаб', 'Special kebab',
    45000,
    20,
    'https://your-image-url.com/kebab.jpg'
FROM menu_categories c 
WHERE c.name_en = 'Grill & Kebabs';

-- Narxni o'zgartirish
UPDATE menu_items 
SET price = 40000 
WHERE name_en = 'Caesar Salad';

-- Taomni o'chirish
DELETE FROM menu_items WHERE name_en = 'Old Dish';
```

##### **3.2 Stollarni Sozlash**

```sql
-- Stollar sonini o'zgartirish (masalan, 30 ta)
INSERT INTO tables (table_number, capacity, qr_code, status)
VALUES 
(21, 4, 'QR-021', 'available'),
(22, 4, 'QR-022', 'available'),
(23, 6, 'QR-023', 'available'),
-- ... 30 tagacha
(30, 8, 'QR-030', 'available');

-- Stol sig'imini o'zgartirish
UPDATE tables 
SET capacity = 6 
WHERE table_number = 5;
```

##### **3.3 Admin Foydalanuvchi Yaratish**

```sql
-- Manager yaratish
INSERT INTO waiters (name, phone, email, password_hash, role)
VALUES (
    'Restoran Manager',
    '+998901234567',
    'manager@restaurant.uz',
    '$2b$10$hashedpassword',  -- Bcrypt hash
    'manager'
);

-- Ofitsiant yaratish
INSERT INTO waiters (name, phone, email, password_hash, role)
VALUES (
    'Ofitsiant Ali',
    '+998909876543',
    'ali@restaurant.uz',
    '$2b$10$hashedpassword',
    'waiter'
);
```

#### **QADAM 4: NFC TAGLARNI YOZISH (1-2 soat)**

##### **4.1 NFC Tag Yozish Dasturi O'rnatish**

```
Android:
  - NFC Tools (Google Play)
  - NFC TagWriter by NXP

iPhone:
  - NFC TagWriter by NXP
  - Shortcuts app (iOS 13+)
```

##### **4.2 Har Bir Tag ga Yozish**

```
URL Format:
https://your-domain.com/scan?table=1

Yoki:

nfc://table/1

Qadamlar:
1. NFC Tools dasturini oching
2. Write → Add a record → URL
3. URL kiriting: https://your-domain.com/scan?table=1
4. Write tugmasini bosing
5. Tag ni telefonga yaqinlashtiring
6. Muvaffaqiyatli yozildi!
7. Tag raqamini yozing (Stol 1)
8. Keyingi tag uchun takrorlang
```

##### **4.3 NFC Tag Testlash**

```
1. Telefonda NFC yoqilganligini tekshiring
2. Tag ni telefonga yaqinlashtiring
3. Brauzer ochilishi kerak
4. To'g'ri stol raqami ko'rinishi kerak
5. Agar ishlamasa: Tag ni qayta yozing
```

#### **QADAM 5: WiFi GUEST NETWORK SOZLASH (30 daqiqa)**

```yaml
WiFi Settings:
  Network Name: Restaurant_Guest_WiFi
  Password: Simple123! (yoki parolsiz)
  Security: WPA2
  Bandwidth Limit: 5 Mbps per user
  Access: Internet only (local network yo'q)

Speed Test:
  - speedtest.net da test qiling
  - Min 10 Mbps download
  - Min 5 Mbps upload
```

### **KUN 2: SOZLASH VA O'QITISH (4-6 soat)**

#### **QADAM 6: CLIENT (Veb-sayt) SOZLASH (1 soat)**

##### **6.1 Domain Sozlash (agar kerak bo'lsa)**

```bash
# Vercel/Netlify ga deploy
npm run build
# dist papkasini upload qiling

# Yoki Cloudflare Pages:
1. cloudflare.com ga kiring
2. Pages → Create a project
3. GitHub repository ulang
4. Build command: npm run build
5. Output directory: dist
6. Deploy qiling

# Domain bog'lash:
- restaurant.uz → Cloudflare DNS
- A record → Vercel/Netlify IP
```

##### **6.2 Branding (Logo, Ranglar)**

```bash
# Logo o'zgartirish
client/src/assets/logo.png  # Logo rasmini almashtiring

# Ranglarni o'zgartirish
client/tailwind.config.js

colors: {
  primary: {
    DEFAULT: '#D4AF37',  # Oltin rang (o'zgartiring)
    dark: '#B8941F',
    light: '#ECD77F',
  },
  secondary: {
    DEFAULT: '#1A1A1A',  # Qora (o'zgartiring)
  }
}

# Restoran nomini o'zgartirish
client/src/config.js

export const config = {
  restaurantName: 'SIZNING RESTORAN NOMI',
  restaurantName_uz: 'RESTORAN NOMI',
  restaurantName_ru: 'НАЗВАНИЕ РЕСТОРАНА',
  restaurantName_en: 'RESTAURANT NAME',
}
```

##### **6.3 Mobil PWA Sozlash**

```javascript
// client/public/manifest.json
{
  "name": "Restoran Nomi",
  "short_name": "Restoran",
  "theme_color": "#D4AF37",
  "background_color": "#1A1A1A",
  "display": "standalone",
  "scope": "/",
  "start_url": "/",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

#### **QADAM 7: ADMIN PANEL O'RNATISH (1 soat)**

```bash
# Ofitsiantlar uchun planshet/laptop sozlash

1. Chrome browser o'rnatish
2. Admin URL bookmark qilish:
   https://your-backend.up.railway.app/admin

3. Login ma'lumotlarini yozish:
   Username: manager@restaurant.uz
   Password: [manager password]

4. Desktop shortcut yaratish
5. Auto-login sozlash (agar kerak bo'lsa)
```

#### **QADAM 8: QR KOD YARATISH (30 daqiqa)**

```bash
# Agar NFC ishlamasa, QR kod backup

# Online generator:
https://qr-code-generator.com

# Har bir stol uchun:
URL: https://your-domain.com/scan?table=1

# QR kod print qilish:
- A6 o'lcham (10x15 cm)
- Plastic holder yoki lamination
- Stol ustiga qo'yish

# Template:
┌─────────────────┐
│   [QR KOD]      │
│                 │
│  Stol №1        │
│  Table №1       │
│                 │
│  Scan qiling    │
│  Сканируйте     │
│  Scan here      │
└─────────────────┘
```

---

## 4️⃣ MENYU SOZLASH

### 📸 **TAOM RASMLARI QO'SHISH**

#### **Variant 1: Unsplash (Bepul, Professional)**

```
1. unsplash.com ga kiring
2. Taom nomini qidiring (inglizcha)
3. High quality rasm tanlang
4. Download → Small (1080p)
5. URL ni copy qiling
6. Database ga qo'shing
```

#### **Variant 2: O'z Rasmlari**

```
Setup:
1. Professional kamera/telefon
2. Yaxshi yorug'lik (natural/softbox)
3. Oddiy fon (oq/kulrang)
4. 1080x1080 px (kvadrat)

Optimizatsiya:
- tinypng.com da compress qiling
- Format: JPG (70-80% quality)
- Size: < 200 KB per image

Upload:
- Cloudinary (bepul 25 GB)
- ImgBB (bepul unlimited)
- Yoki hosting server
```

### 💰 **NARXLARNI SOZLASH**

```sql
-- Barcha narxlarga 10% qo'shish
UPDATE menu_items 
SET price = price * 1.10;

-- Ma'lum kategoriya narxini o'zgartirish
UPDATE menu_items 
SET price = price * 1.15
WHERE category_id IN (
    SELECT id FROM menu_categories 
    WHERE name_en = 'Grill & Kebabs'
);

-- Chegirma qo'shish (20% off)
UPDATE menu_items 
SET price = price * 0.80
WHERE name_en IN ('Pizza Margherita', 'Caesar Salad');

-- Happy Hour (ma'lum vaqtda)
-- Bu backend logic orqali qilinadi
```

### 🌍 **TILLARNI SOZLASH**

```sql
-- Taom nomlarini to'ldirish
UPDATE menu_items 
SET 
    name_uz = 'Sezar salati',
    name_ru = 'Салат Цезарь',
    name_en = 'Caesar Salad',
    description_uz = 'Tovuq, parmesan, kruton, sous',
    description_ru = 'Курица, пармезан, сухари, соус',
    description_en = 'Chicken, parmesan, croutons, sauce'
WHERE id = 'some-uuid';
```

---

## 5️⃣ NFC TAGLARNI SOZLASH

### 📱 **TAG YOZISH (Batafsil)**

#### **NTAG213/215/216 Sozlash:**

```
Spetsifikatsiya:
- NTAG213: 144 bytes (yetarli)
- NTAG215: 504 bytes (tavsiya)
- NTAG216: 888 bytes (ortiqcha)

Password Protection:
- NFC Tools → Other → Set password
- Password: 8 hex digits (16 char)
- Faqat o'qish: Read-only mode

Data Format:
Type: URI (URL)
Content: https://restaurant.uz/scan?table=1

Yoki:

Type: Text
Content: nfc://table/1
```

#### **iOS Shortcuts (iPhone uchun):**

```
1. Shortcuts app oching
2. Automation → Create Personal Automation
3. NFC → Scan NFC tag
4. When recognized → Open URL
5. URL: https://restaurant.uz/scan?table=1
6. Name: Stol 1
7. Done

Muammo: Har safar Shortcuts dasturi ochiladi
Yechim: URL variant ishlatish yaxshiroq
```

### 🔧 **TAG MUAMMOLARINI HAL QILISH**

```
Muammo 1: Tag o'qilmayapti
Yechim:
  - Telefon NFC yoqilganligini tekshiring
  - Tag metall yuzaga tegmasligiga ishonch hosil qiling
  - Tag shikastlanmaganligini tekshiring
  - Tag format qiling va qayta yozing

Muammo 2: Noto'g'ri stol raqami
Yechim:
  - Tag ni qayta yozing
  - URL ni tekshiring
  - Database da stol mavjudligini tekshiring

Muammo 3: Slow response
Yechim:
  - WiFi tezligini tekshiring
  - Server status ni tekshiring
  - Browser cache tozalang
```

---

## 6️⃣ XODIMLARNI O'QITISH

### 👨‍🍳 **OFITSIANTLAR UCHUN (2 soat training)**

#### **Sessiya 1: Asoslar (30 daqiqa)**

```
1. Sistema haqida umumiy ma'lumot
   - NFC nima?
   - Qanday ishlaydi?
   - Mijozlarga qanday yordam berish?

2. NFC Tag ishlatish
   - Stolga yaqinlashish
   - "Scan qiling" ko'rsatish
   - Muammo bo'lsa: QR kod variant
   - Agar telefonda NFC yo'q: Manual stol raqami

3. Mijoz savollariga javoblar:
   Q: NFC xavfsizmi?
   A: Ha, faqat URL ochadi, hech narsa o'rnatmaydi

   Q: Internet kerakmi?
   A: Ha, bizning WiFi ulanish kerak

   Q: Nima uchun mobil versiya yo'q?
   A: Bu mobil versiya! (PWA)
```

#### **Sessiya 2: Admin Panel (30 daqiqa)**

```
Login:
1. Tablet oching
2. Chrome browser
3. Bookmark: Admin Panel
4. Login: [username]
5. Parol: [password]

Asosiy funksiyalar:
1. Yangi buyurtmalarni ko'rish
2. Buyurtma statusini o'zgartirish
3. Stol statusini o'zgartirish
4. Mijoz chaqiruviga javob berish
5. Hisob chiqarish (bill)

Hotkeys:
- F5: Refresh
- Ctrl+P: Print bill
- Esc: Close modal
```

#### **Sessiya 3: Muammolar (30 daqiqa)**

```
Problem: WiFi ishlamayapti
Solution:
  1. Router restart
  2. Mijoz telefonini restart
  3. Boshqa WiFi network sinab ko'ring

Problem: Buyurtma ko'rinmayapti
Solution:
  1. Admin panel ni refresh qiling (F5)
  2. Serverni tekshiring (health check)
  3. Texnik yordam chaqiring

Problem: NFC ishlamayapti
Solution:
  1. QR kod variant ko'rsating
  2. Manual stol raqami kiriting
  3. Telefon sozlamalarini tekshiring
```

#### **Sessiya 4: Best Practices (30 daqiqa)**

```
DO:
✅ Har safar buyurtmani tasdiqlang
✅ Statusni darhol yangilang
✅ Mijozlarga smile :)
✅ Tabletni charge qilib turing
✅ Problem bo'lsa darhol xabar bering

DON'T:
❌ Parolni boshqalarga berma
❌ Tabletni restorandan chiqarma
❌ Admin panelni yopma (minimize ok)
❌ Mijoz ma'lumotlarini share qilma
```

### 🏨 **MANAGER UCHUN (1 soat training)**

```
1. Hisobotlar ko'rish
   - Kunlik sotuvlar
   - Eng ko'p sotiladigan taomlar
   - Ofitsiantlar performance

2. Menyu boshqarish
   - Taom qo'shish/o'chirish
   - Narx o'zgartirish
   - Mavjud/mavjud emas belgilash

3. Xodimlar boshqarish
   - Yangi ofitsiant qo'shish
   - Parol o'zgartirish
   - Huquqlarni boshqarish

4. System monitoring
   - Server status
   - Error logs
   - Backup yaratish
```

---

## 7️⃣ MUAMMOLARNI HAL QILISH

### 🚨 **TEZKOR YECHIMLAR**

#### **Problem 1: Server ishlamayapti**

```bash
Alomatlar:
- Website ochilmayapti
- "502 Bad Gateway" xatosi
- "Service Unavailable"

Yechim:
1. Railway dashboard ga kiring
2. Service status ni tekshiring
3. Agar crashed: Restart bosing
4. Logs ni tekshiring
5. Agar database muammosi: DATABASE_URL tekshiring

Vaqt: 5-10 daqiqa
```

#### **Problem 2: Database connection error**

```bash
Alomatlar:
- "Error fetching data"
- "Database connection failed"
- Menu bo'sh

Yechim:
1. Railway → PostgreSQL status
2. Agar online: Environment variables tekshiring
3. DATABASE_URL to'g'ri sozlanganligini tekshiring
4. Service restart qiling

Vaqt: 2-5 daqiqa
```

#### **Problem 3: Slow performance**

```bash
Alomatlar:
- Website sekin ochiladi
- Buyurtma kechikadi
- Timeout errors

Yechim:
1. Internet tezligini tekshiring (speedtest.net)
2. Server logs ni tekshiring
3. Database query optimization
4. CDN qo'shish (agar kerak bo'lsa)
5. Railway plan upgrade (agar users ko'p)

Vaqt: 10-30 daqiqa
```

#### **Problem 4: NFC ishlamayapti**

```bash
Alomatlar:
- Tag scan qilganda hech narsa bo'lmaydi
- Noto'g'ri URL ochiladi

Yechim:
1. Telefon NFC yoqilganligini tekshiring
2. Tag ni qayta scan qiling
3. Tag URL ni tekshiring (NFC Tools app)
4. Agar kerak bo'lsa tag ni qayta yozing
5. QR kod backup ko'rsating

Vaqt: 1-5 daqiqa
```

### 📊 **MONITORING VA MAINTENANCE**

#### **Kunlik Tekshiruvlar:**

```bash
# 1. Server health
curl https://your-backend.up.railway.app/health

# 2. Database connection
SELECT 1;

# 3. Disk space
# Railway dashboard → Metrics

# 4. Error logs
# Railway dashboard → Logs

# 5. Backup
# PostgreSQL → Backup → Download
```

#### **Haftalik:**

```bash
☐ Database backup download
☐ Error logs review
☐ Performance metrics check
☐ User feedback review
☐ Menu updates (if needed)
```

#### **Oylik:**

```bash
☐ Full system backup
☐ Security audit
☐ Software updates
☐ NFC tags inspection
☐ Training refresh for staff
```

---

## 8️⃣ TEXNIK YORDAM

### 📞 **24/7 SUPPORT**

```
Level 1: Ofitsiantlar (On-site)
  - Oddiy muammolar: WiFi, NFC
  - Response: Darhol

Level 2: Manager
  - O'rtacha muammolar: Admin panel, menyu
  - Response: 1-2 soat

Level 3: Siz (Developer)
  - Murakkab muammolar: Server, database
  - Response: 2-4 soat
  - Emergency: 30 daqiqa

Kontakt:
  Phone: +998 XX XXX XX XX
  Telegram: @your_username
  Email: support@your-company.com
```

### 🛠️ **REMOTE SUPPORT TOOLS**

```
1. Railway Dashboard
   - Server logs
   - Database query
   - Environment variables

2. TeamViewer / AnyDesk
   - Remote desktop access
   - Admin panel troubleshooting

3. Telegram Bot (Optional)
   - Real-time notifications
   - Error alerts
   - System status
```

---

## 📈 MUVAFFAQIYAT MEZONLARI

### ✅ **O'RNATISH MUVAFFAQIYATLI DEYILADI:**

```
☐ Server 99.9% uptime
☐ Database queries < 100ms
☐ Page load < 2 seconds
☐ Zero data loss
☐ Xodimlar o'qitilgan
☐ Mijozlar qoniqish > 90%
☐ Technical issues < 1 per week
☐ Backup system ishlayapti
```

### 📊 **KPI (Key Performance Indicators):**

```
Week 1:
  - System uptime: > 95%
  - User satisfaction: > 80%
  - Orders processed: > 100

Month 1:
  - System uptime: > 99%
  - User satisfaction: > 90%
  - Orders processed: > 1000
  - Average order time: < 5 min

Month 3:
  - System uptime: > 99.9%
  - User satisfaction: > 95%
  - Orders processed: > 5000
  - Zero major incidents
```

---

## 🎓 QOLLANMA OXIRI

**Ushbu qo'llanma sizga quyidagilarni beradi:**

✅ Professional o'rnatish jarayoni  
✅ Barcha texnik detallar  
✅ Muammolarni hal qilish yo'llari  
✅ Xodimlarni o'qitish metodikasi  
✅ 24/7 support strategiya  

**Muvaffaqiyatlar! 🚀**

---

**Versiya:** 1.0  
**Oxirgi yangilanish:** 2026-11-11  
**Muallif:** NFC Luxury Restaurant Team  
**Litsenziya:** Proprietary
