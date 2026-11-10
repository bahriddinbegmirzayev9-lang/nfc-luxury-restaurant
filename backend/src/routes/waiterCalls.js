// Waiter Call Routes
// Routes for waiter call management

import express from 'express';
import {
  createWaiterCall,
  getWaiterCalls,
  updateWaiterCall,
} from '../controllers/waiterCallController.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

// POST /api/waiter-calls - Create new waiter call
router.post('/', createWaiterCall);

// GET /api/waiter-calls - Get all waiter calls (waiter only)
router.get('/', authenticate, getWaiterCalls);

// PATCH /api/waiter-calls/:id - Update waiter call status (waiter only)
router.patch('/:id', authenticate, updateWaiterCall);

export default router;
