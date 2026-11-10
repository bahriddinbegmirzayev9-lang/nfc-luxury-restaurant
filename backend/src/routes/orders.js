// Order Routes
// Routes for order management

import express from 'express';
import {
  createOrder,
  getOrder,
  getOrders,
  updateOrderStatus,
  getOrderBill,
} from '../controllers/orderController.js';
import { authenticate, authorize } from '../middleware/auth.js';

const router = express.Router();

// POST /api/orders - Create new order
router.post('/', createOrder);

// GET /api/orders/:id - Get order by ID
router.get('/:id', getOrder);

// GET /api/orders - Get orders (with filters)
router.get('/', getOrders);

// PATCH /api/orders/:id/status - Update order status (waiter only)
router.patch('/:id/status', authenticate, updateOrderStatus);

// GET /api/orders/:id/bill - Get order bill
router.get('/:id/bill', getOrderBill);

export default router;
