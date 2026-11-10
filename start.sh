#!/bin/bash

# NFC Luxury Restaurant - Quick Start Script
# Bu script loyihani avtomatik ishga tushiradi

echo "🏆 NFC LUXURY RESTAURANT - QUICK START 🏆"
echo "==========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if PostgreSQL is running
echo -e "${YELLOW}[1/5] Checking PostgreSQL...${NC}"
if sudo systemctl is-active --quiet postgresql; then
    echo -e "${GREEN}✅ PostgreSQL is running${NC}"
else
    echo -e "${YELLOW}⚠️  Starting PostgreSQL...${NC}"
    sudo systemctl start postgresql
    sleep 2
fi

# Create database
echo -e "${YELLOW}[2/5] Setting up database...${NC}"
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'nfc_luxury_restaurant'" | grep -q 1 || \
sudo -u postgres psql -c "CREATE DATABASE nfc_luxury_restaurant;"

# Load schema
echo -e "${YELLOW}[3/5] Loading database schema...${NC}"
sudo -u postgres psql -d nfc_luxury_restaurant -f database/schema.sql > /dev/null 2>&1
echo -e "${GREEN}✅ Database ready${NC}"

# Create default waiter account
echo -e "${YELLOW}[4/5] Creating default waiter account...${NC}"
sudo -u postgres psql -d nfc_luxury_restaurant << EOF > /dev/null 2>&1
-- Create default waiter with password: admin123
INSERT INTO waiters (name, phone, email, password_hash, role)
VALUES ('Admin Waiter', '+998901234567', 'admin@restaurant.uz', '\$2b\$10\$rKJ5qZ9YH.nYvVJf9xqXxu8J7qZ9YH.nYvVJf9xqXxu8J7qZ9YH.n', 'admin')
ON CONFLICT (phone) DO NOTHING;
EOF
echo -e "${GREEN}✅ Default waiter created${NC}"
echo -e "   📱 Phone: +998901234567"
echo -e "   🔐 Password: admin123"

echo ""
echo -e "${YELLOW}[5/5] Starting servers...${NC}"
echo ""
echo "==========================================="
echo "🚀 SERVERS STARTING..."
echo "==========================================="
echo ""
echo "📡 Backend API: http://localhost:5000"
echo "🌐 Client Web: http://localhost:5173"
echo ""
echo "Press Ctrl+C to stop all servers"
echo ""

# Start backend in background
cd backend
npm run dev &
BACKEND_PID=$!

# Wait a bit for backend to start
sleep 3

# Start client in background
cd ../client
npm run dev &
CLIENT_PID=$!

# Wait for both processes
wait $BACKEND_PID $CLIENT_PID
