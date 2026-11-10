-- ============================================
-- NFC LUXURY RESTAURANT DATABASE SCHEMA
-- Dubai-class Restaurant Management System
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLES (Stollar)
-- ============================================
CREATE TABLE tables (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_number INTEGER UNIQUE NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 4,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'reserved', 'cleaning')),
    qr_code TEXT,
    position_x INTEGER,
    position_y INTEGER,
    floor_level INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- NFC TAGS
-- ============================================
CREATE TABLE nfc_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag_uid VARCHAR(255) UNIQUE NOT NULL,
    table_id UUID REFERENCES tables(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    last_scanned_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- MENU CATEGORIES (Ovqat turkumlari)
-- ============================================
CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_uz VARCHAR(255) NOT NULL,
    name_ru VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    description_uz TEXT,
    description_ru TEXT,
    description_en TEXT,
    icon VARCHAR(100),
    image_url TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- MENU ITEMS (Ovqatlar)
-- ============================================
CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES menu_categories(id) ON DELETE CASCADE,
    name_uz VARCHAR(255) NOT NULL,
    name_ru VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    description_uz TEXT,
    description_ru TEXT,
    description_en TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url TEXT,
    preparation_time INTEGER DEFAULT 15, -- minutes
    calories INTEGER,
    is_vegetarian BOOLEAN DEFAULT false,
    is_spicy BOOLEAN DEFAULT false,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- WAITERS (Afitsiantlar)
-- ============================================
CREATE TABLE waiters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    status VARCHAR(20) DEFAULT 'offline' CHECK (status IN ('online', 'offline', 'busy')),
    role VARCHAR(20) DEFAULT 'waiter' CHECK (role IN ('waiter', 'manager', 'admin')),
    rating DECIMAL(3, 2) DEFAULT 5.00,
    total_orders INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

-- ============================================
-- SESSIONS (Stolda o'tirish sessiyalari)
-- ============================================
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_id UUID REFERENCES tables(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    guest_count INTEGER DEFAULT 1,
    start_time TIMESTAMP DEFAULT NOW(),
    end_time TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- ORDERS (Buyurtmalar)
-- ============================================
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    table_id UUID REFERENCES tables(id) ON DELETE CASCADE,
    waiter_id UUID REFERENCES waiters(id) ON DELETE SET NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'served', 'cancelled')),
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    service_charge DECIMAL(10, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    confirmed_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- ============================================
-- ORDER ITEMS (Buyurtma detallari)
-- ============================================
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    special_instructions TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'preparing', 'ready', 'served')),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- WAITER CALLS (Afitsiant chaqiruvlari)
-- ============================================
CREATE TABLE waiter_calls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_id UUID REFERENCES tables(id) ON DELETE CASCADE,
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    waiter_id UUID REFERENCES waiters(id) ON DELETE SET NULL,
    call_type VARCHAR(50) NOT NULL CHECK (call_type IN ('assistance', 'bill', 'complaint', 'menu', 'refill', 'other')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'in_progress', 'completed', 'cancelled')),
    message TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    assigned_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- ============================================
-- PAYMENTS (To'lovlar)
-- ============================================
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('cash', 'card', 'nfc', 'online', 'qr')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

-- ============================================
-- REVIEWS (Baholash)
-- ============================================
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    waiter_id UUID REFERENCES waiters(id) ON DELETE SET NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    food_rating INTEGER CHECK (food_rating >= 1 AND food_rating <= 5),
    service_rating INTEGER CHECK (service_rating >= 1 AND service_rating <= 5),
    ambiance_rating INTEGER CHECK (ambiance_rating >= 1 AND ambiance_rating <= 5),
    comment TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS (Xabarnomalar)
-- ============================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    waiter_id UUID REFERENCES waiters(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    read_at TIMESTAMP
);

-- ============================================
-- INDEXES for Performance
-- ============================================
CREATE INDEX idx_nfc_tags_uid ON nfc_tags(tag_uid);
CREATE INDEX idx_nfc_tags_table ON nfc_tags(table_id);
CREATE INDEX idx_sessions_table ON sessions(table_id);
CREATE INDEX idx_sessions_active ON sessions(is_active);
CREATE INDEX idx_orders_session ON orders(session_id);
CREATE INDEX idx_orders_table ON orders(table_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_waiter_calls_table ON waiter_calls(table_id);
CREATE INDEX idx_waiter_calls_status ON waiter_calls(status);
CREATE INDEX idx_payments_session ON payments(session_id);
CREATE INDEX idx_notifications_waiter ON notifications(waiter_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);

-- ============================================
-- TRIGGERS for Updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tables_updated_at BEFORE UPDATE ON tables
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA for Testing
-- ============================================

-- Insert sample tables
INSERT INTO tables (table_number, capacity, status, floor_level) VALUES
(1, 2, 'available', 1),
(2, 4, 'available', 1),
(3, 4, 'available', 1),
(4, 6, 'available', 1),
(5, 8, 'available', 1),
(6, 2, 'available', 2),
(7, 4, 'available', 2),
(8, 6, 'available', 2);

-- Insert sample menu categories
INSERT INTO menu_categories (name_uz, name_ru, name_en, icon, sort_order) VALUES
('Salatlar', 'Салаты', 'Salads', '🥗', 1),
('Sho''rvalar', 'Супы', 'Soups', '🍲', 2),
('Asosiy taomlar', 'Основные блюда', 'Main Courses', '🍖', 3),
('Pitsa', 'Пицца', 'Pizza', '🍕', 4),
('Desert', 'Десерты', 'Desserts', '🍰', 5),
('Ichimliklar', 'Напитки', 'Beverages', '🥤', 6);

-- Insert sample waiter
INSERT INTO waiters (name, phone, email, password_hash, role) VALUES
('Admin', '+998901234567', 'admin@restaurant.uz', '$2b$10$xyz...', 'admin');

-- Create views for analytics
CREATE VIEW daily_revenue AS
SELECT
    DATE(created_at) as date,
    COUNT(*) as total_orders,
    SUM(total_amount) as revenue
FROM orders
WHERE status != 'cancelled'
GROUP BY DATE(created_at)
ORDER BY date DESC;

CREATE VIEW table_occupancy AS
SELECT
    t.table_number,
    t.capacity,
    t.status,
    COUNT(DISTINCT s.id) as total_sessions,
    COALESCE(SUM(s.total_amount), 0) as total_revenue
FROM tables t
LEFT JOIN sessions s ON t.id = s.table_id
GROUP BY t.id, t.table_number, t.capacity, t.status
ORDER BY t.table_number;

-- ============================================
-- END OF SCHEMA
-- ============================================
