// NFC Scan Page - Landing Page
// Dubai-class luxury welcome screen with NFC scanning

import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Sparkles, Wifi, ChevronDown } from 'lucide-react';
import { nfcService } from '../services/api';
import { useCartStore } from '../stores/cartStore';

const NFCScanPage = () => {
  const [scanning, setScanning] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const setSession = useCartStore((state) => state.setSession);

  // Check if Web NFC is supported
  const isNFCSupported = 'NDEFReader' in window;

  const startNFCScan = async () => {
    if (!isNFCSupported) {
      setError('NFC is not supported on this device');
      return;
    }

    try {
      setScanning(true);
      setError('');

      const ndef = new NDEFReader();
      await ndef.scan();

      ndef.addEventListener('reading', async ({ serialNumber }) => {
        console.log('NFC Tag scanned:', serialNumber);

        try {
          const result = await nfcService.scanTag(serialNumber);

          if (result.success) {
            const { table, session } = result.data;
            setSession(session.token, table.id, table.number);
            navigate(`/menu/${session.token}`);
          }
        } catch (err) {
          setError('Invalid NFC tag. Please contact staff.');
          setScanning(false);
        }
      });
    } catch (err) {
      console.error('NFC scan error:', err);
      setError('Failed to start NFC scan. Please try again.');
      setScanning(false);
    }
  };

  // Fallback: Manual table number entry
  const [showManualEntry, setShowManualEntry] = useState(false);
  const [tableNumber, setTableNumber] = useState('');

  const handleManualEntry = async () => {
    if (!tableNumber) return;

    try {
      // For demo: generate a fake session
      const fakeSession = {
        token: `demo-session-${Date.now()}`,
        id: `table-${tableNumber}`,
      };
      setSession(fakeSession.token, fakeSession.id, parseInt(tableNumber));
      navigate(`/menu/${fakeSession.token}`);
    } catch (err) {
      setError('Invalid table number');
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center relative overflow-hidden px-4">
      {/* Animated Background Elements */}
      <div className="absolute inset-0 overflow-hidden">
        <motion.div
          className="absolute top-20 left-10 w-32 h-32 bg-gold-500/10 rounded-full blur-3xl"
          animate={{
            scale: [1, 1.2, 1],
            opacity: [0.3, 0.5, 0.3],
          }}
          transition={{ duration: 4, repeat: Infinity }}
        />
        <motion.div
          className="absolute bottom-20 right-10 w-40 h-40 bg-rose-gold/10 rounded-full blur-3xl"
          animate={{
            scale: [1, 1.3, 1],
            opacity: [0.3, 0.6, 0.3],
          }}
          transition={{ duration: 5, repeat: Infinity, delay: 1 }}
        />
      </div>

      {/* Content */}
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8 }}
        className="text-center z-10 max-w-2xl"
      >
        {/* Logo/Brand */}
        <motion.div
          className="mb-8"
          animate={{ rotate: [0, 5, -5, 0] }}
          transition={{ duration: 6, repeat: Infinity }}
        >
          <Sparkles className="w-20 h-20 mx-auto text-gold-500 mb-4" />
        </motion.div>

        {/* Title */}
        <h1 className="text-6xl md:text-7xl font-playfair font-bold text-glow mb-4">
          Luxury Dining
        </h1>
        <p className="text-xl md:text-2xl text-gray-300 mb-12">
          Experience Dubai-class service at your table
        </p>

        {/* NFC Scan Button */}
        {!scanning && !showManualEntry && (
          <motion.button
            onClick={startNFCScan}
            className="glass-strong px-12 py-6 rounded-2xl font-semibold text-lg
                     flex items-center gap-3 mx-auto btn-luxury hover:scale-105 transition-transform"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Wifi className="w-6 h-6" />
            Tap Your Phone to Table Scanner
          </motion.button>
        )}

        {/* Scanning Animation */}
        {scanning && (
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            className="glass-strong p-12 rounded-3xl"
          >
            <motion.div
              className="w-32 h-32 mx-auto mb-6 border-4 border-gold-500 border-t-transparent rounded-full"
              animate={{ rotate: 360 }}
              transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
            />
            <p className="text-2xl font-semibold mb-2">Scanning NFC Tag...</p>
            <p className="text-gray-400">Hold your phone near the table scanner</p>
            <button
              onClick={() => setScanning(false)}
              className="mt-6 text-sm text-gray-500 hover:text-white transition"
            >
              Cancel
            </button>
          </motion.div>
        )}

        {/* Error Message */}
        {error && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="mt-6 glass bg-red-500/20 border-red-500/50 px-6 py-4 rounded-xl"
          >
            <p className="text-red-200">{error}</p>
          </motion.div>
        )}

        {/* Manual Entry Option */}
        {!scanning && (
          <div className="mt-12">
            {!showManualEntry ? (
              <button
                onClick={() => setShowManualEntry(true)}
                className="text-gray-400 hover:text-white transition text-sm flex items-center gap-2 mx-auto"
              >
                <ChevronDown className="w-4 h-4" />
                Enter Table Number Manually
              </button>
            ) : (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                className="glass p-6 rounded-xl max-w-sm mx-auto"
              >
                <input
                  type="number"
                  value={tableNumber}
                  onChange={(e) => setTableNumber(e.target.value)}
                  placeholder="Table Number"
                  className="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-center text-xl
                           focus:outline-none focus:border-gold-500 transition mb-4"
                />
                <button
                  onClick={handleManualEntry}
                  disabled={!tableNumber}
                  className="w-full gold-gradient text-luxury-dark font-semibold py-3 rounded-lg
                           hover:opacity-90 transition disabled:opacity-50"
                >
                  Continue
                </button>
              </motion.div>
            )}
          </div>
        )}

        {/* Info Text */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1 }}
          className="mt-16 text-sm text-gray-500"
        >
          Powered by NFC Technology • Secure & Fast
        </motion.p>
      </motion.div>
    </div>
  );
};

export default NFCScanPage;
