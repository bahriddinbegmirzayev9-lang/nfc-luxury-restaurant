// Order Controller
// Handle order creation, updates, and management

import { query, transaction } from '../config/database.js';
import { v4 as uuidv4 } from 'uuid';
import { config } from '../config/config.js';

// Create new order
export const createOrder = async (req, res) => {
  try {
    const { session_id, table_id, items, notes } = req.body;

    if (!session_id || !table_id || !items || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const result = await transaction(async (client) => {
      // Calculate totals
      let subtotal = 0;
      const orderItems = [];

      for (const item of items) {
        const menuItem = await client.query(
          'SELECT price, is_available FROM menu_items WHERE id = $1',
          [item.menu_item_id]
        );

        if (menuItem.rows.length === 0 || !menuItem.rows[0].is_available) {
          throw new Error(`Menu item ${item.menu_item_id} not available`);
        }

        const price = parseFloat(menuItem.rows[0].price);
        const quantity = parseInt(item.quantity);
        const itemTotal = price * quantity;

        subtotal += itemTotal;
        orderItems.push({
          menu_item_id: item.menu_item_id,
          quantity,
          unit_price: price,
          total_price: itemTotal,
          special_instructions: item.special_instructions || null,
        });
      }

      // Calculate tax and service charge
      const taxAmount = subtotal * config.business.taxRate;
      const serviceCharge = subtotal * config.business.serviceChargeRate;
      const totalAmount = subtotal + taxAmount + serviceCharge;

      // Generate order number
      const orderNumber = `ORD-${Date.now()}-${Math.random().toString(36).substr(2, 5).toUpperCase()}`;

      // Create order
      const orderResult = await client.query(
        `INSERT INTO orders (
          session_id, table_id, order_number, subtotal,
          tax_amount, service_charge, total_amount, notes, status
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING *`,
        [
          session_id,
          table_id,
          orderNumber,
          subtotal,
          taxAmount,
          serviceCharge,
          totalAmount,
          notes,
          'pending',
        ]
      );

      const order = orderResult.rows[0];

      // Create order items
      for (const item of orderItems) {
        await client.query(
          `INSERT INTO order_items (
            order_id, menu_item_id, quantity, unit_price, total_price, special_instructions
          ) VALUES ($1, $2, $3, $4, $5, $6)`,
          [
            order.id,
            item.menu_item_id,
            item.quantity,
            item.unit_price,
            item.total_price,
            item.special_instructions,
          ]
        );
      }

      // Update session total
      await client.query(
        'UPDATE sessions SET total_amount = total_amount + $1 WHERE id = $2',
        [totalAmount, session_id]
      );

      return order;
    });

    // Emit socket event (will be implemented)
    // io.to(`table-${table_id}`).emit('new-order', result);

    res.status(201).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error('Create order error:', error);
    res.status(500).json({
      success: false,
      message: error.message || 'Error creating order',
    });
  }
};

// Get order by ID
export const getOrder = async (req, res) => {
  try {
    const { id } = req.params;

    const orderResult = await query(
      `SELECT o.*, t.table_number, s.session_token
       FROM orders o
       JOIN tables t ON o.table_id = t.id
       JOIN sessions s ON o.session_id = s.id
       WHERE o.id = $1`,
      [id]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    const order = orderResult.rows[0];

    // Get order items
    const itemsResult = await query(
      `SELECT oi.*, mi.name_uz, mi.name_ru, mi.name_en, mi.image_url
       FROM order_items oi
       JOIN menu_items mi ON oi.menu_item_id = mi.id
       WHERE oi.order_id = $1`,
      [id]
    );

    order.items = itemsResult.rows;

    res.json({
      success: true,
      data: order,
    });
  } catch (error) {
    console.error('Get order error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching order',
    });
  }
};

// Get orders by table or session
export const getOrders = async (req, res) => {
  try {
    const { table_id, session_id, status } = req.query;

    let queryText = `
      SELECT o.*, t.table_number
      FROM orders o
      JOIN tables t ON o.table_id = t.id
      WHERE 1=1
    `;
    const params = [];

    if (table_id) {
      params.push(table_id);
      queryText += ` AND o.table_id = $${params.length}`;
    }

    if (session_id) {
      params.push(session_id);
      queryText += ` AND o.session_id = $${params.length}`;
    }

    if (status) {
      params.push(status);
      queryText += ` AND o.status = $${params.length}`;
    }

    queryText += ' ORDER BY o.created_at DESC';

    const result = await query(queryText, params);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows,
    });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching orders',
    });
  }
};

// Update order status
export const updateOrderStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['pending', 'confirmed', 'preparing', 'ready', 'served', 'cancelled'];

    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status',
      });
    }

    const result = await query(
      `UPDATE orders
       SET status = $1,
           confirmed_at = CASE WHEN $1 = 'confirmed' THEN NOW() ELSE confirmed_at END,
           completed_at = CASE WHEN $1 = 'served' THEN NOW() ELSE completed_at END
       WHERE id = $2
       RETURNING *`,
      [status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Emit socket event
    // io.to(`table-${result.rows[0].table_id}`).emit('order-status-updated', result.rows[0]);

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Update order status error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating order status',
    });
  }
};

// Get order bill
export const getOrderBill = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await query(
      `SELECT o.*, t.table_number, s.session_token
       FROM orders o
       JOIN tables t ON o.table_id = t.id
       JOIN sessions s ON o.session_id = s.id
       WHERE o.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    const order = result.rows[0];

    // Get order items
    const itemsResult = await query(
      `SELECT oi.*, mi.name_uz, mi.name_ru, mi.name_en
       FROM order_items oi
       JOIN menu_items mi ON oi.menu_item_id = mi.id
       WHERE oi.order_id = $1`,
      [id]
    );

    const bill = {
      order_number: order.order_number,
      table_number: order.table_number,
      created_at: order.created_at,
      items: itemsResult.rows,
      subtotal: parseFloat(order.subtotal),
      tax_amount: parseFloat(order.tax_amount),
      service_charge: parseFloat(order.service_charge),
      discount_amount: parseFloat(order.discount_amount),
      total_amount: parseFloat(order.total_amount),
    };

    res.json({
      success: true,
      data: bill,
    });
  } catch (error) {
    console.error('Get bill error:', error);
    res.status(500).json({
      success: false,
      message: 'Error generating bill',
    });
  }
};
