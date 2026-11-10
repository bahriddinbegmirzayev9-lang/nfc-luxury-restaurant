# 🏆 NFC Luxury Restaurant System
## Dubai-darajali Premium Restoran Tizimi

### 🎯 LOYIHA MAQSADI
Mijozlar telefonlarini NFC orqali stol skanerga qo'yib, premium web ilovadan:
- Luksuzli animatsiyali menyu ko'rish
- Buyurtma berish
- Afitsiantni chaqirish
- Shot chiqarish

Afitsiantlar esa desktop ilovasidan (EXE):
- Real-time buyurtmalarni ko'rish
- Stollarni boshqarish
- Mijozlar bilan aloqa
- Dashboard va statistika

---

## 🏗️ TEXNOLOGIYA STACK

### Backend (API Server)
- **Runtime:** Node.js v20+
- **Framework:** Express.js
- **Database:** PostgreSQL 15
- **Real-time:** Socket.io
- **Auth:** JWT tokens
- **NFC:** NFC tag ID validation

### Client (Mijozlar Web Ilova)
- **Framework:** React 18 + Vite
- **NFC:** Web NFC API
- **Styling:** TailwindCSS + Framer Motion
- **3D Effects:** Three.js
- **State:** Zustand
- **UI Library:** Radix UI + Custom components

### Admin Desktop (Afitsiantlar)
- **Framework:** Electron + React
- **Build:** Electron Builder → EXE
- **Real-time:** Socket.io client
- **Notifications:** Native desktop notifications

### Database
- **DBMS:** PostgreSQL 15
- **ORM:** Prisma
- **Migration:** Prisma Migrate

---

## 📊 DATABASE SCHEMA

### Tables (jadvallar)
```sql
- tables (stollar: id, number, capacity, nfc_tag_id, status, qr_code)
- menu_categories (turkumlar: id, name_uz, name_ru, name_en, icon, sort_order)
- menu_items (ovqatlar: id, name, description, price, image, category_id, available)
- orders (buyurtmalar: id, table_id, items, total, status, created_at)
- order_items (buyurtma detallari)
- waiters (afitsiantlar: id, name, phone, status, avatar)
- waiter_calls (chaqiruvlar: id, table_id, type, status, created_at)
- nfc_tags (NFC teglar: id, tag_uid, table_id, active)
- sessions (sessiyalar: id, table_id, start_time, end_time)
```

---

## 🎨 DIZAYN KONSEPSIYASI (Dubai Luxury)

### Color Palette
```css
Primary Gold: #D4AF37
Dark Luxury: #1a1a2e
Deep Black: #0f0f1e
Accent Rose Gold: #b76e79
Glass White: rgba(255,255,255,0.1)
```

### UI Features
- **Glassmorphism** (shisha effektlar)
- **3D parallax** animatsiyalar
- **Smooth transitions** (60fps)
- **Micro-interactions** har bir tugmada
- **Gradient meshes** fonda
- **Particle effects** NFC scan paytida
- **Luxury fonts:** Playfair Display, Montserrat

---

## 🔄 USER FLOW

### Mijoz (Customer)
1. Stolga o'tiradi
2. Telefonni NFC skanerga qo'yadi
3. Brauzerda avtomatik web ilova ochiladi
4. 3D animatsiya bilan menyu ko'rsatiladi
5. Ovqatlarni tanlaydi va buyurtma beradi
6. Real-time status ko'radi
7. Afitsiantni chaqirishi mumkin
8. Shot chiqaradi va to'laydi

### Afitsiant (Waiter)
1. Desktop ilovani ochadi (EXE)
2. Login qiladi
3. Real-time buyurtmalarni ko'radi
4. Yangi buyurtma kelganda notification oladi
5. Buyurtma statusini yangilaydi
6. Mijoz chaqiruvlarini ko'radi
7. Shot tayyorlaydi
8. Dashboard'da statistika ko'radi

---

## 🔌 API ENDPOINTS

### NFC & Tables
- POST /api/nfc/scan - NFC tag scan qilish
- GET /api/tables/:id - Stol ma'lumotlari
- GET /api/tables/:id/session - Joriy sessiya

### Menu
- GET /api/menu/categories - Barcha turkumlar
- GET /api/menu/items - Barcha ovqatlar
- GET /api/menu/items/:id - Bitta ovqat

### Orders
- POST /api/orders - Yangi buyurtma
- GET /api/orders/:id - Buyurtma detallari
- PATCH /api/orders/:id/status - Status yangilash
- GET /api/tables/:id/orders - Stol buyurtmalari

### Waiter
- POST /api/waiter-calls - Afitsiantni chaqirish
- GET /api/waiter-calls - Barcha chaqiruvlar
- PATCH /api/waiter-calls/:id - Chaqiruv statusini yangilash

### Bill
- GET /api/orders/:id/bill - Shot olish
- POST /api/orders/:id/payment - To'lov qilish

---

## 🔐 SECURITY
- NFC tag UID validation
- Session management (1 session per table)
- JWT tokens for waiter auth
- Rate limiting
- CORS configuration
- SQL injection prevention (Prisma)

---

## 🚀 DEPLOYMENT
- **Backend:** PM2 + Nginx
- **Database:** PostgreSQL cluster
- **Client:** Static hosting (Vercel/Netlify)
- **Admin:** EXE fayl (Windows installer)

---

## ✨ PREMIUM FEATURES
- **Augmented Reality** menyu (3D ovqatlar)
- **Multi-language** (UZ, RU, EN)
- **Voice commands** buyurtma berish
- **AI recommendations** (ChatGPT integration)
- **Smart suggestions** o'xshash ovqatlar
- **Loyalty points** bonuslar
- **Push notifications** 
- **Offline mode** support
- **Dark/Light theme**
- **Print bill** direct printer

---

## 📱 NFC INTEGRATION
- **Web NFC API** (Chrome Android)
- **NFC tag format:** NDEF
- **Tag content:** `nfc://table/{table_id}`
- **Fallback:** QR code scan
- **Security:** Encrypted tag validation

---

## 🎯 SUCCESS METRICS
- NFC scan success rate > 95%
- Page load time < 2s
- Order creation < 5s
- Real-time latency < 500ms
- UI animations 60fps
- Mobile responsive 100%

---

## 🛠️ DEVELOPMENT PLAN
1. ✅ Arxitektura rejalashtirish
2. 🔄 Database setup + migrations
3. 🔄 Backend API development
4. 🔄 Client web app (React)
5. 🔄 Admin desktop app (Electron)
6. 🔄 NFC integration
7. 🔄 Real-time features
8. 🔄 Premium UI/UX polish
9. 🔄 Testing va optimization
10. 🔄 Build va deployment

---

**VERSION:** 1.0.0  
**START DATE:** 2026-11-04  
**TARGET:** World-class restaurant NFC system 🏆
