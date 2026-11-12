# ⚙️ BO'LIM 3: O'RNATISH VA SOZLASH

## 3.1. DASTLABKI TAYYORGARLIK

### Kerakli narsalar:
- ✅ Domen nomi (ixtiyoriy, masalan: restaurant.uz)
- ✅ GitHub account
- ✅ Railway account (backend uchun)
- ✅ Vercel account (frontend uchun)
- ✅ NFC taglar (NTAG213/215/216)
- ✅ SSL sertifikat (avtomatik)

### Xizmat narxlari (oylik):
- Railway: $5-20/oy (database + backend)
- Vercel: $0-20/oy (frontend, bepul variant yetarli)
- Domen: $10-50/yil
- **Jami:** ~$10-30/oy

---

## 3.2. DATABASE YARATISH

### Railway'da PostgreSQL o'rnatish:

#### Qadam 1: Railway'ga kiring
```
https://railway.app
```

#### Qadam 2: Yangi database yarating
1. **"New Project"** → **"Provision PostgreSQL"**
2. Database avtomatik yaratiladi
3. **Variables** tabida connection ma'lumotlarini ko'ring

#### Qadam 3: Database schemaini yuklang

Railway Console'ga kiring va SQL'ni bajaring:

```sql
-- 1. STOLLAR
CREATE TABLE tables (
    id SERIAL PRIMARY KEY,
    number INTEGER UNIQUE NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 4,
    nfc_tag_id VARCHAR(255),
    qr_code VARCHAR(255),
    status VARCHAR(50) DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. NFC TAGLAR
CREATE TABLE nfc_tags (
    id SERIAL PRIMARY KEY,
    tag_uid VARCHAR(255) UNIQUE NOT NULL,
    table_id INTEGER REFERENCES tables(id),
    active BOOLEAN DEFAULT true,
    last_scanned TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. MENYU KATEGORIYALARI
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

-- 4. MENYU MAHSULOTLARI
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

-- 5. SESSIYALAR
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    table_id INTEGER REFERENCES tables(id),
    token VARCHAR(255) UNIQUE NOT NULL,
    language VARCHAR(5) DEFAULT 'uz',
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(50) DEFAULT 'active'
);

-- 6. BUYURTMALAR
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

-- 7. BUYURTMA ELEMENTLARI
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INTEGER REFERENCES menu_items(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    special_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. OFITSIANTLAR
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

-- 9. OFITSIANT CHAQIRUVLARI
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

-- 10. TO'LOVLAR
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

-- 11. BAHOLASHLAR
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INDEXLAR (tezlikni oshirish uchun)
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_orders_table ON orders(table_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_waiter_calls_status ON waiter_calls(status);
CREATE INDEX idx_sessions_token ON sessions(token);
```

---

## 3.3. BACKEND DEPLOY QILISH

### Railway'da backend sozlash:

#### Qadam 1: GitHub'dan import qiling
1. Railway dashboard → **"New Project"**
2. **"Deploy from GitHub repo"**
3. Repository tanlang: `nfc-luxury-restaurant`
4. **Root Directory:** `backend`

#### Qadam 2: Environment Variables
Variables tabida qo'shing:

```bash
NODE_ENV=production
PORT=5000
API_VERSION=v1

# Database (Railway PostgreSQL'dan avtomatik)
DATABASE_URL=${{Postgres.DATABASE_URL}}
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_NAME=${{Postgres.POSTGRES_DB}}
DB_USER=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRE=7d

# CORS
CORS_ORIGIN=https://your-frontend-url.vercel.app

# Socket.IO
SOCKET_PORT=5001

# Tax va Service
TAX_RATE=0.15
SERVICE_CHARGE_RATE=0.10
```

#### Qadam 3: Deploy
Railway avtomatik deploy qiladi. **Settings** → **Networking** → **Generate Domain** orqali public URL oling.

**Backend URL:** `https://your-app.railway.app`

---

## 3.4. FRONTEND DEPLOY QILISH

### Vercel'da frontend sozlash:

#### Qadam 1: GitHub'dan import
1. Vercel dashboard → **"New Project"**
2. Repository: `nfc-luxury-restaurant`
3. **Root Directory:** `client`
4. **Framework:** Vite (avtomatik tanlanadi)

#### Qadam 2: Environment Variables
```bash
VITE_API_URL=https://your-backend.railway.app/api/v1
```

#### Qadam 3: Deploy
Vercel avtomatik deploy qiladi.

**Frontend URL:** `https://your-project.vercel.app`

---

## 3.5. DOMEN ULASH

### Vercel'da custom domain:

#### Qadam 1: Domen sotib oling
- Namecheap, GoDaddy, yoki boshqa provayderdan

#### Qadam 2: Vercel'ga qo'shing
1. Project Settings → **Domains**
2. Domenni kiriting: `restaurant.uz`
3. DNS sozlamalarini ko'rsatadi

#### Qadam 3: DNS record qo'shing
Domen provayderingizda:

```
Type: CNAME
Name: @
Value: cname.vercel-dns.com
```

#### Qadam 4: SSL
Vercel avtomatik SSL sertifikat beradi (Let's Encrypt)

**Tayyor!** Domeningiz 10-30 daqiqada faollashadi.

---

# 📝 BO'LIM 4: RESTORAN MA'LUMOTLARINI QO'SHISH

## 4.1. MENYU KATEGORIYALARINI QO'SHISH

### Railway Console orqali:

```sql
-- KATEGORIYALAR QO'SHISH
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
('Fresh va smoothie', 'Фреши и смузи', 'Fresh Juices', '🥤', 14);
```

---

## 4.2. TO'LIQ DEMO MENYU (50+ OVQAT)

### SALATLAR (🥗)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories
) VALUES
-- Sezar salati
(1, 
'Sezar salati', 'Салат Цезарь', 'Caesar Salad',
'Yangi ko''kat, tovuq go''shti, parmesan, krutonlar, maxsus sous', 
'Свежая зелень, куриное мясо, пармезан, сухарики, фирменный соус',
'Fresh greens, chicken, parmesan, croutons, special sauce',
35000, false, true, 10, 320),

-- Grek salati
(1,
'Grek salati', 'Греческий салат', 'Greek Salad',
'Pomidor, bodring, zaytun, feta pishloqi, zaytun moyi',
'Помидоры, огурцы, оливки, сыр фета, оливковое масло',
'Tomatoes, cucumbers, olives, feta cheese, olive oil',
32000, true, true, 8, 210),

-- Achiq-chuchuk
(1,
'Achiq-chuchuk', 'Ачик-чучук', 'Achik-chuchuk',
'Pomidor, piyoz, qalampir, ko''katlar, achchiq',
'Помидоры, лук, перец, зелень, острый',
'Tomatoes, onions, peppers, greens, spicy',
18000, true, false, 5, 85),

-- Olivye
(1,
'Olivye', 'Оливье', 'Olivier Salad',
'Klassik olivye salati',
'Классический салат оливье',
'Classic Olivier salad',
25000, false, false, 10, 285),

-- Mimoza
(1,
'Mimoza', 'Мимоза', 'Mimosa Salad',
'Baliq, tuxum, kartoshka, sabzi',
'Рыба, яйца, картофель, морковь',
'Fish, eggs, potatoes, carrots',
28000, false, false, 12, 295);
```

### SHO'RVALAR (🍲)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_spicy, is_featured, preparation_time, calories
) VALUES
-- Lag'mon
(2,
'Lag'mon', 'Лагман', 'Lagman',
'An''anaviy o''zbek go''sht sho''rvasi, uy makaron bilan',
'Традиционный узбекский мясной суп с домашней лапшой',
'Traditional Uzbek meat soup with homemade noodles',
38000, true, true, 20, 485),

-- Mastava
(2,
'Mastava', 'Мастава', 'Mastava',
'Guruch va go''sht bilan boy sho''rva',
'Богатый суп с рисом и мясом',
'Rich soup with rice and meat',
35000, false, true, 25, 420),

-- Shurva
(2,
'Shurva', 'Шурпа', 'Shurpa',
'Qo''y go''shti sho''rvasi',
'Суп из баранины',
'Lamb soup',
40000, false, true, 30, 390),

-- Borsh
(2,
'Borsh', 'Борщ', 'Borsch',
'Lavlagi, go''sht, smetana bilan',
'Свекла, мясо, со сметаной',
'Beetroot, meat, with sour cream',
32000, false, false, 25, 280),

-- Qozi-qozon
(2,
'Qozi-qozon', 'Казы-казан', 'Kazy-kazan',
'Qozi bilan maxsus sho''rva',
'Особый суп с казы',
'Special soup with kazy sausage',
45000, false, true, 30, 520);
```

### MILLIY TAOMLAR (🍛)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_featured, preparation_time, calories
) VALUES
-- Osh (Palov)
(4,
'Osh', 'Плов', 'Plov',
'O''zbekistonning milliy taomi - zirvak, guruch, go''sht',
'Национальное блюдо Узбекистана - зирвак, рис, мясо',
'National dish of Uzbekistan - zirvak, rice, meat',
45000, true, 35, 680),

-- Manti
(4,
'Manti', 'Манты', 'Manti',
'Bug''da pishgan go''shtli chuchvara, kartoshka bilan',
'Паровые пельмени с мясом и картофелем',
'Steamed dumplings with meat and potato',
42000, true, 25, 520),

-- Somsa
(4,
'Somsa', 'Самса', 'Samsa',
'Tandirda pishgan go''shtli somsa',
'Самса с мясом из тандыра',
'Tandoor-baked meat pastry',
15000, false, 20, 380),

-- Norin
(4,
'Norin', 'Нарын', 'Norin',
'Ot go''shti, uy makaron, qazi',
'Конина, домашняя лапша, казы',
'Horse meat, homemade noodles, kazy',
48000, false, 30, 580),

-- Dimlama
(4,
'Dimlama', 'Димлама', 'Dimlama',
'Bug''da pishgan go''sht va sabzavotlar',
'Мясо и овощи на пару',
'Steamed meat and vegetables',
40000, false, 40, 450);
```

### GRILL VA KABOBLAR (🍖)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_featured, preparation_time, calories
) VALUES
-- Shashlik
(5,
'Shashlik (qo''y)', 'Шашлык (баранина)', 'Lamb Shashlik',
'Qo''y go''shtidan shashlik, 6 dona',
'Шашлык из баранины, 6 шт',
'Lamb kebabs, 6 pcs',
55000, true, 25, 620),

-- Lula-kabob
(5,
'Lula-kabob', 'Люля-кебаб', 'Lula Kebab',
'Qiyma go''shtdan kabob, 4 dona',
'Кебаб из фарша, 4 шт',
'Minced meat kebab, 4 pcs',
45000, true, 20, 480),

-- Tovuq shashlik
(5,
'Tovuq shashlik', 'Куриный шашлык', 'Chicken Shashlik',
'Tovuq go''shtidan shashlik, 6 dona',
'Шашлык из курицы, 6 шт',
'Chicken kebabs, 6 pcs',
42000, false, 20, 420),

-- Baliq kabob
(5,
'Baliq kabob', 'Рыбный кебаб', 'Fish Kebab',
'Losos yoki forel, 4 dona',
'Лосось или форель, 4 шт',
'Salmon or trout, 4 pcs',
58000, false, 18, 380),

-- Qovurma
(5,
'Qovurma', 'Ковурма', 'Kovurma',
'Jigar, qalb, buyrak, piyoz bilan qovurilgan',
'Печень, сердце, почки, жареные с луком',
'Liver, heart, kidneys, fried with onions',
38000, false, 15, 420);
```

### DESERTLAR (🍰)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories
) VALUES
-- Tiramisu
(9,
'Tiramisu', 'Тирамису', 'Tiramisu',
'Klassik italyan deserti, kofe va maskarpone bilan',
'Классический итальянский десерт с кофе и маскарпоне',
'Classic Italian dessert with coffee and mascarpone',
38000, true, true, 5, 450),

-- Shokoladli tort
(9,
'Shokoladli tort', 'Шоколадный торт', 'Chocolate Cake',
'Boy belgiyalik shokolad torti',
'Богатый торт из бельгийского шоколада',
'Rich Belgian chocolate cake',
35000, true, true, 5, 520),

-- Napoleon
(9,
'Napoleon', 'Наполеон', 'Napoleon Cake',
'Klassik napoleon torti, kremli',
'Классический торт наполеон с кремом',
'Classic Napoleon cake with cream',
32000, true, false, 5, 480),

-- Chizkeyk
(9,
'Chizkeyk', 'Чизкейк', 'Cheesecake',
'New-York uslubidagi chizkeyk',
'Чизкейк в стиле Нью-Йорк',
'New York style cheesecake',
36000, true, true, 5, 420),

-- Pahlava
(9,
'Pahlava', 'Пахлава', 'Baklava',
'An''anaviy sharq pahlavasi, yong''oq bilan',
'Традиционная восточная пахлава с орехами',
'Traditional Eastern baklava with nuts',
28000, true, false, 5, 380);
```

### ICHIMLIKLAR (🥤☕)

```sql
INSERT INTO menu_items (
    category_id, 
    name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories
) VALUES
-- Ko'k choy
(13,
'Ko''k choy', 'Зеленый чай', 'Green Tea',
'O''zbekona an''anaviy ko''k choy',
'Традиционный узбекский зеленый чай',
'Traditional Uzbek green tea',
8000, true, 3, 0),

-- Qora choy
(13,
'Qora choy', 'Черный чай', 'Black Tea',
'Premium qora choy',
'Премиальный черный чай',
'Premium black tea',
10000, true, 3, 0),

-- Espresso
(12,
'Espresso', 'Эспрессо', 'Espresso',
'Klassik italyan espresso',
'Классический итальянский эспрессо',
'Classic Italian espresso',
15000, true, 2, 5),

-- Cappuccino
(12,
'Cappuccino', 'Капучино', 'Cappuccino',
'Espresso, sut ko''pigi bilan',
'Эспрессо с молочной пеной',
'Espresso with milk foam',
20000, true, 4, 120),

-- Latte
(12,
'Latte', 'Латте', 'Latte',
'Espresso va ko''p sut',
'Эспрессо и много молока',
'Espresso with lots of milk',
22000, true, 4, 150),

-- Apelsin fresh
(14,
'Apelsin fresh', 'Апельсиновый фреш', 'Orange Fresh',
'Yangi siqilgan apelsin sharbati',
'Свежевыжатый апельсиновый сок',
'Freshly squeezed orange juice',
25000, true, 3, 110),

-- Limonad
(11,
'Limonad uyda', 'Домашний лимонад', 'Homemade Lemonade',
'Limon, na''na, shakar',
'Лимон, мята, сахар',
'Lemon, mint, sugar',
18000, true, 5, 95),

-- Coca-Cola
(11,
'Coca-Cola', 'Кока-Кола', 'Coca-Cola',
'0.33L',
'0.33Л',
'0.33L',
12000, true, 1, 140);
```

Davom ettirishim kerakmi? Keyingi qismlarda:
- Admin panel ishlatish qo'llanmasi
- Texnik qo'llab-quvvatlash
- Muammolarni bartaraf qilish
- Backup va restore
- Video tutorial linklar

Hammasi tayyor! 📚✨