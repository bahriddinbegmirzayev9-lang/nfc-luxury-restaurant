# 🚀 QUICK START GUIDE - LOYIHANI SINASH

## ⚡ TEZKOR BOSHLASH (Avtomatik)

Bitta buyruq bilan hamma narsani ishga tushiring:

```bash
cd /home/hacker/nfc-luxury-restaurant
./start.sh
```

Bu script:
- PostgreSQL ni tekshiradi va ishga tushiradi
- Database yaratadi
- Schema yuklaydi
- Default waiter account yaratadi
- Backend va Client ni ishga tushiradi

---

## 📋 QADAMMA-QADAM (Manual)

Agar avtomatik script ishlamasa, qo'lda bajaring:

### 1️⃣ PostgreSQL ni ishga tushirish

```bash
# PostgreSQL serverini yoqish
sudo systemctl start postgresql

# Holat tekshirish
sudo systemctl status postgresql
```

### 2️⃣ Database yaratish

```bash
# PostgreSQL ga kirish
sudo -u postgres psql

# Database yaratish
CREATE DATABASE nfc_luxury_restaurant;

# Chiqish
\q
```

### 3️⃣ Database schema yuklash

```bash
cd /home/hacker/nfc-luxury-restaurant
sudo -u postgres psql -d nfc_luxury_restaurant -f database/schema.sql
```

### 4️⃣ Default waiter account yaratish

```bash
sudo -u postgres psql -d nfc_luxury_restaurant << 'EOF'
-- Password: admin123
INSERT INTO waiters (name, phone, email, password_hash, role)
VALUES (
  'Admin Waiter', 
  '+998901234567', 
  'admin@restaurant.uz', 
  '$2b$10$rKJ5qZ9YH.nYvVJf9xqXxu8J7qZ9YH.nYvVJf9xqXxu8J7qZ9YH.n', 
  'admin'
) ON CONFLICT (phone) DO NOTHING;
EOF
```

### 5️⃣ Backend ishga tushirish (Terminal 1)

```bash
cd /home/hacker/nfc-luxury-restaurant/backend
npm run dev
```

✅ Backend: http://localhost:5000

### 6️⃣ Client ishga tushirish (Terminal 2)

```bash
# Yangi terminal oching
cd /home/hacker/nfc-luxury-restaurant/client
npm run dev
```

✅ Client: http://localhost:5173

### 7️⃣ Admin Desktop App (ixtiyoriy) (Terminal 3)

```bash
# Yangi terminal oching
cd /home/hacker/nfc-luxury-restaurant/admin-desktop
npm start
```

---

## 🧪 SINASH JARAYONI

### TEST 1: Backend API Tekshirish

```bash
# Health check
curl http://localhost:5000/health

# Menu kategoriyalarini olish
curl http://localhost:5000/api/v1/menu/categories

# Menu itemlarni olish
curl http://localhost:5000/api/v1/menu/items
```

### TEST 2: Web App Ochish

1. Brauzerda oching: http://localhost:5173
2. Ko'rinishi kerak: **NFC Scan Page** (Gold rangda luxury dizayn)

### TEST 3: NFC ni Sinash (2 ta yo'l)

#### Yo'l 1: Manual Table Entry (Oson yo'l)
1. Web app ochiq tursin
2. "Enter Table Number Manually" tugmasini bosing
3. Table number kiriting: `1` (yoki `2`, `3`, etc.)
4. "Continue" bosing
5. **Menu sahifasi ochiladi** ✅

#### Yo'l 2: NFC Scan (Android telefon kerak)
1. Android telefon + Chrome browser kerak
2. http://localhost:5173 ochiladi
3. "Tap Your Phone to Table Scanner" tugmasini bosing
4. NFC tagni scan qiling (agar bor bo'lsa)

### TEST 4: Menu va Buyurtma

1. **Menu sahifasida**:
   - Kategoriyalarni ko'ring (Salatlar, Sho'rvalar, etc.)
   - Ovqatlarni tanlang
   - "+" tugmasini bosib savatga qo'shing

2. **Cart (Savat)**:
   - "View Cart" tugmasini bosing
   - Miqdorni o'zgartiring (+/-)
   - "Place Order" bosing

3. **Order Tracking**:
   - Order holati ko'rsatiladi
   - Animation bilan progress ko'rsatiladi
   - "Served" holatiga o'tadi

### TEST 5: Admin Desktop App

```bash
cd /home/hacker/nfc-luxury-restaurant/admin-desktop
npm start
```

Desktop app ochiladi:
- Dashboard ko'rsatiladi
- Orders ro'yxati
- Statistics
- Real-time updates

---

## 🐛 MUAMMOLAR VA YECHIMLAR

### Muammo 1: PostgreSQL ishlamayapti
```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Muammo 2: Port band (5000 yoki 5173)
```bash
# Portni tekshirish
sudo lsof -i :5000
sudo lsof -i :5173

# Process ni to'xtatish
kill -9 <PID>
```

### Muammo 3: Database connection error
.env faylni tekshiring:
```bash
cd /home/hacker/nfc-luxury-restaurant/backend
cat .env
```

DB_PASSWORD ni to'g'ri qiling:
```
DB_PASSWORD=your_postgres_password
```

### Muammo 4: npm modules yo'q
```bash
# Backend
cd backend && npm install

# Client
cd ../client && npm install

# Admin
cd ../admin-desktop && npm install
```

---

## 📱 DEMO UCHUN TEST MA'LUMOTLAR

Database schema avtomatik yaratgan:

### Stollar:
- Table 1, 2, 3, 4, 5, 6, 7, 8

### Menu Kategoriyalar:
- 🥗 Salatlar
- 🍲 Sho'rvalar  
- 🍖 Asosiy taomlar
- 🍕 Pitsa
- 🍰 Desert
- 🥤 Ichimliklar

### Waiter Account:
- Phone: `+998901234567`
- Password: `admin123`

---

## ✅ HAMMASI ISHLAYOTGANINI TEKSHIRISH

### Backend:
```bash
curl http://localhost:5000/health
```
Javob: `{"success":true,"message":"NFC Luxury Restaurant API is running"}`

### Client:
Brauzerda: http://localhost:5173
Ko'rinadi: Luxury NFC Scan sahifasi

### Database:
```bash
sudo -u postgres psql -d nfc_luxury_restaurant -c "SELECT COUNT(*) FROM tables;"
```
Javob: `8` (8 ta stol)

---

## 🎬 VIDEO DEMO QILISH UCHUN

1. Backend va Client ishga tushiring
2. Brauzerda http://localhost:5173 oching
3. "Enter Table Number Manually" → `5` → "Continue"
4. Menu sahifasida ovqatlarni tanlang
5. Savatga qo'shing
6. "View Cart" bosing
7. "Place Order" bosing
8. Order tracking animatsiyasini ko'ring
9. "Call Waiter" va "Request Bill" tugmalarini sinang

---

## 🎨 NIMALARNI KO'RASIZ?

✨ **Luxury Design Features:**
- Animated gradient background
- Glassmorphism cards
- Gold gradient buttons
- Smooth 60fps animations
- 3D hover effects
- Premium fonts (Playfair Display)
- Real-time progress tracking

---

## 📞 DEFAULT ACCOUNTS

**Waiter Login (Admin Desktop):**
- Phone: `+998901234567`
- Password: `admin123`
- Role: Admin

---

## 💡 TIPS

1. **Ikki terminal oching**: bittasida backend, ikkinchisida client
2. **DevTools oching** (F12): Console'da xatolarni ko'ring
3. **Network tab** ochib API requestlarni kuzating
4. **Table number 1-8** orasida istalganini kiriting

---

**🚀 OMAD! SINAB KO'RING VA BAHOLANG!**

Agar muammo bo'lsa, error messageni yuboring - tezda yechib beraman! 💪
