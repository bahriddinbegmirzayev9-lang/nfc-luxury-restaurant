// Authentication Controller
// Handle waiter login and authentication

import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { query } from '../config/database.js';
import { config } from '../config/config.js';

// Login
export const login = async (req, res) => {
  try {
    const { phone, password } = req.body;

    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Phone and password are required',
      });
    }

    // Find waiter
    const result = await query(
      'SELECT * FROM waiters WHERE phone = $1 AND is_active = true',
      [phone]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    const waiter = result.rows[0];

    // Check password
    const isPasswordValid = await bcrypt.compare(password, waiter.password_hash);

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        id: waiter.id,
        phone: waiter.phone,
        role: waiter.role,
      },
      config.jwt.secret,
      { expiresIn: config.jwt.expire }
    );

    // Update last login
    await query('UPDATE waiters SET last_login = NOW(), status = $1 WHERE id = $2', [
      'online',
      waiter.id,
    ]);

    // Remove password from response
    delete waiter.password_hash;

    res.json({
      success: true,
      token,
      data: waiter,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Error during login',
    });
  }
};

// Get current user
export const getMe = async (req, res) => {
  try {
    res.json({
      success: true,
      data: req.user,
    });
  } catch (error) {
    console.error('Get me error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching user data',
    });
  }
};

// Update waiter status
export const updateStatus = async (req, res) => {
  try {
    const { status } = req.body;

    const validStatuses = ['online', 'offline', 'busy'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status',
      });
    }

    const result = await query(
      'UPDATE waiters SET status = $1 WHERE id = $2 RETURNING id, name, status',
      [status, req.user.id]
    );

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Update status error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating status',
    });
  }
};

// Logout
export const logout = async (req, res) => {
  try {
    await query('UPDATE waiters SET status = $1 WHERE id = $2', ['offline', req.user.id]);

    res.json({
      success: true,
      message: 'Logged out successfully',
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({
      success: false,
      message: 'Error during logout',
    });
  }
};
