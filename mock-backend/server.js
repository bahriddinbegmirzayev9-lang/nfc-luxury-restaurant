// Mock Backend Server for Testing
// Provides fake data for frontend testing without database

const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Mock Data
const mockCategories = [
  { id: 1, name_uz: "Salatlar", name_ru: "Салаты", name_en: "Salads", icon: "🥗", sort_order: 1 },
  { id: 2, name_uz: "Sho'rvalar", name_ru: "Супы", name_en: "Soups", icon: "🍲", sort_order: 2 },
  { id: 3, name_uz: "Asosiy taomlar", name_ru: "Основные блюда", name_en: "Main Dishes", icon: "🍽️", sort_order: 3 },
  { id: 4, name_uz: "Desertlar", name_ru: "Десерты", name_en: "Desserts", icon: "🍰", sort_order: 4 },
  { id: 5, name_uz: "Ichimliklar", name_ru: "Напитки", name_en: "Beverages", icon: "🥤", sort_order: 5 },
];

const mockMenuItems = [
  {
    id: 1,
    category_id: 1,
    name_uz: "Sezar salati",
    name_ru: "Салат Цезарь",
    name_en: "Caesar Salad",
    description_uz: "Yangi ko'kat, tovuq go'shti, parmesan pishloqi",
    description_ru: "Свежая зелень, куриное мясо, сыр пармезан",
    description_en: "Fresh greens, chicken, parmesan cheese",
    price: "12.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_vegetarian: false,
    is_spicy: false,
    preparation_time: 10
  },
  {
    id: 2,
    category_id: 1,
    name_uz: "Grek salati",
    name_ru: "Греческий салат",
    name_en: "Greek Salad",
    description_uz: "Pomidor, bodring, zaytun, feta pishloqi",
    description_ru: "Помидоры, огурцы, оливки, сыр фета",
    description_en: "Tomatoes, cucumbers, olives, feta cheese",
    price: "10.99",
    image_url: null,
    is_available: true,
    is_featured: false,
    is_vegetarian: true,
    is_spicy: false,
    preparation_time: 8
  },
  {
    id: 3,
    category_id: 2,
    name_uz: "Lag'mon",
    name_ru: "Лагман",
    name_en: "Lagman",
    description_uz: "An'anaviy o'zbek go'sht sho'rvasi",
    description_ru: "Традиционный узбекский мясной суп",
    description_en: "Traditional Uzbek meat soup",
    price: "8.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_spicy: true,
    is_vegetarian: false,
    preparation_time: 15
  },
  {
    id: 4,
    category_id: 2,
    name_uz: "Mastava",
    name_ru: "Мастава",
    name_en: "Mastava",
    description_uz: "Guruch va go'sht bilan boy sho'rva",
    description_ru: "Богатый суп с рисом и мясом",
    description_en: "Rich soup with rice and meat",
    price: "7.99",
    image_url: null,
    is_available: true,
    is_featured: false,
    is_spicy: false,
    is_vegetarian: false,
    preparation_time: 20
  },
  {
    id: 5,
    category_id: 3,
    name_uz: "Osh",
    name_ru: "Плов",
    name_en: "Plov",
    description_uz: "O'zbekistonning milliy taomi - osh",
    description_ru: "Национальное блюдо Узбекистана - плов",
    description_en: "National dish of Uzbekistan - plov",
    price: "14.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_spicy: false,
    is_vegetarian: false,
    preparation_time: 30
  },
  {
    id: 6,
    category_id: 3,
    name_uz: "Shashlik",
    name_ru: "Шашлык",
    name_en: "Shashlik",
    description_uz: "Qo'y go'shtidan tayyorlangan shashlik",
    description_ru: "Шашлык из баранины",
    description_en: "Lamb kebabs",
    price: "16.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_spicy: false,
    is_vegetarian: false,
    preparation_time: 25
  },
  {
    id: 7,
    category_id: 3,
    name_uz: "Manti",
    name_ru: "Манты",
    name_en: "Manti",
    description_uz: "Bug'da pishgan go'shtli chuchvara",
    description_ru: "Паровые пельмени с мясом",
    description_en: "Steamed meat dumplings",
    price: "11.99",
    image_url: null,
    is_available: true,
    is_featured: false,
    is_spicy: false,
    is_vegetarian: false,
    preparation_time: 20
  },
  {
    id: 8,
    category_id: 4,
    name_uz: "Tiramisu",
    name_ru: "Тирамису",
    name_en: "Tiramisu",
    description_uz: "Klassik italyan deserti",
    description_ru: "Классический итальянский десерт",
    description_en: "Classic Italian dessert",
    price: "6.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_spicy: false,
    is_vegetarian: true,
    preparation_time: 5
  },
  {
    id: 9,
    category_id: 4,
    name_uz: "Shokoladli tort",
    name_ru: "Шоколадный торт",
    name_en: "Chocolate Cake",
    description_uz: "Boy shokoladli tort",
    description_ru: "Богатый шоколадный торт",
    description_en: "Rich chocolate cake",
    price: "5.99",
    image_url: null,
    is_available: true,
    is_featured: false,
    is_spicy: false,
    is_vegetarian: true,
    preparation_time: 5
  },
  {
    id: 10,
    category_id: 5,
    name_uz: "Choy",
    name_ru: "Чай",
    name_en: "Tea",
    description_uz: "O'zbekona ko'k choy",
    description_ru: "Узбекский зеленый чай",
    description_en: "Uzbek green tea",
    price: "2.99",
    image_url: null,
    is_available: true,
    is_featured: false,
    is_spicy: false,
    is_vegetarian: true,
    preparation_time: 3
  },
  {
    id: 11,
    category_id: 5,
    name_uz: "Limonad",
    name_ru: "Лимонад",
    name_en: "Lemonade",
    description_uz: "Uyda tayyorlangan limonad",
    description_ru: "Домашний лимонад",
    description_en: "Homemade lemonade",
    price: "3.99",
    image_url: null,
    is_available: true,
    is_featured: true,
    is_spicy: false,
    is_vegetarian: true,
    preparation_time: 2
  }
];

// API Routes
app.get('/api/v1/menu/categories', (req, res) => {
  res.json({
    success: true,
    data: mockCategories
  });
});

app.get('/api/v1/menu/items', (req, res) => {
  res.json({
    success: true,
    data: mockMenuItems
  });
});

app.get('/api/v1/menu/items/:id', (req, res) => {
  const item = mockMenuItems.find(i => i.id === parseInt(req.params.id));
  if (item) {
    res.json({ success: true, data: item });
  } else {
    res.status(404).json({ success: false, message: 'Item not found' });
  }
});

app.post('/api/v1/nfc/scan', (req, res) => {
  const { tag_uid } = req.body;
  res.json({
    success: true,
    data: {
      table: { id: 5, number: 5, capacity: 4 },
      session: { token: 'mock-session-' + Date.now(), table_id: 5 }
    }
  });
});

app.post('/api/v1/orders', (req, res) => {
  res.json({
    success: true,
    data: {
      id: Math.floor(Math.random() * 10000),
      order_number: 'ORD-' + Date.now(),
      status: 'pending',
      total: req.body.total,
      created_at: new Date().toISOString()
    }
  });
});

app.post('/api/v1/waiter-calls', (req, res) => {
  res.json({
    success: true,
    data: {
      id: Math.floor(Math.random() * 1000),
      status: 'pending',
      created_at: new Date().toISOString()
    }
  });
});

app.get('/api/v1/orders/:id', (req, res) => {
  res.json({
    success: true,
    data: {
      id: req.params.id,
      order_number: 'ORD-' + req.params.id,
      status: 'preparing',
      items: [],
      total: 0,
      created_at: new Date().toISOString()
    }
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Mock backend is running!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Mock Backend Server running on http://localhost:${PORT}`);
  console.log(`📡 API Base: http://localhost:${PORT}/api/v1`);
  console.log(`✨ Ready for frontend testing!`);
});
