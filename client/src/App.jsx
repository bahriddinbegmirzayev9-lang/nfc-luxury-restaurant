import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import LanguageSelectPage from './pages/LanguageSelectPage';
import NFCScanPage from './pages/NFCScanPage';
import MenuPage from './pages/MenuPage';
import OrderPage from './pages/OrderPage';
import './index.css';

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen animated-gradient">
        <Routes>
          <Route path="/" element={<LanguageSelectPage />} />
          <Route path="/nfc-scan" element={<NFCScanPage />} />
          <Route path="/menu/:sessionToken" element={<MenuPage />} />
          <Route path="/orders/:sessionToken" element={<OrderPage />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
