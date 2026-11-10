// Menu Routes
// Routes for menu categories and items

import express from 'express';
import {
  getCategories,
  getMenuItems,
  getMenuItem,
  searchMenuItems,
} from '../controllers/menuController.js';

const router = express.Router();

// GET /api/menu/categories - Get all categories
router.get('/categories', getCategories);

// GET /api/menu/items - Get all menu items (with filters)
router.get('/items', getMenuItems);

// GET /api/menu/items/:id - Get single menu item
router.get('/items/:id', getMenuItem);

// GET /api/menu/search - Search menu items
router.get('/search', searchMenuItems);

export default router;
