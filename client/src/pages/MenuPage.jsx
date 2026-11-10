// Menu Page - Main customer experience
// Dubai-class luxury menu with 3D effects

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import {
  ShoppingCart,
  Search,
  Filter,
  X,
  Plus,
  Minus,
  ChevronRight,
  Bell,
  Receipt,
  MessageCircle,
} from 'lucide-react';
import { menuService, waiterCallService } from '../services/api';
import { useCartStore } from '../stores/cartStore';

const MenuPage = () => {
  const { sessionToken } = useParams();
  const navigate = useNavigate();
  const [categories, setCategories] = useState([]);
  const [menuItems, setMenuItems] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [showCart, setShowCart] = useState(false);
  const [language, setLanguage] = useState(() => {
    // Get saved language from localStorage or default to 'uz'
    return localStorage.getItem('selectedLanguage') || 'uz';
  });

  const { items, addItem, updateQuantity, removeItem, getTotal, getItemCount, tableNumber } =
    useCartStore();

  // Save language to localStorage when it changes
  useEffect(() => {
    localStorage.setItem('selectedLanguage', language);
  }, [language]);

  useEffect(() => {
    loadMenuData();
  }, [language]);

  const loadMenuData = async () => {
    try {
      const [categoriesRes, itemsRes] = await Promise.all([
        menuService.getCategories(),
        menuService.getMenuItems({ language }),
      ]);

      if (categoriesRes.success) setCategories(categoriesRes.data);
      if (itemsRes.success) setMenuItems(itemsRes.data);
    } catch (error) {
      console.error('Failed to load menu:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredItems = menuItems.filter((item) => {
    const matchesCategory = !selectedCategory || item.category_id === selectedCategory;
    const matchesSearch =
      !searchQuery ||
      item[`name_${language}`].toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleCallWaiter = async (type) => {
    try {
      await waiterCallService.callWaiter({
        table_id: useCartStore.getState().tableId,
        session_id: sessionToken,
        call_type: type,
        priority: type === 'bill' ? 'high' : 'normal',
      });
      alert('Waiter has been notified! 👨‍🍳');
    } catch (error) {
      console.error('Failed to call waiter:', error);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <motion.div
          className="w-20 h-20 border-4 border-gold-500 border-t-transparent rounded-full"
          animate={{ rotate: 360 }}
          transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
        />
      </div>
    );
  }

  return (
    <div className="min-h-screen pb-24">
      {/* Header */}
      <div className="glass-strong sticky top-0 z-50 px-4 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-playfair font-bold text-glow">Luxury Menu</h1>
            <p className="text-sm text-gray-400">Table {tableNumber || 'N/A'}</p>
          </div>

          <div className="flex items-center gap-3">
            {/* Language Toggle */}
            <select
              value={language}
              onChange={(e) => setLanguage(e.target.value)}
              className="glass px-3 py-2 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-gold-500"
            >
              <option value="uz">UZ</option>
              <option value="ru">RU</option>
              <option value="en">EN</option>
            </select>

            {/* Cart Button */}
            <motion.button
              onClick={() => setShowCart(true)}
              className="glass px-4 py-2 rounded-xl flex items-center gap-2 relative"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <ShoppingCart className="w-5 h-5" />
              {getItemCount() > 0 && (
                <span className="absolute -top-2 -right-2 bg-gold-500 text-luxury-dark w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold">
                  {getItemCount()}
                </span>
              )}
            </motion.button>
          </div>
        </div>

        {/* Search Bar */}
        <div className="max-w-7xl mx-auto mt-4">
          <div className="glass flex items-center gap-3 px-4 py-3 rounded-xl">
            <Search className="w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search delicious food..."
              className="flex-1 bg-transparent outline-none text-white placeholder-gray-400"
            />
          </div>
        </div>
      </div>

      {/* Categories */}
      <div className="px-4 py-6">
        <div className="max-w-7xl mx-auto">
          <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
            <motion.button
              onClick={() => setSelectedCategory(null)}
              className={`px-6 py-2 rounded-xl whitespace-nowrap transition ${
                !selectedCategory
                  ? 'gold-gradient text-luxury-dark font-semibold'
                  : 'glass hover:bg-white/10'
              }`}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              All
            </motion.button>
            {categories.map((cat) => (
              <motion.button
                key={cat.id}
                onClick={() => setSelectedCategory(cat.id)}
                className={`px-6 py-2 rounded-xl whitespace-nowrap transition ${
                  selectedCategory === cat.id
                    ? 'gold-gradient text-luxury-dark font-semibold'
                    : 'glass hover:bg-white/10'
                }`}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
              >
                {cat.icon} {cat[`name_${language}`]}
              </motion.button>
            ))}
          </div>
        </div>
      </div>

      {/* Menu Items Grid */}
      <div className="px-4">
        <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredItems.map((item, index) => (
            <motion.div
              key={item.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              className="glass-strong rounded-2xl overflow-hidden card-hover cursor-pointer"
              onClick={() => addItem(item, 1)}
            >
              {/* Image */}
              <div className="relative h-48 bg-gradient-to-br from-gold-500/20 to-rose-gold/20 overflow-hidden">
                {item.image_url ? (
                  <img
                    src={item.image_url}
                    alt={item[`name_${language}`]}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-6xl">
                    🍽️
                  </div>
                )}
                {item.is_featured && (
                  <div className="absolute top-3 right-3 gold-gradient px-3 py-1 rounded-full text-xs font-semibold text-luxury-dark">
                    ⭐ Featured
                  </div>
                )}
              </div>

              {/* Content */}
              <div className="p-4">
                <h3 className="text-lg font-semibold mb-1">{item[`name_${language}`]}</h3>
                <p className="text-sm text-gray-400 mb-3 line-clamp-2">
                  {item[`description_${language}`]}
                </p>

                {/* Meta */}
                <div className="flex items-center gap-2 mb-3 text-xs text-gray-500">
                  {item.is_vegetarian && <span className="glass px-2 py-1 rounded">🌱 Veg</span>}
                  {item.is_spicy && <span className="glass px-2 py-1 rounded">🌶️ Spicy</span>}
                  {item.preparation_time && (
                    <span className="glass px-2 py-1 rounded">⏱️ {item.preparation_time}min</span>
                  )}
                </div>

                {/* Price & Add Button */}
                <div className="flex items-center justify-between">
                  <div className="text-2xl font-bold text-gold-500">
                    ${parseFloat(item.price).toFixed(2)}
                  </div>
                  <motion.button
                    className="gold-gradient p-3 rounded-xl"
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      addItem(item, 1);
                    }}
                  >
                    <Plus className="w-5 h-5 text-luxury-dark" />
                  </motion.button>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Bottom Action Bar */}
      <div className="fixed bottom-0 left-0 right-0 glass-strong border-t border-white/10 p-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between gap-3">
          <motion.button
            onClick={() => handleCallWaiter('assistance')}
            className="glass flex-1 py-3 rounded-xl flex items-center justify-center gap-2 hover:bg-white/10 transition"
            whileTap={{ scale: 0.95 }}
          >
            <Bell className="w-5 h-5" />
            <span className="hidden sm:inline">Call Waiter</span>
          </motion.button>

          <motion.button
            onClick={() => handleCallWaiter('bill')}
            className="glass flex-1 py-3 rounded-xl flex items-center justify-center gap-2 hover:bg-white/10 transition"
            whileTap={{ scale: 0.95 }}
          >
            <Receipt className="w-5 h-5" />
            <span className="hidden sm:inline">Request Bill</span>
          </motion.button>

          <motion.button
            onClick={() => setShowCart(true)}
            className="gold-gradient flex-1 py-3 rounded-xl flex items-center justify-center gap-2 font-semibold text-luxury-dark"
            whileTap={{ scale: 0.95 }}
          >
            <ShoppingCart className="w-5 h-5" />
            View Cart (${getTotal().toFixed(2)})
          </motion.button>
        </div>
      </div>

      {/* Cart Sidebar */}
      <AnimatePresence>
        {showCart && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/70 z-50"
              onClick={() => setShowCart(false)}
            />
            <motion.div
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              transition={{ type: 'spring', damping: 25 }}
              className="fixed right-0 top-0 bottom-0 w-full max-w-md glass-strong z-50 overflow-y-auto"
            >
              <div className="p-6">
                {/* Cart Header */}
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-2xl font-playfair font-bold">Your Order</h2>
                  <button onClick={() => setShowCart(false)} className="p-2 hover:bg-white/10 rounded-lg transition">
                    <X className="w-6 h-6" />
                  </button>
                </div>

                {/* Cart Items */}
                {items.length === 0 ? (
                  <div className="text-center py-12 text-gray-400">
                    <ShoppingCart className="w-16 h-16 mx-auto mb-4 opacity-50" />
                    <p>Your cart is empty</p>
                  </div>
                ) : (
                  <>
                    <div className="space-y-4 mb-6">
                      {items.map((item) => (
                        <div key={item.menu_item_id} className="glass p-4 rounded-xl">
                          <div className="flex items-start justify-between mb-3">
                            <div className="flex-1">
                              <h3 className="font-semibold mb-1">{item[`name_${language}`]}</h3>
                              <p className="text-gold-500 font-bold">
                                ${parseFloat(item.price).toFixed(2)}
                              </p>
                            </div>
                          </div>

                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-3">
                              <button
                                onClick={() => updateQuantity(item.menu_item_id, item.quantity - 1)}
                                className="glass p-2 rounded-lg hover:bg-white/10 transition"
                              >
                                <Minus className="w-4 h-4" />
                              </button>
                              <span className="font-semibold w-8 text-center">{item.quantity}</span>
                              <button
                                onClick={() => updateQuantity(item.menu_item_id, item.quantity + 1)}
                                className="glass p-2 rounded-lg hover:bg-white/10 transition"
                              >
                                <Plus className="w-4 h-4" />
                              </button>
                            </div>
                            <button
                              onClick={() => removeItem(item.menu_item_id)}
                              className="text-red-400 hover:text-red-300 text-sm"
                            >
                              Remove
                            </button>
                          </div>
                        </div>
                      ))}
                    </div>

                    {/* Cart Summary */}
                    <div className="glass p-4 rounded-xl mb-4">
                      <div className="flex justify-between mb-2">
                        <span className="text-gray-400">Subtotal</span>
                        <span className="font-semibold">${getTotal().toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between mb-2">
                        <span className="text-gray-400">Tax (15%)</span>
                        <span className="font-semibold">${(getTotal() * 0.15).toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between mb-2">
                        <span className="text-gray-400">Service (10%)</span>
                        <span className="font-semibold">${(getTotal() * 0.1).toFixed(2)}</span>
                      </div>
                      <div className="border-t border-white/10 mt-3 pt-3 flex justify-between">
                        <span className="font-bold text-lg">Total</span>
                        <span className="font-bold text-xl text-gold-500">
                          ${(getTotal() * 1.25).toFixed(2)}
                        </span>
                      </div>
                    </div>

                    {/* Place Order Button */}
                    <motion.button
                      onClick={() => navigate(`/orders/${sessionToken}`)}
                      className="w-full gold-gradient py-4 rounded-xl font-bold text-lg text-luxury-dark flex items-center justify-center gap-2"
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                    >
                      Place Order
                      <ChevronRight className="w-5 h-5" />
                    </motion.button>
                  </>
                )}
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
};

export default MenuPage;
