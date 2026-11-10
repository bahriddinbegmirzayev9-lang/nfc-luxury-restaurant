// Order Page - Order confirmation and tracking
// Dubai-class order management

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Check, Clock, ChefHat, Package, CheckCircle, ArrowLeft } from 'lucide-react';
import { orderService } from '../services/api';
import { useCartStore } from '../stores/cartStore';

const OrderPage = () => {
  const { sessionToken } = useParams();
  const navigate = useNavigate();
  const [orderStatus, setOrderStatus] = useState('confirming');
  const [orderId, setOrderId] = useState(null);
  const [loading, setLoading] = useState(false);
  const [language, setLanguage] = useState(() => {
    return localStorage.getItem('selectedLanguage') || 'uz';
  });

  const { items, getTotal, tableId, tableNumber, clearCart } = useCartStore();

  useEffect(() => {
    if (items.length === 0) {
      navigate(`/menu/${sessionToken}`);
    }
  }, [items, sessionToken, navigate]);

  const placeOrder = async () => {
    if (loading) return;

    try {
      setLoading(true);
      setOrderStatus('confirming');

      const orderData = {
        session_id: sessionToken,
        table_id: tableId,
        items: items.map((item) => ({
          menu_item_id: item.menu_item_id,
          quantity: item.quantity,
          special_instructions: item.special_instructions || null,
        })),
      };

      const response = await orderService.createOrder(orderData);

      if (response.success) {
        setOrderId(response.data.id);
        setOrderStatus('confirmed');

        // Simulate order progression
        setTimeout(() => setOrderStatus('preparing'), 3000);
        setTimeout(() => setOrderStatus('ready'), 8000);
        setTimeout(() => {
          setOrderStatus('served');
          clearCart();
        }, 12000);
      }
    } catch (error) {
      console.error('Order failed:', error);
      alert('Failed to place order. Please try again.');
      setOrderStatus('failed');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    placeOrder();
  }, []);

  const statusSteps = [
    { key: 'confirming', label: 'Confirming', icon: Clock, color: 'text-blue-400' },
    { key: 'confirmed', label: 'Confirmed', icon: Check, color: 'text-green-400' },
    { key: 'preparing', label: 'Preparing', icon: ChefHat, color: 'text-orange-400' },
    { key: 'ready', label: 'Ready', icon: Package, color: 'text-purple-400' },
    { key: 'served', label: 'Served', icon: CheckCircle, color: 'text-gold-500' },
  ];

  const currentStepIndex = statusSteps.findIndex((step) => step.key === orderStatus);

  const subtotal = getTotal();
  const tax = subtotal * 0.15;
  const service = subtotal * 0.1;
  const total = subtotal + tax + service;

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-4 py-8">
      <div className="max-w-2xl w-full">
        {/* Back Button */}
        {orderStatus === 'served' && (
          <motion.button
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            onClick={() => navigate(`/menu/${sessionToken}`)}
            className="mb-6 flex items-center gap-2 text-gray-400 hover:text-white transition"
          >
            <ArrowLeft className="w-5 h-5" />
            Back to Menu
          </motion.button>
        )}

        {/* Order Status Card */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="glass-strong rounded-3xl p-8 mb-6"
        >
          {/* Header */}
          <div className="text-center mb-8">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', delay: 0.2 }}
              className="w-20 h-20 mx-auto mb-4 gold-gradient rounded-full flex items-center justify-center"
            >
              {React.createElement(statusSteps[currentStepIndex]?.icon || Check, {
                className: 'w-10 h-10 text-luxury-dark',
              })}
            </motion.div>
            <h1 className="text-3xl font-playfair font-bold text-glow mb-2">
              {orderStatus === 'served' ? 'Enjoy Your Meal!' : 'Order in Progress'}
            </h1>
            <p className="text-gray-400">
              {orderStatus === 'served'
                ? 'Your order has been served. Bon appétit!'
                : "We're preparing your delicious meal"}
            </p>
          </div>

          {/* Progress Steps */}
          <div className="relative mb-8">
            {/* Progress Line */}
            <div className="absolute top-5 left-0 right-0 h-1 bg-white/10 rounded-full">
              <motion.div
                className="h-full gold-gradient rounded-full"
                initial={{ width: '0%' }}
                animate={{ width: `${(currentStepIndex / (statusSteps.length - 1)) * 100}%` }}
                transition={{ duration: 0.5 }}
              />
            </div>

            {/* Steps */}
            <div className="relative flex justify-between">
              {statusSteps.map((step, index) => {
                const Icon = step.icon;
                const isActive = index <= currentStepIndex;
                const isCurrent = index === currentStepIndex;

                return (
                  <div key={step.key} className="flex flex-col items-center">
                    <motion.div
                      className={`w-10 h-10 rounded-full flex items-center justify-center mb-2 ${
                        isActive ? 'gold-gradient' : 'glass'
                      }`}
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ delay: index * 0.1 }}
                    >
                      <Icon
                        className={`w-5 h-5 ${isActive ? 'text-luxury-dark' : 'text-gray-500'}`}
                      />
                    </motion.div>
                    <p
                      className={`text-xs ${
                        isCurrent ? 'text-gold-500 font-semibold' : 'text-gray-500'
                      }`}
                    >
                      {step.label}
                    </p>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Order Details */}
          <div className="glass p-6 rounded-2xl mb-6">
            <h3 className="font-semibold mb-4 flex items-center gap-2">
              <Package className="w-5 h-5 text-gold-500" />
              Order Details
            </h3>
            <div className="space-y-3">
              {items.map((item) => (
                <div key={item.menu_item_id} className="flex justify-between text-sm">
                  <span className="text-gray-300">
                    {item.quantity}x {item.name_uz}
                  </span>
                  <span className="font-semibold">
                    ${(item.price * item.quantity).toFixed(2)}
                  </span>
                </div>
              ))}
            </div>

            <div className="border-t border-white/10 mt-4 pt-4 space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Subtotal</span>
                <span>${subtotal.toFixed(2)}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Tax (15%)</span>
                <span>${tax.toFixed(2)}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Service (10%)</span>
                <span>${service.toFixed(2)}</span>
              </div>
              <div className="flex justify-between pt-2 border-t border-white/10">
                <span className="font-bold text-lg">Total</span>
                <span className="font-bold text-xl text-gold-500">${total.toFixed(2)}</span>
              </div>
            </div>
          </div>

          {/* Info */}
          <div className="text-center text-sm text-gray-400">
            <p>Table {tableNumber}</p>
            {orderId && <p className="text-xs mt-1">Order ID: {orderId}</p>}
          </div>
        </motion.div>

        {/* Action Buttons */}
        {orderStatus === 'served' && (
          <div className="grid grid-cols-2 gap-4">
            <motion.button
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              onClick={() => navigate(`/menu/${sessionToken}`)}
              className="glass-strong py-3 rounded-xl hover:bg-white/10 transition"
            >
              Order More
            </motion.button>
            <motion.button
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="gold-gradient py-3 rounded-xl font-semibold text-luxury-dark"
            >
              Request Bill
            </motion.button>
          </div>
        )}
      </div>
    </div>
  );
};

export default OrderPage;
