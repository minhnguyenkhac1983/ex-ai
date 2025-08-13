import { contextBridge, ipcRenderer } from 'electron';

// Expose protected methods that allow the renderer process to use
// the ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electronAPI', {
  // App info
  getVersion: () => ipcRenderer.invoke('app-version'),
  
  // Dialog methods
  showMessageBox: (options: any) => ipcRenderer.invoke('show-message-box', options),
  showErrorBox: (title: string, content: string) => ipcRenderer.invoke('show-error-box', title, content),
  showSaveDialog: (options: any) => ipcRenderer.invoke('show-save-dialog', options),
  showOpenDialog: (options: any) => ipcRenderer.invoke('show-open-dialog', options),
  
  // Menu events
  onMenuNewOrder: (callback: () => void) => {
    ipcRenderer.on('menu-new-order', callback);
    return () => ipcRenderer.removeListener('menu-new-order', callback);
  },
  
  onMenuQuickBuy: (callback: () => void) => {
    ipcRenderer.on('menu-quick-buy', callback);
    return () => ipcRenderer.removeListener('menu-quick-buy', callback);
  },
  
  onMenuQuickSell: (callback: () => void) => {
    ipcRenderer.on('menu-quick-sell', callback);
    return () => ipcRenderer.removeListener('menu-quick-sell', callback);
  },
  
  onMenuCancelAllOrders: (callback: () => void) => {
    ipcRenderer.on('menu-cancel-all-orders', callback);
    return () => ipcRenderer.removeListener('menu-cancel-all-orders', callback);
  },
  
  onMenuExportPortfolio: (callback: (filePath: string) => void) => {
    ipcRenderer.on('menu-export-portfolio', (event, filePath) => callback(filePath));
    return () => ipcRenderer.removeListener('menu-export-portfolio', callback);
  },
  
  // Auto updater events
  onDownloadProgress: (callback: (progress: any) => void) => {
    ipcRenderer.on('download-progress', (event, progress) => callback(progress));
    return () => ipcRenderer.removeListener('download-progress', callback);
  },
  
  // System events
  onWindowClose: (callback: () => void) => {
    ipcRenderer.on('window-close', callback);
    return () => ipcRenderer.removeListener('window-close', callback);
  },
  
  // Platform info
  platform: process.platform,
  
  // Node.js APIs (carefully exposed)
  node: {
    process: {
      platform: process.platform,
      env: {
        NODE_ENV: process.env.NODE_ENV
      }
    }
  }
});

// Type definitions for the exposed API
declare global {
  interface Window {
    electronAPI: {
      getVersion: () => Promise<string>;
      showMessageBox: (options: any) => Promise<any>;
      showErrorBox: (title: string, content: string) => Promise<void>;
      showSaveDialog: (options: any) => Promise<any>;
      showOpenDialog: (options: any) => Promise<any>;
      onMenuNewOrder: (callback: () => void) => () => void;
      onMenuQuickBuy: (callback: () => void) => () => void;
      onMenuQuickSell: (callback: () => void) => () => void;
      onMenuCancelAllOrders: (callback: () => void) => () => void;
      onMenuExportPortfolio: (callback: (filePath: string) => void) => () => void;
      onDownloadProgress: (callback: (progress: any) => void) => () => void;
      onWindowClose: (callback: () => void) => () => void;
      platform: string;
      node: {
        process: {
          platform: string;
          env: {
            NODE_ENV?: string;
          };
        };
      };
    };
  }
}
