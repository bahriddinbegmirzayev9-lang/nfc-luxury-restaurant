# 🚂 RAILWAY DATABASE SOZLASH VA TO'LDIRISH

## QADAM-MA-QADAM YO'RIQNOMA

---

## 1️⃣ RAILWAY'GA KIRISH

1. Brauzerda oching: https://railway.app
2. GitHub orqali login qiling
3. Loyihangizni toping: **nfc-luxury-restaurant**

---

## 2️⃣ DATABASE CONSOLE'NI OCHISH

### Yo'l 1: PostgreSQL Console
1. Railway Dashboard'da **PostgreSQL** ni bosing
2. Yuqorida **"Data"** tabini bosing
3. **"Query"** tugmasini bosing
4. SQL console ochiladi ✅

### Yo'l 2: psql CLI
1. Railway Dashboard → PostgreSQL
2. **"Connect"** tugmasi
3. **"psql"** commandasini ko'chiring
4. Terminalda ishlatish

---

## 3️⃣ DATABASE'NI TO'LDIRISH

### Variant A: Butun faylni yuklash (TAVSIYA)

```bash
# 1. Terminalda loyiha papkasiga o'ting
cd /home/hacker/nfc-luxury-restaurant

# 2. Railway database URL'ni oling
# Railway Dashboard → PostgreSQL → Connect → Database URL

# 3. Faylni yuklang
psql "postgresql://username:password@host:port/database" < DATABASE-COMPLETE-DEMO.sql
```

**✅ Tayyor! Bir buyruqda hammasi yuklandi!**

---

### Variant B: Railway Console orqali (agar terminal ishlamasa)

**MUHIM:** SQL'ni qismlarga bo'lib yuklang!

#### QISM 1: Jadvallarni yaratish

Railway Query Console'da bajaring:

```sql
-- Eski jadvallarni o'chirish
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS waiter_calls CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS menu_categories CASCADE;
DROP TABLE IF EXISTS waiters CASCADE;
DROP TABLE IF EXISTS nfc_tags CASCADE;
DROP TABLE IF EXISTS tables CASCADE;
```

**Execute** bosing ✅

---

#### QISM 2: Jadvallarni yaratish

```sql
-- STOLLAR
CREATE TABLE tables (
    id SERIAL PRIMARY KEY,
    number INTEGER UNIQUE NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 4,
    nfc_tag_id VARCHAR(255),
    qr_code VARCHAR(255),
    status VARCHAR(50) DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NFC TAGLAR
CREATE TABLE nfc_tags (
    id SERIAL PRIMARY KEY,
    tag_uid VARCHAR(255) UNIQUE NOT NULL,
    table_id INTEGER REFERENCES tables(id),
    active BOOLEAN DEFAULT true,
    last_scanned TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- KATEGORIYALAR
CREATE TABLE menu_categories (
    id SERIAL PRIMARY KEY,
    name_uz VARCHAR(255) NOT NULL,
    name_ru VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    icon VARCHAR(10),
    sort_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- OVQATLAR
CREATE TABLE menu_items (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES menu_categories(id),
    name_uz VARCHAR(255) NOT NULL,
    name_ru VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    description_uz TEXT,
    description_ru TEXT,
    description_en TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    is_vegetarian BOOLEAN DEFAULT false,
    is_spicy BOOLEAN DEFAULT false,
    preparation_time INTEGER,
    calories INTEGER,
    ingredients TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SESSIYALAR
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    table_id INTEGER REFERENCES tables(id),
    token VARCHAR(255) UNIQUE NOT NULL,
    language VARCHAR(5) DEFAULT 'uz',
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(50) DEFAULT 'active'
);

-- BUYURTMALAR
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id),
    table_id INTEGER REFERENCES tables(id),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    service_charge DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'unpaid',
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BUYURTMA DETALLARI
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INTEGER REFERENCES menu_items(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    special_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- OFITSIANTLAR
CREATE TABLE waiters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar TEXT,
    status VARCHAR(50) DEFAULT 'offline',
    role VARCHAR(50) DEFAULT 'waiter',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CHAQIRUVLAR
CREATE TABLE waiter_calls (
    id SERIAL PRIMARY KEY,
    table_id INTEGER REFERENCES tables(id),
    session_id INTEGER REFERENCES sessions(id),
    call_type VARCHAR(50) NOT NULL,
    priority VARCHAR(50) DEFAULT 'normal',
    waiter_id INTEGER REFERENCES waiters(id),
    status VARCHAR(50) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP,
    resolved_at TIMESTAMP
);

-- TO'LOVLAR
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending',
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BAHOLASHLAR
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Execute** bosing ✅

---

#### QISM 3: Indexlar

```sql
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_menu_items_available ON menu_items(is_available);
CREATE INDEX idx_menu_items_featured ON menu_items(is_featured);
CREATE INDEX idx_orders_table ON orders(table_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_waiter_calls_status ON waiter_calls(status);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_table ON sessions(table_id);
```

**Execute** bosing ✅

---

#### QISM 4: Stollar va NFC taglar

```sql
-- 20 ta stol
INSERT INTO tables (number, capacity, qr_code, status) VALUES
(1, 2, 'QR-001', 'available'),
(2, 4, 'QR-002', 'available'),
(3, 4, 'QR-003', 'available'),
(4, 6, 'QR-004', 'available'),
(5, 4, 'QR-005', 'available'),
(6, 2, 'QR-006', 'available'),
(7, 4, 'QR-007', 'available'),
(8, 6, 'QR-008', 'available'),
(9, 8, 'QR-009', 'available'),
(10, 4, 'QR-010', 'available'),
(11, 4, 'QR-011', 'available'),
(12, 6, 'QR-012', 'available'),
(13, 2, 'QR-013', 'available'),
(14, 4, 'QR-014', 'available'),
(15, 4, 'QR-015', 'available'),
(16, 6, 'QR-016', 'available'),
(17, 8, 'QR-017', 'available'),
(18, 4, 'QR-018', 'available'),
(19, 6, 'QR-019', 'available'),
(20, 10, 'QR-020', 'available');

-- 20 ta NFC tag
INSERT INTO nfc_tags (tag_uid, table_id, active) VALUES
('NTAG213-0001', 1, true),
('NTAG213-0002', 2, true),
('NTAG213-0003', 3, true),
('NTAG213-0004', 4, true),
('NTAG213-0005', 5, true),
('NTAG213-0006', 6, true),
('NTAG213-0007', 7, true),
('NTAG213-0008', 8, true),
('NTAG213-0009', 9, true),
('NTAG213-0010', 10, true),
('NTAG213-0011', 11, true),
('NTAG213-0012', 12, true),
('NTAG213-0013', 13, true),
('NTAG213-0014', 14, true),
('NTAG213-0015', 15, true),
('NTAG213-0016', 16, true),
('NTAG213-0017', 17, true),
('NTAG213-0018', 18, true),
('NTAG213-0019', 19, true),
('NTAG213-0020', 20, true);
```

**Execute** bosing ✅

---

#### QISM 5: Ofitsiantlar (MUHIM - parolni o'zgartiring!)

**⚠️ DIQQAT:** `YourHashedPasswordHere` ni haqiqiy hash bilan almashtiring!

**Parolni hash qilish:**
```bash
# Terminalda
node -e "console.log(require('bcrypt').hashSync('admin123', 10))"
```

Keyin:

```sql
INSERT INTO waiters (name, phone, email, password, role, status, avatar) VALUES
('Admin Rahimov', '+998901234567', 'admin@restaurant.uz',
'$2b$10$[HASH_NI_SHU_YERGA_QO''YING]', 'admin', 'online',
'https://i.pravatar.cc/150?img=12'),

('Sardor Karimov', '+998901111111', 'sardor@restaurant.uz',
'$2b$10$[HASH_NI_SHU_YERGA_QO''YING]', 'waiter', 'online',
'https://i.pravatar.cc/150?img=33'),

('Aziza Nurmatova', '+998902222222', 'aziza@restaurant.uz',
'$2b$10$[HASH_NI_SHU_YERGA_QO''YING]', 'waiter', 'online',
'https://i.pravatar.cc/150?img=47'),

('Botir Saidov', '+998903333333', 'botir@restaurant.uz',
'$2b$10$[HASH_NI_SHU_YERGA_QO''YING]', 'waiter', 'offline',
'https://i.pravatar.cc/150?img=56'),

('Malika Yusupova', '+998904444444', 'malika@restaurant.uz',
'$2b$10$[HASH_NI_SHU_YERGA_QO''YING]', 'manager', 'online',
'https://i.pravatar.cc/150?img=44');
```

**Execute** bosing ✅

---

#### QISM 6: Kategoriyalar

```sql
INSERT INTO menu_categories (name_uz, name_ru, name_en, icon, sort_order) VALUES
('Salatlar', 'Салаты', 'Salads', '🥗', 1),
('Sho''rvalar', 'Супы', 'Soups', '🍲', 2),
('Issiq taomlar', 'Горячие блюда', 'Hot Dishes', '🍽️', 3),
('Milliy taomlar', 'Национальные блюда', 'National Dishes', '🍛', 4),
('Grill va kaboblar', 'Гриль и шашлыки', 'Grill & Kebabs', '🍖', 5),
('Makaron va pasta', 'Паста', 'Pasta', '🍝', 6),
('Pizza', 'Пицца', 'Pizza', '🍕', 7),
('Baliqlar', 'Рыба', 'Fish', '🐟', 8),
('Desertlar', 'Десерты', 'Desserts', '🍰', 9),
('Muzqaymoqlar', 'Мороженое', 'Ice Cream', '🍨', 10),
('Ichimliklar', 'Напитки', 'Beverages', '🥤', 11),
('Kofe', 'Кофе', 'Coffee', '☕', 12),
('Choylar', 'Чай', 'Tea', '🍵', 13),
('Fresh va smoothie', 'Фреши и смузи', 'Fresh Juices', '🧃', 14);
```

**Execute** bosing ✅

---

## 4️⃣ OVQATLARNI QO'SHISH

**MUHIM:** `DATABASE-COMPLETE-DEMO.sql` faylida 65+ ovqat bor!

Railway Console'da fayl juda katta bo'lishi mumkin. Shuning uchun:

### Variant 1: Terminal orqali (ENG OSON)

```bash
cd /home/hacker/nfc-luxury-restaurant

# Railway database URL'ni kiriting
export DATABASE_URL="postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway"

# Faqat ovqatlarni qo'shish
psql $DATABASE_URL < DATABASE-COMPLETE-DEMO.sql
```

### Variant 2: Qo'lda qo'shish

`DATABASE-COMPLETE-DEMO.sql` faylini oching va har bir `INSERT` statementni alohida copy-paste qiling Railway Console'ga.

**Qismlarga bo'ling:**
1. Salatlar (5 ta)
2. Sho'rvalar (5 ta)
3. Milliy taomlar (5 ta)
4. Kaboblar (5 ta)
5. Pasta (3 ta)
6. Pizza (4 ta)
7. Desertlar (6 ta)
8. Muzqaymoq (3 ta)
9. Choylar (3 ta)
10. Kofe (5 ta)
11. Ichimliklar (5 ta)
12. Fresh (5 ta)

---

## 5️⃣ TEKSHIRISH

Database to'ldirildi! Keling tekshiramiz:

```sql
-- Nechta kategoriya bor?
SELECT COUNT(*) FROM menu_categories;
-- Javob: 14 ✅

-- Nechta ovqat bor?
SELECT COUNT(*) FROM menu_items;
-- Javob: 60+ ✅

-- Nechta stol bor?
SELECT COUNT(*) FROM tables;
-- Javob: 20 ✅

-- Ofitsiantlar?
SELECT COUNT(*) FROM waiters;
-- Javob: 5 ✅

-- Kategoriyalar ro'yxati
SELECT id, name_uz, name_en, icon FROM menu_categories ORDER BY sort_order;

-- Ovqatlar ro'yxati (birinchi 10 ta)
SELECT id, name_uz, price FROM menu_items LIMIT 10;
```

---

## 6️⃣ FRONTEND'NI SINASH

1. Brauzerda oching: **https://client-ebon-delta.vercel.app**
2. Til tanlang: **O'zbek**
3. Stol raqami: **5**
4. Menyu ko'ring - **65+ ovqat ko'rinishi kerak!** ✅

---

## 🎉 TAYYOR!

✅ Database yaratildi  
✅ 11 jadval  
✅ 20 stol  
✅ 20 NFC tag  
✅ 5 ofitsiant  
✅ 14 kategoriya  
✅ 65+ ovqat va ichimlik  

**Endi to'liq ishlaydigan demo bor!** 🚀

---

## 🆘 MUAMMO BO'LSA

### Database connection xatosi?
```bash
# Railway'da environment variables tekshiring:
DATABASE_URL
DB_HOST
DB_PORT
DB_NAME
DB_USER
DB_PASSWORD
```

### Ovqatlar ko'rinmayapti?
```sql
-- Menu itemsni tekshiring:
SELECT * FROM menu_items WHERE is_available = true LIMIT 5;

-- Kategoriyalarni tekshiring:
SELECT * FROM menu_categories WHERE active = true;
```

### Backend ishlamayapti?
- Railway Dashboard → Backend service → Logs
- Xatolarni o'qing
- Environment variables to'g'rimi tekshiring

---

## 📞 YORDAM

Telegram: @nfc_restaurant_support  
Email: support@nfc-restaurant.uz

---

**OMAD!** 🍀
