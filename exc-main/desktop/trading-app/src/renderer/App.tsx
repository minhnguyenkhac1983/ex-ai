import React, { useEffect, useState } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import styled from 'styled-components';

import Sidebar from '../components/Sidebar/Sidebar';
import Header from '../components/Header/Header';
import Dashboard from '../pages/Dashboard/Dashboard';
import Trading from '../pages/Trading/Trading';
import Portfolio from '../pages/Portfolio/Portfolio';
import Orders from '../pages/Orders/Orders';
import Settings from '../pages/Settings/Settings';
import { useAppDispatch, useAppSelector } from '../hooks/redux';
import { authSlice } from '../store/slices/authSlice';
import LoginModal from '../components/Auth/LoginModal';
import NotificationCenter from '../components/Notifications/NotificationCenter';
import LoadingSpinner from '../components/UI/LoadingSpinner';

const AppContainer = styled.div`
  display: flex;
  height: 100vh;
  overflow: hidden;
`;

const MainContent = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
`;

const ContentArea = styled.main`
  flex: 1;
  overflow: auto;
  background: ${props => props.theme.colors.background.primary};
`;

const App: React.FC = () => {
  const dispatch = useAppDispatch();
  const { isAuthenticated, loading } = useAppSelector(state => state.auth);
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    // Initialize the app
    const initializeApp = async () => {
      try {
        // Check for stored authentication
        const storedAuth = localStorage.getItem('auth_token');
        if (storedAuth) {
          // Validate token and restore session
          dispatch(authSlice.actions.setToken(storedAuth));
        }
        
        // Get app version
        const version = await window.electronAPI.getVersion();
        console.log('App version:', version);
        
        // Set up menu event listeners
        const cleanupNewOrder = window.electronAPI.onMenuNewOrder(() => {
          // Handle new order from menu
          console.log('New order requested from menu');
        });
        
        const cleanupQuickBuy = window.electronAPI.onMenuQuickBuy(() => {
          // Handle quick buy from menu
          console.log('Quick buy requested from menu');
        });
        
        const cleanupQuickSell = window.electronAPI.onMenuQuickSell(() => {
          // Handle quick sell from menu
          console.log('Quick sell requested from menu');
        });
        
        const cleanupCancelAll = window.electronAPI.onMenuCancelAllOrders(() => {
          // Handle cancel all orders from menu
          console.log('Cancel all orders requested from menu');
        });
        
        const cleanupExport = window.electronAPI.onMenuExportPortfolio((filePath: string) => {
          // Handle export portfolio from menu
          console.log('Export portfolio requested:', filePath);
        });
        
        const cleanupProgress = window.electronAPI.onDownloadProgress((progress: any) => {
          // Handle download progress for app updates
          console.log('Download progress:', progress);
        });
        
        setIsInitialized(true);
        
        // Cleanup function
        return () => {
          cleanupNewOrder();
          cleanupQuickBuy();
          cleanupQuickSell();
          cleanupCancelAll();
          cleanupExport();
          cleanupProgress();
        };
      } catch (error) {
        console.error('Failed to initialize app:', error);
        setIsInitialized(true);
      }
    };

    initializeApp();
  }, [dispatch]);

  // Show loading screen while initializing
  if (!isInitialized || loading) {
    return (
      <AppContainer>
        <LoadingSpinner />
      </AppContainer>
    );
  }

  // Show login modal if not authenticated
  if (!isAuthenticated) {
    return (
      <AppContainer>
        <LoginModal />
      </AppContainer>
    );
  }

  return (
    <AppContainer>
      <Sidebar />
      <MainContent>
        <Header />
        <ContentArea>
          <Routes>
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/trading" element={<Trading />} />
            <Route path="/trading/:symbol" element={<Trading />} />
            <Route path="/portfolio" element={<Portfolio />} />
            <Route path="/orders" element={<Orders />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="*" element={<Navigate to="/dashboard" replace />} />
          </Routes>
        </ContentArea>
      </MainContent>
      <NotificationCenter />
    </AppContainer>
  );
};

export default App;
