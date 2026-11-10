# 🚀 LOYIHANI SINASH - ODDIY YO'L

PostgreSQL parol kerak bo'lgani uchun, quyidagicha sinab ko'ring:

## VARIANT 1: PostgreSQL siz (Mock Data bilan)

Hozircha PostgreSQL siz ham sinash mumkin. Backend mock data bilan ishlaydi.

### 1. Backend ishga tushirish:
```bash
cd /home/hacker/nfc-luxury-restaurant/backend
npm run dev
```

### 2. Client ishga tushirish (yangi terminal):
```bash
cd /home/hacker/nfc-luxury-restaurant/client
npm run dev
```

### 3. Brauzerda ochish:
```
http://localhost:5173
```

---

## VARIANT 2: PostgreSQL bilan (To'liq versiya)

### 1. PostgreSQL ni yoqish:
```bash
sudo service postgresql start
# Parol so'raladi - kiritasiz
```

### 2. Database yaratish:
```bash
sudo -u postgres psql -c "CREATE DATABASE nfc_luxury_restaurant;"
```

### 3. Schema yuklash:
```bash
cd /home/hacker/nfc-luxury-restaurant
sudo -u postgres psql -d nfc_luxury_restaurant -f database/schema.sql
```

### 4. Backend ishga tushirish:
```bash
cd backend
npm run dev
```

### 5. Client ishga tushirish (yangi terminal):
```bash
cd ../client
npm run dev
```

---

## 🎯 ENG OSON YO'L - FAQAT FRONTEND KO'RISH

Agar faqat dizaynni ko'rmoqchi bo'lsangiz:

```bash
cd /home/hacker/nfc-luxury-restaurant/client
npm run dev
```

Keyin brauzerda: http://localhost:5173

Bu luxury NFC scan sahifasini ko'rsatadi!

---

## ✅ NIMANI SINASH MUMKIN (PostgreSQL siz ham)?

1. **Client Web App** - To'liq ishlaydi, faqat backend API kerak bo'lmaydi
2. **UI/UX dizayn** - Barcha animatsiyalar, glassmorphism
3. **Manual table entry** - Table number kiritib menu ga kirish
4. **Cart funksiyasi** - Mahsulot qo'shish, olib tashlash
5. **Responsive design** - Mobile va desktop

---

## 🎨 QAYSI QISMLAR ISHLAYDI?

### PostgreSQL siz:
- ✅ Frontend dizayni (100%)
- ✅ Animatsiyalar
- ✅ Cart (local storage)
- ✅ UI/UX
- ❌ Real orders (backend kerak)

### PostgreSQL bilan:
- ✅ Hammasi 100%!

---

## 💡 TAVSIYA

1. **Birinchi navbatda Frontend ni ko'ring**:
```bash
cd /home/hacker/nfc-luxury-restaurant/client
npm run dev
```

2. Keyin agar backend ham kerak bo'lsa, PostgreSQL yoqasiz.

---

Qaysi yo'lni tanlaysiz? Men sizga yordam beraman! 🚀
