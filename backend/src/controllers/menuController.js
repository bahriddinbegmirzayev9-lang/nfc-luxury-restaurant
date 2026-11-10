// Menu Controller
// Handle menu categories and items

import { query } from '../config/database.js';

// Get all menu categories
export const getCategories = async (req, res) => {
  try {
    const result = await query(
      `SELECT * FROM menu_categories
       WHERE is_active = true
       ORDER BY sort_order ASC`
    );

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error('Get categories error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching categories',
    });
  }
};

// Get all menu items or by category
export const getMenuItems = async (req, res) => {
  try {
    const { category_id, featured, language = 'uz' } = req.query;

    let queryText = `
      SELECT
        mi.*,
        mc.name_${language} as category_name
      FROM menu_items mi
      JOIN menu_categories mc ON mi.category_id = mc.id
      WHERE mi.is_available = true
    `;
    const params = [];

    if (category_id) {
      params.push(category_id);
      queryText += ` AND mi.category_id = $${params.length}`;
    }

    if (featured === 'true') {
      queryText += ' AND mi.is_featured = true';
    }

    queryText += ' ORDER BY mi.sort_order ASC, mi.created_at DESC';

    const result = await query(queryText, params);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows,
    });
  } catch (error) {
    console.error('Get menu items error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching menu items',
    });
  }
};

// Get single menu item
export const getMenuItem = async (req, res) => {
  try {
    const { id } = req.params;
    const { language = 'uz' } = req.query;

    const result = await query(
      `SELECT
        mi.*,
        mc.name_${language} as category_name
       FROM menu_items mi
       JOIN menu_categories mc ON mi.category_id = mc.id
       WHERE mi.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Menu item not found',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Get menu item error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching menu item',
    });
  }
};

// Search menu items
export const searchMenuItems = async (req, res) => {
  try {
    const { q, language = 'uz' } = req.query;

    if (!q) {
      return res.status(400).json({
        success: false,
        message: 'Search query is required',
      });
    }

    const result = await query(
      `SELECT mi.*, mc.name_${language} as category_name
       FROM menu_items mi
       JOIN menu_categories mc ON mi.category_id = mc.id
       WHERE mi.is_available = true
       AND (
         mi.name_${language} ILIKE $1 OR
         mi.description_${language} ILIKE $1
       )
       ORDER BY mi.rating DESC, mi.sort_order ASC
       LIMIT 20`,
      [`%${q}%`]
    );

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows,
    });
  } catch (error) {
    console.error('Search menu error:', error);
    res.status(500).json({
      success: false,
      message: 'Error searching menu',
    });
  }
};
