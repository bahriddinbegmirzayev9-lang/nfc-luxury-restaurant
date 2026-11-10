// Auth Routes
// Routes for authentication

import express from 'express';
import { login, getMe, updateStatus, logout } from '../controllers/authController.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

// POST /api/auth/login - Waiter login
router.post('/login', login);

// GET /api/auth/me - Get current user
router.get('/me', authenticate, getMe);

// PATCH /api/auth/status - Update waiter status
router.patch('/status', authenticate, updateStatus);

// POST /api/auth/logout - Logout
router.post('/logout', authenticate, logout);

export default router;
