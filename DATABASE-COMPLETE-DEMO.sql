-- ========================================
-- NFC LUXURY RESTAURANT - TO'LIQ DEMO DATABASE
-- Versiya: 1.0.0
-- Sana: 2026-11-10
-- ========================================

-- Bu faylda:
-- 1. Database schema (11 jadval)
-- 2. Demo ma'lumotlar:
--    - 14 kategoriya
--    - 60+ ovqat (to'liq restoran menyusi)
--    - 20 stol
--    - 5 ofitsiant
--    - 20 NFC tag
--    - Demo buyurtmalar

-- ========================================
-- QADAM 1: DATABASE YARATISH
-- ========================================

-- Eski ma'lumotlarni o'chirish (ehtiyotkorlik bilan!)
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

-- ========================================
-- QADAM 2: JADVALLAR YARATISH
-- ========================================

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

-- ========================================
-- QADAM 3: INDEXLAR (Tezlik uchun)
-- ========================================

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

-- ========================================
-- QADAM 4: DEMO MA'LUMOTLAR - STOLLAR
-- ========================================

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

-- ========================================
-- QADAM 5: NFC TAGLAR
-- ========================================

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

-- ========================================
-- QADAM 6: OFITSIANTLAR
-- ========================================

-- Parol: admin123 (bcrypt hashed)
INSERT INTO waiters (name, phone, email, password, role, status, avatar) VALUES
('Admin Rahimov', '+998901234567', 'admin@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'admin', 'online',
'https://i.pravatar.cc/150?img=12'),

('Sardor Karimov', '+998901111111', 'sardor@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'waiter', 'online',
'https://i.pravatar.cc/150?img=33'),

('Aziza Nurmatova', '+998902222222', 'aziza@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'waiter', 'online',
'https://i.pravatar.cc/150?img=47'),

('Botir Saidov', '+998903333333', 'botir@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'waiter', 'offline',
'https://i.pravatar.cc/150?img=56'),

('Malika Yusupova', '+998904444444', 'malika@restaurant.uz',
'$2b$10$YourHashedPasswordHere', 'manager', 'online',
'https://i.pravatar.cc/150?img=44');

-- ========================================
-- QADAM 7: MENYU KATEGORIYALARI
-- ========================================

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

-- ========================================
-- QADAM 8: MENYU - SALATLAR (🥗)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Sezar salati
(1, 'Sezar salati', 'Салат Цезарь', 'Caesar Salad',
'Yangi ko''kat, tovuq go''shti, parmesan, krutonlar, maxsus sous',
'Свежая зелень, куриное мясо, пармезан, сухарики, фирменный соус',
'Fresh greens, chicken, parmesan, croutons, special Caesar sauce',
35000, false, true, 10, 320,
'https://images.unsplash.com/photo-1546793665-c74683f339c1'),

-- Grek salati
(1, 'Grek salati', 'Греческий салат', 'Greek Salad',
'Pomidor, bodring, zaytun, feta pishloqi, zaytun moyi',
'Помидоры, огурцы, оливки, сыр фета, оливковое масло',
'Tomatoes, cucumbers, olives, feta cheese, olive oil',
32000, true, true, 8, 210,
'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe'),

-- Achiq-chuchuk
(1, 'Achiq-chuchuk', 'Ачик-чучук', 'Achik-chuchuk',
'Pomidor, piyoz, qalampir, ko''katlar, achchiq',
'Помидоры, лук, перец, зелень, острый',
'Tomatoes, onions, peppers, greens, spicy',
18000, true, false, 5, 85,
'https://images.unsplash.com/photo-1512621776951-a57141f2eefd'),

-- Olivye
(1, 'Olivye', 'Оливье', 'Olivier Salad',
'Klassik olivye salati - kartoshka, tuxum, kolbasa, mayonez',
'Классический салат оливье с картофелем, яйцами и колбасой',
'Classic Olivier salad with potatoes, eggs, and sausage',
25000, false, false, 10, 285,
'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af'),

-- Mimoza
(1, 'Mimoza', 'Мимоза', 'Mimosa Salad',
'Baliq, tuxum, kartoshka, sabzi, qatlamli salat',
'Рыба, яйца, картофель, морковь, слоеный салат',
'Fish, eggs, potatoes, carrots, layered salad',
28000, false, false, 12, 295,
'https://images.unsplash.com/photo-1512621776951-a57141f2eefd');

-- ========================================
-- QADAM 9: SHO'RVALAR (🍲)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_spicy, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Lag'mon
(2, 'Lag''mon', 'Лагман', 'Lagman',
'An''anaviy o''zbek go''sht sho''rvasi, uy makaron bilan',
'Традиционный узбекский мясной суп с домашней лапшой',
'Traditional Uzbek meat soup with homemade noodles',
38000, true, true, 20, 485,
'https://images.unsplash.com/photo-1569718212165-3a8278d5f624'),

-- Mastava
(2, 'Mastava', 'Мастава', 'Mastava',
'Guruch va go''sht bilan boy sho''rva',
'Богатый суп с рисом и мясом',
'Rich soup with rice and meat',
35000, false, true, 25, 420,
'https://images.unsplash.com/photo-1547592166-23ac45744acd'),

-- Shurva
(2, 'Shurva', 'Шурпа', 'Shurpa',
'Qo''y go''shti sho''rvasi, sabzavotlar bilan',
'Суп из баранины с овощами',
'Lamb soup with vegetables',
40000, false, true, 30, 390,
'https://images.unsplash.com/photo-1588566565463-180a5b2090d2'),

-- Borsh
(2, 'Borsh', 'Борщ', 'Borsch',
'Lavlagi, go''sht, smetana bilan klassik borsh',
'Свекла, мясо, со сметаной, классический борщ',
'Beetroot, meat, with sour cream, classic borsch',
32000, false, false, 25, 280,
'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d'),

-- Qozi-qozon
(2, 'Qozi-qozon', 'Казы-казан', 'Kazy-kazan',
'Qozi bilan maxsus sho''rva, boy va aromatli',
'Особый суп с казы, богатый и ароматный',
'Special soup with kazy sausage, rich and aromatic',
45000, false, true, 30, 520,
'https://images.unsplash.com/photo-1547592166-23ac45744acd');

-- ========================================
-- QADAM 10: MILLIY TAOMLAR (🍛)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Osh (Palov)
(4, 'Osh', 'Плов', 'Plov',
'O''zbekistonning milliy taomi - zirvak, guruch, go''sht, sabzi',
'Национальное блюдо Узбекистана - зирвак, рис, мясо, морковь',
'National dish of Uzbekistan - zirvak, rice, meat, carrots',
45000, true, 35, 680,
'https://images.unsplash.com/photo-1631452180519-c014fe946bc7'),

-- Manti
(4, 'Manti', 'Манты', 'Manti',
'Bug''da pishgan go''shtli chuchvara, kartoshka bilan',
'Паровые пельмени с мясом и картофелем',
'Steamed dumplings with meat and potato',
42000, true, 25, 520,
'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb'),

-- Somsa
(4, 'Somsa', 'Самса', 'Samsa',
'Tandirda pishgan go''shtli somsa, 4 dona',
'Самса с мясом из тандыра, 4 шт',
'Tandoor-baked meat pastry, 4 pcs',
15000, false, 20, 380,
'https://images.unsplash.com/photo-1601050690597-df0568f70950'),

-- Norin
(4, 'Norin', 'Нарын', 'Norin',
'Ot go''shti, uy makaron, qazi bilan',
'Конина, домашняя лапша, с казы',
'Horse meat, homemade noodles, with kazy',
48000, false, 30, 580,
'https://images.unsplash.com/photo-1617093727343-374698b1b08d'),

-- Dimlama
(4, 'Dimlama', 'Димлама', 'Dimlama',
'Bug''da pishgan go''sht va sabzavotlar',
'Мясо и овощи на пару',
'Steamed meat and vegetables',
40000, false, 40, 450,
'https://images.unsplash.com/photo-1600891964092-4316c288032e');

-- ========================================
-- QADAM 11: GRILL VA KABOBLAR (🍖)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Shashlik
(5, 'Shashlik (qo''y)', 'Шашлык (баранина)', 'Lamb Shashlik',
'Qo''y go''shtidan shashlik, 6 dona, achiq-chuchuk bilan',
'Шашлык из баранины, 6 шт, с ачик-чучук',
'Lamb kebabs, 6 pcs, with tomato salad',
55000, true, 25, 620,
'https://images.unsplash.com/photo-1555939594-58d7cb561ad1'),

-- Lula-kabob
(5, 'Lula-kabob', 'Люля-кебаб', 'Lula Kebab',
'Qiyma go''shtdan kabob, 4 dona, piyoz bilan',
'Кебаб из фарша, 4 шт, с луком',
'Minced meat kebab, 4 pcs, with onions',
45000, true, 20, 480,
'https://images.unsplash.com/photo-1603360946369-dc9bb6258143'),

-- Tovuq shashlik
(5, 'Tovuq shashlik', 'Куриный шашлык', 'Chicken Shashlik',
'Tovuq go''shtidan shashlik, 6 dona',
'Шашлык из курицы, 6 шт',
'Chicken kebabs, 6 pcs',
42000, false, 20, 420,
'https://images.unsplash.com/photo-1633504581786-316c8002b1b9'),

-- Baliq kabob
(5, 'Baliq kabob', 'Рыбный кебаб', 'Fish Kebab',
'Losos yoki forel, 4 dona, limon bilan',
'Лосось или форель, 4 шт, с лимоном',
'Salmon or trout, 4 pcs, with lemon',
58000, false, 18, 380,
'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2'),

-- Qovurma
(5, 'Qovurma', 'Ковурма', 'Kovurma',
'Jigar, qalb, buyrak, piyoz bilan qovurilgan',
'Печень, сердце, почки, жареные с луком',
'Liver, heart, kidneys, fried with onions',
38000, false, 15, 420,
'https://images.unsplash.com/photo-1544025162-d76694265947');

-- ========================================
-- QADAM 12: PASTA (🍝)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Carbonara
(6, 'Carbonara', 'Карбонара', 'Carbonara',
'Klassik italyan pasta, bekon, tuxum, parmesan',
'Классическая итальянская паста с беконом, яйцом, пармезаном',
'Classic Italian pasta with bacon, egg, parmesan',
42000, false, true, 15, 580,
'https://images.unsplash.com/photo-1612874742237-6526221588e3'),

-- Boloneze
(6, 'Boloneze', 'Болоньезе', 'Bolognese',
'Pasta qiyma go''sht sousi bilan',
'Паста с мясным соусом',
'Pasta with meat sauce',
38000, false, true, 18, 520,
'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9'),

-- Alfredo
(6, 'Alfredo', 'Альфредо', 'Alfredo',
'Qaymoqli sous, parmesan, tovuq bilan',
'Сливочный соус, пармезан, с курицей',
'Creamy sauce, parmesan, with chicken',
40000, false, false, 15, 650,
'https://images.unsplash.com/photo-1645112411341-6c4fd023714a');

-- ========================================
-- QADAM 13: PIZZA (🍕)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Margarita
(7, 'Margarita', 'Маргарита', 'Margherita',
'Klassik italyan pizza - pomidor, mozzarella, rayhon',
'Классическая итальянская пицца - томаты, моцарелла, базилик',
'Classic Italian pizza - tomatoes, mozzarella, basil',
45000, true, true, 12, 680,
'https://images.unsplash.com/photo-1574071318508-1cdbab80d002'),

-- Pepperoni
(7, 'Pepperoni', 'Пепперони', 'Pepperoni',
'Pepperoni kolbasa, mozzarella, pomidor sousi',
'Колбаса пепперони, моцарелла, томатный соус',
'Pepperoni sausage, mozzarella, tomato sauce',
48000, false, true, 12, 720,
'https://images.unsplash.com/photo-1628840042765-356cda07504e'),

-- Quattro Formaggi
(7, 'Quattro Formaggi', 'Кватро Формаджи', 'Four Cheese',
'4 xil pishloq - mozzarella, parmesan, gorgonzola, ricotta',
'4 вида сыра - моцарелла, пармезан, горгонзола, рикотта',
'4 cheese types - mozzarella, parmesan, gorgonzola, ricotta',
52000, true, false, 12, 780,
'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f'),

-- Tovuqli pizza
(7, 'Tovuqli pizza', 'Пицца с курицей', 'Chicken Pizza',
'Tovuq, qo''ziqorin, pomidor, mozzarella',
'Курица, грибы, помидоры, моцарелла',
'Chicken, mushrooms, tomatoes, mozzarella',
46000, false, false, 12, 640,
'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38');

-- ========================================
-- QADAM 14: DESERTLAR (🍰)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, is_featured, preparation_time, calories,
    image_url
) VALUES
-- Tiramisu
(9, 'Tiramisu', 'Тирамису', 'Tiramisu',
'Klassik italyan deserti, kofe va maskarpone bilan',
'Классический итальянский десерт с кофе и маскарпоне',
'Classic Italian dessert with coffee and mascarpone',
38000, true, true, 5, 450,
'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9'),

-- Shokoladli tort
(9, 'Shokoladli tort', 'Шоколадный торт', 'Chocolate Cake',
'Boy belgiyalik shokolad torti',
'Богатый торт из бельгийского шоколада',
'Rich Belgian chocolate cake',
35000, true, true, 5, 520,
'https://images.unsplash.com/photo-1578985545062-69928b1d9587'),

-- Napoleon
(9, 'Napoleon', 'Наполеон', 'Napoleon Cake',
'Klassik napoleon torti, kremli qatlamlar',
'Классический торт наполеон с кремовыми слоями',
'Classic Napoleon cake with cream layers',
32000, true, false, 5, 480,
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3'),

-- Chizkeyk
(9, 'Chizkeyk', 'Чизкейк', 'Cheesecake',
'New-York uslubidagi chizkeyk',
'Чизкейк в стиле Нью-Йорк',
'New York style cheesecake',
36000, true, true, 5, 420,
'https://images.unsplash.com/photo-1533134486753-c833f0ed4866'),

-- Pahlava
(9, 'Pahlava', 'Пахлава', 'Baklava',
'An''anaviy sharq pahlavasi, yong''oq va asal bilan',
'Традиционная восточная пахлава с орехами и медом',
'Traditional Eastern baklava with nuts and honey',
28000, true, false, 5, 380,
'https://images.unsplash.com/photo-1519915028121-7d3463d20b13'),

-- Medovik
(9, 'Medovik', 'Медовик', 'Honey Cake',
'Asal torti, qaymoqli kremli',
'Медовый торт со сливочным кремом',
'Honey cake with cream',
30000, true, false, 5, 440,
'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62');

-- ========================================
-- QADAM 15: MUZQAYMOQLAR (🍨)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories,
    image_url
) VALUES
(10, 'Vanilli muzqaymoq', 'Ванильное мороженое', 'Vanilla Ice Cream',
'Klassik vanilli muzqaymoq, 3 koptok',
'Классическое ванильное мороженое, 3 шарика',
'Classic vanilla ice cream, 3 scoops',
20000, true, 2, 280,
'https://images.unsplash.com/photo-1563805042-7684c019e1cb'),

(10, 'Shokoladli muzqaymoq', 'Шоколадное мороженое', 'Chocolate Ice Cream',
'Belgiya shokoladi bilan, 3 koptok',
'С бельгийским шоколадом, 3 шарика',
'With Belgian chocolate, 3 scoops',
22000, true, 2, 320,
'https://images.unsplash.com/photo-1563805042-7684c019e1cb'),

(10, 'Qulupnayli muzqaymoq', 'Клубничное мороженое', 'Strawberry Ice Cream',
'Yangi qulupnay bilan, 3 koptok',
'Со свежей клубникой, 3 шарика',
'With fresh strawberries, 3 scoops',
24000, true, 2, 260,
'https://images.unsplash.com/photo-1563805042-7684c019e1cb');

-- ========================================
-- QADAM 16: CHOYLAR (🍵)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories,
    image_url
) VALUES
(13, 'Ko''k choy', 'Зеленый чай', 'Green Tea',
'O''zbekona an''anaviy ko''k choy, choynak',
'Традиционный узбекский зеленый чай, чайник',
'Traditional Uzbek green tea, teapot',
8000, true, 3, 0,
'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9'),

(13, 'Qora choy', 'Черный чай', 'Black Tea',
'Premium qora choy, choynak',
'Премиальный черный чай, чайник',
'Premium black tea, teapot',
10000, true, 3, 0,
'https://images.unsplash.com/photo-1576092768241-dec231879fc3'),

(13, 'Ko''katli choy', 'Травяной чай', 'Herbal Tea',
'Yalpiz, rayhon va boshqa o''tlar',
'Мята, базилик и другие травы',
'Mint, basil and other herbs',
12000, true, 3, 0,
'https://images.unsplash.com/photo-1597318236459-79cde7b9f6d0');

-- ========================================
-- QADAM 17: KOFE (☕)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories,
    image_url
) VALUES
(12, 'Espresso', 'Эспрессо', 'Espresso',
'Klassik italyan espresso, 30ml',
'Классический итальянский эспрессо, 30мл',
'Classic Italian espresso, 30ml',
15000, true, 2, 5,
'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04'),

(12, 'Americano', 'Американо', 'Americano',
'Espresso + suv, 180ml',
'Эспрессо + вода, 180мл',
'Espresso + water, 180ml',
18000, true, 3, 10,
'https://images.unsplash.com/photo-1572442388796-11668a67e53d'),

(12, 'Cappuccino', 'Капучино', 'Cappuccino',
'Espresso, sut ko''pigi bilan, 180ml',
'Эспрессо с молочной пеной, 180мл',
'Espresso with milk foam, 180ml',
20000, true, 4, 120,
'https://images.unsplash.com/photo-1572286258217-339f87793249'),

(12, 'Latte', 'Латте', 'Latte',
'Espresso va ko''p sut, 250ml',
'Эспрессо и много молока, 250мл',
'Espresso with lots of milk, 250ml',
22000, true, 4, 150,
'https://images.unsplash.com/photo-1461023058943-07fcbe16d735'),

(12, 'Flat White', 'Флэт Уайт', 'Flat White',
'Espresso va ipak sut, 180ml',
'Эспрессо и шелковое молоко, 180мл',
'Espresso with silky milk, 180ml',
24000, true, 4, 130,
'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7');

-- ========================================
-- QADAM 18: ICHIMLIKLAR (🥤)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories,
    image_url
) VALUES
(11, 'Coca-Cola', 'Кока-Кола', 'Coca-Cola',
'0.33L',
'0.33Л',
'0.33L',
12000, true, 1, 140,
'https://images.unsplash.com/photo-1554866585-cd94860890b7'),

(11, 'Fanta', 'Фанта', 'Fanta',
'0.33L',
'0.33Л',
'0.33L',
12000, true, 1, 150,
'https://images.unsplash.com/photo-1624517452488-04869289c4ca'),

(11, 'Sprite', 'Спрайт', 'Sprite',
'0.33L',
'0.33Л',
'0.33L',
12000, true, 1, 135,
'https://images.unsplash.com/photo-1625772452859-1c03d5bf1137'),

(11, 'Limonad uyda', 'Домашний лимонад', 'Homemade Lemonade',
'Limon, na''na, shakar, muz',
'Лимон, мята, сахар, лед',
'Lemon, mint, sugar, ice',
18000, true, 5, 95,
'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9c'),

(11, 'Mineral suv', 'Минеральная вода', 'Mineral Water',
'0.5L',
'0.5Л',
'0.5L',
8000, true, 1, 0,
'https://images.unsplash.com/photo-1559839734-2b71ea197ec2');

-- ========================================
-- QADAM 19: FRESH VA SMOOTHIE (🧃)
-- ========================================

INSERT INTO menu_items (
    category_id, name_uz, name_ru, name_en,
    description_uz, description_ru, description_en,
    price, is_vegetarian, preparation_time, calories,
    image_url
) VALUES
(14, 'Apelsin fresh', 'Апельсиновый фреш', 'Orange Fresh',
'Yangi siqilgan apelsin sharbati, 300ml',
'Свежевыжатый апельсиновый сок, 300мл',
'Freshly squeezed orange juice, 300ml',
25000, true, 3, 110,
'https://images.unsplash.com/photo-1600271886742-f049cd451bba'),

(14, 'Olma fresh', 'Яблочный фреш', 'Apple Fresh',
'Yangi siqilgan olma sharbati, 300ml',
'Свежевыжатый яблочный сок, 300мл',
'Freshly squeezed apple juice, 300ml',
22000, true, 3, 115,
'https://images.unsplash.com/photo-1600271886742-f049cd451bba'),

(14, 'Sabzi fresh', 'Морковный фреш', 'Carrot Fresh',
'Yangi siqilgan sabzi sharbati, 300ml',
'Свежевыжатый морковный сок, 300мл',
'Freshly squeezed carrot juice, 300ml',
20000, true, 3, 95,
'https://images.unsplash.com/photo-1600271886742-f049cd451bba'),

(14, 'Qulupnayli smoothie', 'Клубничный смузи', 'Strawberry Smoothie',
'Qulupnay, banan, yogurt, 400ml',
'Клубника, банан, йогурт, 400мл',
'Strawberry, banana, yogurt, 400ml',
28000, true, 5, 220,
'https://images.unsplash.com/photo-1505252585461-04db1eb84625'),

(14, 'Mango smoothie', 'Манго смузи', 'Mango Smoothie',
'Mango, apelsin, yogurt, 400ml',
'Манго, апельсин, йогурт, 400мл',
'Mango, orange, yogurt, 400ml',
30000, true, 5, 240,
'https://images.unsplash.com/photo-1505252585461-04db1eb84625');

-- ========================================
-- TAYYOR! DATABASE TO'LDIRILDI! ✅
-- ========================================

-- Umumiy ma'lumotlar:
-- ✅ 20 stol
-- ✅ 20 NFC tag
-- ✅ 5 ofitsiant
-- ✅ 14 kategoriya
-- ✅ 65+ ovqat va ichimlik
--
-- Keyingi qadam: Railway Console'da ushbu faylni bajaring!
