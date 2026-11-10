// Main Server File
// NFC Luxury Restaurant Backend API Server

import express from 'express';
import cors from 'cors';
import { createServer } from 'http';
import dotenv from 'dotenv';
import { config } from './src/config/config.js';
import { initSocket } from './src/socket/index.js';
import { errorHandler, notFound } from './src/middleware/errorHandler.js';

// Import routes
import nfcRoutes from './src/routes/nfc.js';
import menuRoutes from './src/routes/menu.js';
import orderRoutes from './src/routes/orders.js';
import waiterCallRoutes from './src/routes/waiterCalls.js';
import authRoutes from './src/routes/auth.js';

// Load environment variables
dotenv.config();

// Initialize Express app
const app = express();
const server = createServer(app);

// Initialize Socket.IO
const io = initSocket(server);

// Make io available to routes
app.set('io', io);

// Middleware
app.use(cors(config.cors));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logger
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'NFC Luxury Restaurant API is running',
    timestamp: new Date().toISOString(),
    environment: config.nodeEnv,
  });
});

// API Routes
const apiPrefix = `/api/${config.apiVersion}`;

app.use(`${apiPrefix}/nfc`, nfcRoutes);
app.use(`${apiPrefix}/menu`, menuRoutes);
app.use(`${apiPrefix}/orders`, orderRoutes);
app.use(`${apiPrefix}/waiter-calls`, waiterCallRoutes);
app.use(`${apiPrefix}/auth`, authRoutes);

// 404 handler
app.use(notFound);

// Error handler
app.use(errorHandler);

// Start server
const PORT = config.port;

server.listen(PORT, () => {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════╗');
  console.log('║                                                        ║');
  console.log('║     🏆 NFC LUXURY RESTAURANT API SERVER 🏆            ║');
  console.log('║     Dubai-Class Restaurant Management System          ║');
  console.log('║                                                        ║');
  console.log('╚════════════════════════════════════════════════════════╝');
  console.log('');
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Environment: ${config.nodeEnv}`);
  console.log(`📡 API Base URL: http://localhost:${PORT}${apiPrefix}`);
  console.log(`⚡ Socket.IO: Ready`);
  console.log('');
  console.log('Available endpoints:');
  console.log(`  - POST   ${apiPrefix}/nfc/scan`);
  console.log(`  - GET    ${apiPrefix}/menu/categories`);
  console.log(`  - GET    ${apiPrefix}/menu/items`);
  console.log(`  - POST   ${apiPrefix}/orders`);
  console.log(`  - POST   ${apiPrefix}/waiter-calls`);
  console.log(`  - POST   ${apiPrefix}/auth/login`);
  console.log('');
  console.log('✨ Ready to serve world-class dining experiences!');
  console.log('');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});

export default app;
