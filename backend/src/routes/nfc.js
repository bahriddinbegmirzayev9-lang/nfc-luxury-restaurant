// NFC Routes
// Routes for NFC scanning and table identification

import express from 'express';
import { scanNFC, getTableInfo, getSession } from '../controllers/nfcController.js';

const router = express.Router();

// POST /api/nfc/scan - Scan NFC tag
router.post('/scan', scanNFC);

// GET /api/tables/:tableId - Get table info
router.get('/tables/:tableId', getTableInfo);

// GET /api/sessions/:sessionToken - Get session info
router.get('/sessions/:sessionToken', getSession);

export default router;
