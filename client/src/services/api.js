// API Service
// All API calls to backend

import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// NFC Services
export const nfcService = {
  scanTag: async (tagUid) => {
    const response = await api.post('/nfc/scan', { tag_uid: tagUid });
    return response.data;
  },

  getTableInfo: async (tableId) => {
    const response = await api.get(`/nfc/tables/${tableId}`);
    return response.data;
  },

  getSession: async (sessionToken) => {
    const response = await api.get(`/nfc/sessions/${sessionToken}`);
    return response.data;
  },
};

// Menu Services
export const menuService = {
  getCategories: async () => {
    const response = await api.get('/menu/categories');
    return response.data;
  },

  getMenuItems: async (params = {}) => {
    const response = await api.get('/menu/items', { params });
    return response.data;
  },

  getMenuItem: async (id) => {
    const response = await api.get(`/menu/items/${id}`);
    return response.data;
  },

  searchItems: async (query) => {
    const response = await api.get('/menu/search', { params: { q: query } });
    return response.data;
  },
};

// Order Services
export const orderService = {
  createOrder: async (orderData) => {
    const response = await api.post('/orders', orderData);
    return response.data;
  },

  getOrder: async (orderId) => {
    const response = await api.get(`/orders/${orderId}`);
    return response.data;
  },

  getOrders: async (params = {}) => {
    const response = await api.get('/orders', { params });
    return response.data;
  },

  updateStatus: async (orderId, status) => {
    const response = await api.patch(`/orders/${orderId}/status`, { status });
    return response.data;
  },

  getBill: async (orderId) => {
    const response = await api.get(`/orders/${orderId}/bill`);
    return response.data;
  },
};

// Waiter Call Services
export const waiterCallService = {
  callWaiter: async (callData) => {
    const response = await api.post('/waiter-calls', callData);
    return response.data;
  },

  getCalls: async (params = {}) => {
    const response = await api.get('/waiter-calls', { params });
    return response.data;
  },

  updateCall: async (callId, status, waiterId) => {
    const response = await api.patch(`/waiter-calls/${callId}`, { status, waiter_id: waiterId });
    return response.data;
  },
};

// Auth Services (for waiter app)
export const authService = {
  login: async (phone, password) => {
    const response = await api.post('/auth/login', { phone, password });
    return response.data;
  },

  getMe: async (token) => {
    const response = await api.get('/auth/me', {
      headers: { Authorization: `Bearer ${token}` },
    });
    return response.data;
  },

  updateStatus: async (token, status) => {
    const response = await api.patch(
      '/auth/status',
      { status },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    return response.data;
  },

  logout: async (token) => {
    const response = await api.post(
      '/auth/logout',
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    return response.data;
  },
};

export default api;
