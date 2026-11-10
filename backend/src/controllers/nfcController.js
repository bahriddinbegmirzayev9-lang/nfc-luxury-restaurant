// NFC Controller
// Handle NFC scanning and table identification

import { query } from '../config/database.js';
import { v4 as uuidv4 } from 'uuid';

// Scan NFC tag and get table info
export const scanNFC = async (req, res) => {
  try {
    const { tag_uid } = req.body;

    if (!tag_uid) {
      return res.status(400).json({
        success: false,
        message: 'NFC tag UID is required',
      });
    }

    // Find NFC tag and associated table
    const tagResult = await query(
      `SELECT nfc.*, t.table_number, t.capacity, t.status, t.floor_level
       FROM nfc_tags nfc
       JOIN tables t ON nfc.table_id = t.id
       WHERE nfc.tag_uid = $1 AND nfc.is_active = true`,
      [tag_uid]
    );

    if (tagResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Invalid or inactive NFC tag',
      });
    }

    const tag = tagResult.rows[0];

    // Update last scanned time
    await query(
      'UPDATE nfc_tags SET last_scanned_at = NOW() WHERE id = $1',
      [tag.id]
    );

    // Check for active session
    const sessionResult = await query(
      `SELECT * FROM sessions
       WHERE table_id = $1 AND is_active = true
       ORDER BY created_at DESC LIMIT 1`,
      [tag.table_id]
    );

    let session;

    if (sessionResult.rows.length === 0) {
      // Create new session
      const sessionToken = uuidv4();
      const newSession = await query(
        `INSERT INTO sessions (table_id, session_token)
         VALUES ($1, $2)
         RETURNING *`,
        [tag.table_id, sessionToken]
      );
      session = newSession.rows[0];

      // Update table status
      await query(
        'UPDATE tables SET status = $1 WHERE id = $2',
        ['occupied', tag.table_id]
      );
    } else {
      session = sessionResult.rows[0];
    }

    res.json({
      success: true,
      data: {
        table: {
          id: tag.table_id,
          number: tag.table_number,
          capacity: tag.capacity,
          status: tag.status,
          floor: tag.floor_level,
        },
        session: {
          id: session.id,
          token: session.session_token,
          startTime: session.start_time,
        },
      },
    });
  } catch (error) {
    console.error('NFC scan error:', error);
    res.status(500).json({
      success: false,
      message: 'Error scanning NFC tag',
    });
  }
};

// Get table info by ID
export const getTableInfo = async (req, res) => {
  try {
    const { tableId } = req.params;

    const result = await query(
      'SELECT * FROM tables WHERE id = $1',
      [tableId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Table not found',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Get table error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching table info',
    });
  }
};

// Get session info
export const getSession = async (req, res) => {
  try {
    const { sessionToken } = req.params;

    const result = await query(
      `SELECT s.*, t.table_number, t.capacity
       FROM sessions s
       JOIN tables t ON s.table_id = t.id
       WHERE s.session_token = $1 AND s.is_active = true`,
      [sessionToken]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Session not found or expired',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Get session error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching session',
    });
  }
};
