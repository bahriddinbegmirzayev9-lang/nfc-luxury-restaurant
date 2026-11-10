#!/bin/bash

# NFC Luxury Restaurant - Demo Mode Setup
# Bu script demo uchun barcha kerakli narsalarni tayorlaydi

echo "🏆 NFC LUXURY RESTAURANT - DEMO SETUP"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}[1/5] Starting services...${NC}"

# Check if client is running
if lsof -Pi :5173 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${GREEN}✅ Client already running on port 5173${NC}"
else
    echo -e "${YELLOW}⚡ Starting client...${NC}"
    cd /home/hacker/nfc-luxury-restaurant/client
    npm run dev > /tmp/nfc-client.log 2>&1 &
    CLIENT_PID=$!
    echo -e "${GREEN}✅ Client started (PID: $CLIENT_PID)${NC}"
    sleep 3
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}🎉 DEMO TAYYOR!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}📱 CLIENT URL:${NC}"
echo -e "   http://localhost:5173"
echo ""
echo -e "${YELLOW}🎯 DEMO FLOW:${NC}"
echo -e "   1. Brauzerda URL ni oching"
echo -e "   2. 'Enter Table Number Manually' bosing"
echo -e "   3. Table raqam kiriting: 5"
echo -e "   4. Menu ko'rsating"
echo -e "   5. Ovqat tanlang"
echo -e "   6. Cart ga qo'shing"
echo -e "   7. Order bering"
echo ""
echo -e "${YELLOW}💡 DEMO TIPS:${NC}"
echo -e "   • Full screen mode (F11)"
echo -e "   • Language o'zgartiring (UZ/RU/EN)"
echo -e "   • Luxury dizaynni ko'rsating"
echo -e "   • Smooth animatsiyalarni demo qiling"
echo ""
echo -e "${GREEN}✨ OMAD! Presentatsiya muvaffaqiyatli bo'lsin!${NC}"
echo ""
