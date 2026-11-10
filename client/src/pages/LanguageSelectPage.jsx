// Language Selection Page - First screen for customer
// Dubai-class luxury language selector

import React from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Globe, ChevronRight, Sparkles } from 'lucide-react';

const LanguageSelectPage = () => {
  const navigate = useNavigate();

  const languages = [
    {
      code: 'uz',
      name: "O'zbek",
      nativeName: "O'zbekcha",
      flag: '🇺🇿',
      greeting: 'Xush kelibsiz!',
    },
    {
      code: 'ru',
      name: 'Русский',
      nativeName: 'Русский язык',
      flag: '🇷🇺',
      greeting: 'Добро пожаловать!',
    },
    {
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
      greeting: 'Welcome!',
    },
  ];

  const selectLanguage = (languageCode) => {
    // Save language to localStorage
    localStorage.setItem('selectedLanguage', languageCode);
    // Navigate to NFC scan page
    navigate('/nfc-scan');
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      {/* Background decorations */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-10 w-72 h-72 bg-gold-500/10 rounded-full blur-3xl" />
        <div className="absolute bottom-20 right-10 w-96 h-96 bg-rose-gold/10 rounded-full blur-3xl" />
      </div>

      {/* Main content */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8 }}
        className="relative z-10 w-full max-w-2xl"
      >
        {/* Logo / Brand */}
        <div className="text-center mb-12">
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.2, duration: 0.6 }}
            className="inline-flex items-center justify-center w-24 h-24 rounded-full gold-gradient mb-6"
          >
            <Globe className="w-12 h-12 text-luxury-dark" />
          </motion.div>

          <motion.h1
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.4 }}
            className="text-4xl md:text-5xl font-playfair font-bold text-glow mb-3"
          >
            Luxury Restaurant
          </motion.h1>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.6 }}
            className="text-gray-400 text-lg flex items-center justify-center gap-2"
          >
            <Sparkles className="w-5 h-5 text-gold-500" />
            Select Your Language
            <Sparkles className="w-5 h-5 text-gold-500" />
          </motion.p>
        </div>

        {/* Language cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 md:gap-6">
          {languages.map((lang, index) => (
            <motion.button
              key={lang.code}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.8 + index * 0.1 }}
              onClick={() => selectLanguage(lang.code)}
              className="glass-strong rounded-2xl p-8 hover:scale-105 transition-all duration-300 cursor-pointer group relative overflow-hidden"
              whileHover={{ y: -5 }}
              whileTap={{ scale: 0.98 }}
            >
              {/* Hover gradient effect */}
              <div className="absolute inset-0 gold-gradient opacity-0 group-hover:opacity-10 transition-opacity duration-300" />

              {/* Content */}
              <div className="relative z-10">
                <div className="text-6xl mb-4">{lang.flag}</div>
                <h3 className="text-2xl font-bold mb-2 group-hover:text-gold-500 transition-colors">
                  {lang.nativeName}
                </h3>
                <p className="text-sm text-gray-400 mb-4">{lang.name}</p>
                <p className="text-lg font-playfair text-gold-500 mb-4">{lang.greeting}</p>

                {/* Arrow icon */}
                <div className="flex justify-center">
                  <div className="w-10 h-10 rounded-full bg-gold-500/20 flex items-center justify-center group-hover:bg-gold-500 transition-colors">
                    <ChevronRight className="w-5 h-5 text-gold-500 group-hover:text-luxury-dark transition-colors" />
                  </div>
                </div>
              </div>
            </motion.button>
          ))}
        </div>

        {/* Footer text */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.2 }}
          className="text-center text-gray-500 text-sm mt-8"
        >
          You can change language anytime from the menu
        </motion.p>
      </motion.div>
    </div>
  );
};

export default LanguageSelectPage;
