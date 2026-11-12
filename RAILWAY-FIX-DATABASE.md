# 🚨 RAILWAY DATABASE CONNECTION MUAMMOSI - TEZKOR YECHIM

**Vaqt:** 2026-11-11, 21:16 (Tashkent)

---

## ❌ MUAMMO:

Backend deployed, lekin database ga ulanmayapti.

```
Error fetching categories
```

---

## ✅ YECHIM - RAILWAY DASHBOARD ORQALI:

### 1️⃣ Railway.app ga kiring
```
https://railway.app
```

### 2️⃣ nfc-luxury-restaurant backend service ni oching

### 3️⃣ "Variables" tabiga o'ting

### 4️⃣ PostgreSQL Variables ni LINK qiling:

Railway da ikkita usul bor:

**USUL A - Reference Variables (TAVSIYA!):**

PostgreSQL service variables ni reference qiling:

```
DATABASE_URL = ${{Postgres.DATABASE_URL}}
```

Qanday qilish:
1. "New Variable" bosing
2. Variable name: `DATABASE_URL`
3. Variable value: `${{Postgres.DATABASE_URL}}`
4. Save

**YOKI**

PostgreSQL service ni backend service ga link qiling:
1. Backend service settings
2. "Add Service" yoki "Link Service"
3. PostgreSQL ni tanlang
4. Railway avtomatik barcha variables ni qo'shadi

---

### 5️⃣ Deploy ni restart qiling

Variables qo'shgandan keyin:
1. Backend service ga qayting
2. Settings → "Restart" yoki yangi deploy trigger qilish

---

## 🔍 RAILWAY LOGS NI TEKSHIRING:

1. Backend service → "Deployments" tab
2. Latest deployment → "View Logs"
3. Database connection error bormi tekshiring

Qidirilsin:
- `Connection refused`
- `password authentication failed`
- `database does not exist`

---

## ⏱️ TAXMINIY VAQT:

- Variables qo'shish: 2 daqiqa
- Deploy restart: 30 soniya
- Test: 10 soniya

**JAMI: ~3 daqiqa**

---

## 🎯 KEYIN:

Variables sozlangandan keyin men yana test qilaman:

```bash
curl https://nfc-luxury-restaurant-production.up.railway.app/api/v1/menu/categories
```

---

**Iltimos, Railway Dashboard ga o'ting va Variables ni sozlang! Men kutib turaman! ⏰**
