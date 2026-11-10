// Socket.IO Configuration
// Real-time communication for orders, calls, and notifications

import { Server } from 'socket.io';
import jwt from 'jsonwebtoken';
import { config } from '../config/config.js';

let io;

export const initSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: config.cors.origin,
      methods: ['GET', 'POST'],
      credentials: true,
    },
  });

  // Authentication middleware for socket
  io.use((socket, next) => {
    const token = socket.handshake.auth.token;

    // Allow customers without token
    if (!token) {
      socket.data.userType = 'customer';
      return next();
    }

    // Verify waiter token
    try {
      const decoded = jwt.verify(token, config.jwt.secret);
      socket.data.waiter = decoded;
      socket.data.userType = 'waiter';
      next();
    } catch (error) {
      next(new Error('Authentication error'));
    }
  });

  io.on('connection', (socket) => {
    console.log(`✅ Socket connected: ${socket.id} (${socket.data.userType})`);

    // Customer joins table room
    socket.on('join-table', (tableId) => {
      socket.join(`table-${tableId}`);
      console.log(`Customer joined table-${tableId}`);
    });

    // Waiter joins waiters room
    if (socket.data.userType === 'waiter') {
      socket.join('waiters');
      socket.join(`waiter-${socket.data.waiter.id}`);
      console.log(`Waiter ${socket.data.waiter.id} joined waiters room`);
    }

    // Leave table room
    socket.on('leave-table', (tableId) => {
      socket.leave(`table-${tableId}`);
      console.log(`Customer left table-${tableId}`);
    });

    // Disconnect
    socket.on('disconnect', () => {
      console.log(`❌ Socket disconnected: ${socket.id}`);
    });
  });

  return io;
};

// Get io instance
export const getIO = () => {
  if (!io) {
    throw new Error('Socket.io not initialized');
  }
  return io;
};

// Emit events helpers
export const emitToTable = (tableId, event, data) => {
  if (io) {
    io.to(`table-${tableId}`).emit(event, data);
  }
};

export const emitToWaiters = (event, data) => {
  if (io) {
    io.to('waiters').emit(event, data);
  }
};

export const emitToWaiter = (waiterId, event, data) => {
  if (io) {
    io.to(`waiter-${waiterId}`).emit(event, data);
  }
};

export default { initSocket, getIO, emitToTable, emitToWaiters, emitToWaiter };
