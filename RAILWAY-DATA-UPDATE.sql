-- =====================================================
-- RAILWAY DATABASE - MA'LUMOTLARNI YANGILASH
-- Eski sample data ni o'chirmasdan qo'shish
-- =====================================================

-- Eski ma'lumotlarni o'chirish (schema.sql dan kelgan sample data)
DELETE FROM menu_items;
DELETE FROM menu_categories;
DELETE FROM nfc_tags;
DELETE FROM tables;

-- =====================================================
-- QADAM 1: STOLLAR (20 ta - YANGI)
-- =====================================================
INSERT INTO tables (table_number, capacity, qr_code, status) VALUES
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

-- =====================================================
-- QADAM 2: NFC TAGLAR (20 ta)
-- =====================================================
INSERT INTO nfc_tags (tag_uid, table_id, is_active)
SELECT
    'NTAG213-000' || t.table_number,
    t.id,
    true
FROM tables t
ORDER BY t.table_number;

-- =====================================================
-- QADAM 3: KATEGORIYALAR (14 ta)
-- =====================================================
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

-- =====================================================
-- QADAM 4: MENU ITEMS (49 ta ovqat va ichimlik)
-- =====================================================

-- Salatlar (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT
    c.id,
    'Sezar salati', 'Салат Цезарь', 'Caesar Salad',
    'Yangi ko''kat, tovuq go''shti, parmesan, krutonlar, maxsus sous',
    'Свежая зелень, куриное мясо, пармезан, сухарики, фирменный соус',
    'Fresh greens, chicken, parmesan, croutons, special Caesar sauce',
    35000, false, true, 10, 320,
    'https://images.unsplash.com/photo-1546793665-c74683f339c1'
FROM menu_categories c WHERE c.name_en = 'Salads';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Grek salati', 'Греческий салат', 'Greek Salad', 'Pomidor, bodring, zaytun, feta pishloqi, zaytun moyi', 'Помидоры, огурцы, оливки, сыр фета, оливковое масло', 'Tomatoes, cucumbers, olives, feta cheese, olive oil', 32000, true, true, 8, 210, 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe' FROM menu_categories c WHERE c.name_en = 'Salads';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Achiq-chuchuk', 'Ачик-чучук', 'Achik-chuchuk', 'Pomidor, piyoz, qalampir, ko''katlar, achchiq', 'Помидоры, лук, перец, зелень, острый', 'Tomatoes, onions, peppers, greens, spicy', 18000, true, 5, 85, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd' FROM menu_categories c WHERE c.name_en = 'Salads';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Olivye', 'Оливье', 'Olivier Salad', 'Klassik olivye salati - kartoshka, tuxum, kolbasa, mayonez', 'Классический салат оливье с картофелем, яйцами и колбасой', 'Classic Olivier salad with potatoes, eggs, and sausage', 25000, 10, 285, 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af' FROM menu_categories c WHERE c.name_en = 'Salads';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Mimoza', 'Мимоза', 'Mimosa Salad', 'Baliq, tuxum, kartoshka, sabzi, qatlamli salat', 'Рыба, яйца, картофель, морковь, слоеный салат', 'Fish, eggs, potatoes, carrots, layered salad', 28000, 12, 295, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd' FROM menu_categories c WHERE c.name_en = 'Salads';

-- Sho'rvalar (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_spicy, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Lag''mon', 'Лагман', 'Lagman', 'An''anaviy o''zbek go''sht sho''rvasi, uy makaron bilan', 'Традиционный узбекский мясной суп с домашней лапшой', 'Traditional Uzbek meat soup with homemade noodles', 38000, true, true, 20, 485, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624' FROM menu_categories c WHERE c.name_en = 'Soups';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Mastava', 'Мастава', 'Mastava', 'Guruch va go''sht bilan boy sho''rva', 'Богатый суп с рисом и мясом', 'Rich soup with rice and meat', 35000, true, 25, 420, 'https://images.unsplash.com/photo-1547592166-23ac45744acd' FROM menu_categories c WHERE c.name_en = 'Soups';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Shurva', 'Шурпа', 'Shurpa', 'Qo''y go''shti sho''rvasi, sabzavotlar bilan', 'Суп из баранины с овощами', 'Lamb soup with vegetables', 40000, true, 30, 390, 'https://images.unsplash.com/photo-1588566565463-180a5b2090d2' FROM menu_categories c WHERE c.name_en = 'Soups';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Borsh', 'Борщ', 'Borsch', 'Lavlagi, go''sht, smetana bilan klassik borsh', 'Свекла, мясо, со сметаной, классический борщ', 'Beetroot, meat, with sour cream, classic borsch', 32000, 25, 280, 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d' FROM menu_categories c WHERE c.name_en = 'Soups';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Qozi-qozon', 'Казы-казан', 'Kazy-kazan', 'Qozi bilan maxsus sho''rva, boy va aromatli', 'Особый суп с казы, богатый и ароматный', 'Special soup with kazy sausage, rich and aromatic', 45000, true, 30, 520, 'https://images.unsplash.com/photo-1547592166-23ac45744acd' FROM menu_categories c WHERE c.name_en = 'Soups';

-- Milliy taomlar (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Osh', 'Плов', 'Plov', 'O''zbekistonning milliy taomi - zirvak, guruch, go''sht, sabzi', 'Национальное блюдо Узбекистана - зирвак, рис, мясо, морковь', 'National dish of Uzbekistan - zirvak, rice, meat, carrots', 45000, true, 35, 680, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7' FROM menu_categories c WHERE c.name_en = 'National Dishes';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Manti', 'Манты', 'Manti', 'Bug''da pishgan go''shtli chuchvara, kartoshka bilan', 'Паровые пельмени с мясом и картофелем', 'Steamed dumplings with meat and potato', 42000, true, 25, 520, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb' FROM menu_categories c WHERE c.name_en = 'National Dishes';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Somsa', 'Самса', 'Samsa', 'Tandirda pishgan go''shtli somsa, 4 dona', 'Самса с мясом из тандыра, 4 шт', 'Tandoor-baked meat pastry, 4 pcs', 15000, 20, 380, 'https://images.unsplash.com/photo-1601050690597-df0568f70950' FROM menu_categories c WHERE c.name_en = 'National Dishes';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Norin', 'Нарын', 'Norin', 'Ot go''shti, uy makaron, qazi bilan', 'Конина, домашняя лапша, с казы', 'Horse meat, homemade noodles, with kazy', 48000, 30, 580, 'https://images.unsplash.com/photo-1617093727343-374698b1b08d' FROM menu_categories c WHERE c.name_en = 'National Dishes';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Dimlama', 'Димлама', 'Dimlama', 'Bug''da pishgan go''sht va sabzavotlar', 'Мясо и овощи на пару', 'Steamed meat and vegetables', 40000, 40, 450, 'https://images.unsplash.com/photo-1600891964092-4316c288032e' FROM menu_categories c WHERE c.name_en = 'National Dishes';

-- Kaboblar (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Shashlik (qo''y)', 'Шашлык (баранина)', 'Lamb Shashlik', 'Qo''y go''shtidan shashlik, 6 dona, achiq-chuchuk bilan', 'Шашлык из баранины, 6 шт, с ачик-чучук', 'Lamb kebabs, 6 pcs, with tomato salad', 55000, true, 25, 620, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1' FROM menu_categories c WHERE c.name_en = 'Grill & Kebabs';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Lula-kabob', 'Люля-кебаб', 'Lula Kebab', 'Qiyma go''shtdan kabob, 4 dona, piyoz bilan', 'Кебаб из фарша, 4 шт, с луком', 'Minced meat kebab, 4 pcs, with onions', 45000, true, 20, 480, 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143' FROM menu_categories c WHERE c.name_en = 'Grill & Kebabs';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Tovuq shashlik', 'Куриный шашлык', 'Chicken Shashlik', 'Tovuq go''shtidan shashlik, 6 dona', 'Шашлык из курицы, 6 шт', 'Chicken kebabs, 6 pcs', 42000, 20, 420, 'https://images.unsplash.com/photo-1633504581786-316c8002b1b9' FROM menu_categories c WHERE c.name_en = 'Grill & Kebabs';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Baliq kabob', 'Рыбный кебаб', 'Fish Kebab', 'Losos yoki forel, 4 dona, limon bilan', 'Лосось или форель, 4 шт, с лимоном', 'Salmon or trout, 4 pcs, with lemon', 58000, 18, 380, 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2' FROM menu_categories c WHERE c.name_en = 'Grill & Kebabs';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Qovurma', 'Ковурма', 'Kovurma', 'Jigar, qalb, buyrak, piyoz bilan qovurilgan', 'Печень, сердце, почки, жареные с луком', 'Liver, heart, kidneys, fried with onions', 38000, 15, 420, 'https://images.unsplash.com/photo-1544025162-d76694265947' FROM menu_categories c WHERE c.name_en = 'Grill & Kebabs';

-- Pasta (3 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Carbonara', 'Карбонара', 'Carbonara', 'Klassik italyan pasta, bekon, tuxum, parmesan', 'Классическая итальянская паста с беконом, яйцом, пармезаном', 'Classic Italian pasta with bacon, egg, parmesan', 42000, false, true, 15, 580, 'https://images.unsplash.com/photo-1612874742237-6526221588e3' FROM menu_categories c WHERE c.name_en = 'Pasta';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Boloneze', 'Болоньезе', 'Bolognese', 'Pasta qiyma go''sht sousi bilan', 'Паста с мясным соусом', 'Pasta with meat sauce', 38000, true, 18, 520, 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9' FROM menu_categories c WHERE c.name_en = 'Pasta';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Alfredo', 'Альфредо', 'Alfredo', 'Qaymoqli sous, parmesan, tovuq bilan', 'Сливочный соус, пармезан, с курицей', 'Creamy sauce, parmesan, with chicken', 40000, 15, 650, 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a' FROM menu_categories c WHERE c.name_en = 'Pasta';

-- Pizza (4 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Margarita', 'Маргарита', 'Margherita', 'Klassik italyan pizza - pomidor, mozzarella, rayhon', 'Классическая итальянская пицца - томаты, моцарелла, базилик', 'Classic Italian pizza - tomatoes, mozzarella, basil', 45000, true, true, 12, 680, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002' FROM menu_categories c WHERE c.name_en = 'Pizza';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Pepperoni', 'Пепперони', 'Pepperoni', 'Pepperoni kolbasa, mozzarella, pomidor sousi', 'Колбаса пепперони, моцарелла, томатный соус', 'Pepperoni sausage, mozzarella, tomato sauce', 48000, true, 12, 720, 'https://images.unsplash.com/photo-1628840042765-356cda07504e' FROM menu_categories c WHERE c.name_en = 'Pizza';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Quattro Formaggi', 'Кватро Формаджи', 'Four Cheese', '4 xil pishloq - mozzarella, parmesan, gorgonzola, ricotta', '4 вида сыра - моцарелла, пармезан, горгонзола, рикотта', '4 cheese types - mozzarella, parmesan, gorgonzola, ricotta', 52000, true, 12, 780, 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f' FROM menu_categories c WHERE c.name_en = 'Pizza';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, preparation_time, calories, image_url)
SELECT c.id, 'Tovuqli pizza', 'Пицца с курицей', 'Chicken Pizza', 'Tovuq, qo''ziqorin, pomidor, mozzarella', 'Курица, грибы, помидоры, моцарелла', 'Chicken, mushrooms, tomatoes, mozzarella', 46000, 12, 640, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38' FROM menu_categories c WHERE c.name_en = 'Pizza';

-- Desertlar (6 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Tiramisu', 'Тирамису', 'Tiramisu', 'Klassik italyan deserti, kofe va maskarpone bilan', 'Классический итальянский десерт с кофе и маскарпоне', 'Classic Italian dessert with coffee and mascarpone', 38000, true, true, 5, 450, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9' FROM menu_categories c WHERE c.name_en = 'Desserts';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Shokoladli tort', 'Шоколадный торт', 'Chocolate Cake', 'Boy belgiyalik shokolad torti', 'Богатый торт из бельгийского шоколада', 'Rich Belgian chocolate cake', 35000, true, true, 5, 520, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587' FROM menu_categories c WHERE c.name_en = 'Desserts';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Napoleon', 'Наполеон', 'Napoleon Cake', 'Klassik napoleon torti, kremli qatlamlar', 'Классический торт наполеон с кремовыми слоями', 'Classic Napoleon cake with cream layers', 32000, true, 5, 480, 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3' FROM menu_categories c WHERE c.name_en = 'Desserts';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, is_featured, preparation_time, calories, image_url)
SELECT c.id, 'Chizkeyk', 'Чизкейк', 'Cheesecake', 'New-York uslubidagi chizkeyk', 'Чизкейк в стиле Нью-Йорк', 'New York style cheesecake', 36000, true, true, 5, 420, 'https://images.unsplash.com/photo-1533134486753-c833f0ed4866' FROM menu_categories c WHERE c.name_en = 'Desserts';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Pahlava', 'Пахлава', 'Baklava', 'An''anaviy sharq pahlavasi, yong''oq va asal bilan', 'Традиционная восточная пахлава с орехами и медом', 'Traditional Eastern baklava with nuts and honey', 28000, true, 5, 380, 'https://images.unsplash.com/photo-1519915028121-7d3463d20b13' FROM menu_categories c WHERE c.name_en = 'Desserts';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Medovik', 'Медовик', 'Honey Cake', 'Asal torti, qaymoqli kremli', 'Медовый торт со сливочным кремом', 'Honey cake with cream', 30000, true, 5, 440, 'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62' FROM menu_categories c WHERE c.name_en = 'Desserts';

-- Muzqaymoq (3 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Vanilli muzqaymoq', 'Ванильное мороженое', 'Vanilla Ice Cream', 'Klassik vanilli muzqaymoq, 3 koptok', 'Классическое ванильное мороженое, 3 шарика', 'Classic vanilla ice cream, 3 scoops', 20000, true, 2, 280, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb' FROM menu_categories c WHERE c.name_en = 'Ice Cream';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Shokoladli muzqaymoq', 'Шоколадное мороженое', 'Chocolate Ice Cream', 'Belgiya shokoladi bilan, 3 koptok', 'С бельгийским шоколадом, 3 шарика', 'With Belgian chocolate, 3 scoops', 22000, true, 2, 320, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb' FROM menu_categories c WHERE c.name_en = 'Ice Cream';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Qulupnayli muzqaymoq', 'Клубничное мороженое', 'Strawberry Ice Cream', 'Yangi qulupnay bilan, 3 koptok', 'Со свежей клубникой, 3 шарика', 'With fresh strawberries, 3 scoops', 24000, true, 2, 260, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb' FROM menu_categories c WHERE c.name_en = 'Ice Cream';

-- Choylar (3 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Ko''k choy', 'Зеленый чай', 'Green Tea', 'O''zbekona an''anaviy ko''k choy, choynak', 'Традиционный узбекский зеленый чай, чайник', 'Traditional Uzbek green tea, teapot', 8000, true, 3, 0, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9' FROM menu_categories c WHERE c.name_en = 'Tea';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Qora choy', 'Черный чай', 'Black Tea', 'Premium qora choy, choynak', 'Премиальный черный чай, чайник', 'Premium black tea, teapot', 10000, true, 3, 0, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3' FROM menu_categories c WHERE c.name_en = 'Tea';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Ko''katli choy', 'Травяной чай', 'Herbal Tea', 'Yalpiz, rayhon va boshqa o''tlar', 'Мята, базилик и другие травы', 'Mint, basil and other herbs', 12000, true, 3, 0, 'https://images.unsplash.com/photo-1597318236459-79cde7b9f6d0' FROM menu_categories c WHERE c.name_en = 'Tea';

-- Kofe (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Espresso', 'Эспрессо', 'Espresso', 'Klassik italyan espresso, 30ml', 'Классический итальянский эспрессо, 30мл', 'Classic Italian espresso, 30ml', 15000, true, 2, 5, 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04' FROM menu_categories c WHERE c.name_en = 'Coffee';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Americano', 'Американо', 'Americano', 'Espresso + suv, 180ml', 'Эспрессо + вода, 180мл', 'Espresso + water, 180ml', 18000, true, 3, 10, 'https://images.unsplash.com/photo-1572442388796-11668a67e53d' FROM menu_categories c WHERE c.name_en = 'Coffee';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Cappuccino', 'Капучино', 'Cappuccino', 'Espresso, sut ko''pigi bilan, 180ml', 'Эспрессо с молочной пеной, 180мл', 'Espresso with milk foam, 180ml', 20000, true, 4, 120, 'https://images.unsplash.com/photo-1572286258217-339f87793249' FROM menu_categories c WHERE c.name_en = 'Coffee';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Latte', 'Латте', 'Latte', 'Espresso va ko''p sut, 250ml', 'Эспрессо и много молока, 250мл', 'Espresso with lots of milk, 250ml', 22000, true, 4, 150, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735' FROM menu_categories c WHERE c.name_en = 'Coffee';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Flat White', 'Флэт Уайт', 'Flat White', 'Espresso va ipak sut, 180ml', 'Эспрессо и шелковое молоко, 180мл', 'Espresso with silky milk, 180ml', 24000, true, 4, 130, 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7' FROM menu_categories c WHERE c.name_en = 'Coffee';

-- Ichimliklar (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Coca-Cola', 'Кока-Кола', 'Coca-Cola', '0.33L', '0.33Л', '0.33L', 12000, true, 1, 140, 'https://images.unsplash.com/photo-1554866585-cd94860890b7' FROM menu_categories c WHERE c.name_en = 'Beverages';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Fanta', 'Фанта', 'Fanta', '0.33L', '0.33Л', '0.33L', 12000, true, 1, 150, 'https://images.unsplash.com/photo-1624517452488-04869289c4ca' FROM menu_categories c WHERE c.name_en = 'Beverages';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Sprite', 'Спрайт', 'Sprite', '0.33L', '0.33Л', '0.33L', 12000, true, 1, 135, 'https://images.unsplash.com/photo-1625772452859-1c03d5bf1137' FROM menu_categories c WHERE c.name_en = 'Beverages';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Limonad uyda', 'Домашний лимонад', 'Homemade Lemonade', 'Limon, na''na, shakar, muz', 'Лимон, мята, сахар, лед', 'Lemon, mint, sugar, ice', 18000, true, 5, 95, 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9c' FROM menu_categories c WHERE c.name_en = 'Beverages';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Mineral suv', 'Минеральная вода', 'Mineral Water', '0.5L', '0.5Л', '0.5L', 8000, true, 1, 0, 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2' FROM menu_categories c WHERE c.name_en = 'Beverages';

-- Fresh va smoothie (5 ta)
INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Apelsin fresh', 'Апельсиновый фреш', 'Orange Fresh', 'Yangi siqilgan apelsin sharbati, 300ml', 'Свежевыжатый апельсиновый сок, 300мл', 'Freshly squeezed orange juice, 300ml', 25000, true, 3, 110, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba' FROM menu_categories c WHERE c.name_en = 'Fresh Juices';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Olma fresh', 'Яблочный фреш', 'Apple Fresh', 'Yangi siqilgan olma sharbati, 300ml', 'Свежевыжатый яблочный сок, 300мл', 'Freshly squeezed apple juice, 300ml', 22000, true, 3, 115, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba' FROM menu_categories c WHERE c.name_en = 'Fresh Juices';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Sabzi fresh', 'Морковный фреш', 'Carrot Fresh', 'Yangi siqilgan sabzi sharbati, 300ml', 'Свежевыжатый морковный сок, 300мл', 'Freshly squeezed carrot juice, 300ml', 20000, true, 3, 95, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba' FROM menu_categories c WHERE c.name_en = 'Fresh Juices';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Qulupnayli smoothie', 'Клубничный смузи', 'Strawberry Smoothie', 'Qulupnay, banan, yogurt, 400ml', 'Клубника, банан, йогурт, 400мл', 'Strawberry, banana, yogurt, 400ml', 28000, true, 5, 220, 'https://images.unsplash.com/photo-1505252585461-04db1eb84625' FROM menu_categories c WHERE c.name_en = 'Fresh Juices';

INSERT INTO menu_items (category_id, name_uz, name_ru, name_en, description_uz, description_ru, description_en, price, is_vegetarian, preparation_time, calories, image_url)
SELECT c.id, 'Mango smoothie', 'Манго смузи', 'Mango Smoothie', 'Mango, apelsin, yogurt, 400ml', 'Манго, апельсин, йогурт, 400мл', 'Mango, orange, yogurt, 400ml', 30000, true, 5, 240, 'https://images.unsplash.com/photo-1505252585461-04db1eb84625' FROM menu_categories c WHERE c.name_en = 'Fresh Juices';

-- =====================================================
-- ✅ TAYYOR!
-- =====================================================
SELECT 'DATABASE MUVAFFAQIYATLI TO''LDIRILDI!' as status,
       (SELECT COUNT(*) FROM tables) as tables_count,
       (SELECT COUNT(*) FROM nfc_tags) as nfc_tags_count,
       (SELECT COUNT(*) FROM menu_categories) as categories_count,
       (SELECT COUNT(*) FROM menu_items) as menu_items_count;
