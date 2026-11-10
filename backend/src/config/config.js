// Server Configuration
// Main config file for NFC Luxury Restaurant Backend

import dotenv from 'dotenv';
dotenv.config();

export const config = {
  // Server
  port: process.env.PORT || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  apiVersion: process.env.API_VERSION || 'v1',

  // Database
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    name: process.env.DB_NAME || 'nfc_luxury_restaurant',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
  },

  // JWT
  jwt: {
    secret: process.env.JWT_SECRET || 'change-this-secret',
    expire: process.env.JWT_EXPIRE || '7d',
  },

  // CORS
  cors: {
    origin: process.env.CORS_ORIGIN?.split(',') || ['http://localhost:5173', 'http://localhost:3000'],
    credentials: true,
  },

  // Socket.IO
  socket: {
    port: process.env.SOCKET_PORT || 5001,
  },

  // NFC
  nfc: {
    tagPrefix: process.env.NFC_TAG_PREFIX || 'nfc://table/',
    encryptionKey: process.env.NFC_ENCRYPTION_KEY || 'default-key',
  },

  // Business Logic
  business: {
    taxRate: parseFloat(process.env.TAX_RATE) || 0.15,
    serviceChargeRate: parseFloat(process.env.SERVICE_CHARGE_RATE) || 0.10,
    sessionTimeout: parseInt(process.env.SESSION_TIMEOUT) || 14400000, // 4 hours
  },

  // File Upload
  upload: {
    maxFileSize: parseInt(process.env.MAX_FILE_SIZE) || 5242880, // 5MB
    uploadDir: process.env.UPLOAD_DIR || './uploads',
  },
};

export default config;
