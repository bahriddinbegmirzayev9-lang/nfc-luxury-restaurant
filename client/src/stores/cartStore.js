// Zustand Store for Cart Management
// Dubai-class state management

import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export const useCartStore = create(
  persist(
    (set, get) => ({
      items: [],
      sessionToken: null,
      tableId: null,
      tableNumber: null,

      // Set session info
      setSession: (sessionToken, tableId, tableNumber) =>
        set({ sessionToken, tableId, tableNumber }),

      // Add item to cart
      addItem: (menuItem, quantity = 1, specialInstructions = '') => {
        const items = get().items;
        const existingIndex = items.findIndex(
          (item) =>
            item.menu_item_id === menuItem.id &&
            item.special_instructions === specialInstructions
        );

        if (existingIndex > -1) {
          const newItems = [...items];
          newItems[existingIndex].quantity += quantity;
          set({ items: newItems });
        } else {
          set({
            items: [
              ...items,
              {
                menu_item_id: menuItem.id,
                name_uz: menuItem.name_uz,
                name_ru: menuItem.name_ru,
                name_en: menuItem.name_en,
                price: menuItem.price,
                image_url: menuItem.image_url,
                quantity,
                special_instructions: specialInstructions,
              },
            ],
          });
        }
      },

      // Update item quantity
      updateQuantity: (menuItemId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(menuItemId);
          return;
        }
        const items = get().items;
        const newItems = items.map((item) =>
          item.menu_item_id === menuItemId ? { ...item, quantity } : item
        );
        set({ items: newItems });
      },

      // Remove item from cart
      removeItem: (menuItemId) => {
        const items = get().items.filter((item) => item.menu_item_id !== menuItemId);
        set({ items });
      },

      // Clear cart
      clearCart: () => set({ items: [] }),

      // Get cart total
      getTotal: () => {
        const items = get().items;
        return items.reduce((total, item) => total + item.price * item.quantity, 0);
      },

      // Get item count
      getItemCount: () => {
        const items = get().items;
        return items.reduce((count, item) => count + item.quantity, 0);
      },
    }),
    {
      name: 'luxury-cart-storage',
    }
  )
);
