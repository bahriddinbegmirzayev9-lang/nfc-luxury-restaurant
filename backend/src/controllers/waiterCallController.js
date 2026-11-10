// Waiter Call Controller
// Handle waiter call requests from customers

import { query } from '../config/database.js';

// Create waiter call
export const createWaiterCall = async (req, res) => {
  try {
    const { table_id, session_id, call_type, message, priority = 'normal' } = req.body;

    if (!table_id || !session_id || !call_type) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
      });
    }

    const validTypes = ['assistance', 'bill', 'complaint', 'menu', 'refill', 'other'];
    if (!validTypes.includes(call_type)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid call type',
      });
    }

    const result = await query(
      `INSERT INTO waiter_calls (table_id, session_id, call_type, message, priority, status)
       VALUES ($1, $2, $3, $4, $5, 'pending')
       RETURNING *`,
      [table_id, session_id, call_type, message, priority]
    );

    // Emit socket event to waiters
    // io.to('waiters').emit('new-call', result.rows[0]);

    res.status(201).json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Create waiter call error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating waiter call',
    });
  }
};

// Get all waiter calls
export const getWaiterCalls = async (req, res) => {
  try {
    const { status, waiter_id } = req.query;

    let queryText = `
      SELECT wc.*, t.table_number, w.name as waiter_name
      FROM waiter_calls wc
      JOIN tables t ON wc.table_id = t.id
      LEFT JOIN waiters w ON wc.waiter_id = w.id
      WHERE 1=1
    `;
    const params = [];

    if (status) {
      params.push(status);
      queryText += ` AND wc.status = $${params.length}`;
    }

    if (waiter_id) {
      params.push(waiter_id);
      queryText += ` AND wc.waiter_id = $${params.length}`;
    }

    queryText += ' ORDER BY wc.priority DESC, wc.created_at DESC';

    const result = await query(queryText, params);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows,
    });
  } catch (error) {
    console.error('Get waiter calls error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching waiter calls',
    });
  }
};

// Update waiter call status
export const updateWaiterCall = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, waiter_id } = req.body;

    const validStatuses = ['pending', 'assigned', 'in_progress', 'completed', 'cancelled'];

    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status',
      });
    }

    let queryText = `
      UPDATE waiter_calls
      SET status = $1,
          assigned_at = CASE WHEN $1 = 'assigned' THEN NOW() ELSE assigned_at END,
          completed_at = CASE WHEN $1 = 'completed' THEN NOW() ELSE completed_at END
    `;
    const params = [status];

    if (waiter_id) {
      params.push(waiter_id);
      queryText += `, waiter_id = $${params.length}`;
    }

    params.push(id);
    queryText += ` WHERE id = $${params.length} RETURNING *`;

    const result = await query(queryText, params);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Waiter call not found',
      });
    }

    // Emit socket event
    // io.to(`table-${result.rows[0].table_id}`).emit('call-status-updated', result.rows[0]);

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Update waiter call error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating waiter call',
    });
  }
};
