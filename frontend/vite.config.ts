import { defineConfig, loadEnv } from 'vite';
import path from 'path';

export default defineConfig(({ mode }) => {
  // Load env file from root directory
  const env = loadEnv(mode, process.cwd() + '/..', '');
  
  return {
    build: {
      outDir: path.resolve(__dirname, '../dist/frontend'),
      emptyOutDir: true
    },
    define: {
      // Define environment variables that should be available in the frontend
      'import.meta.env.VITE_PROJECT_VERSION': JSON.stringify(env.VITE_PROJECT_VERSION || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_API': JSON.stringify(env.VITE_PROJECT_VERSION_API || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_DATABASE': JSON.stringify(env.VITE_PROJECT_VERSION_DATABASE || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_FRONTEND': JSON.stringify(env.VITE_PROJECT_VERSION_FRONTEND || '6'),
      'import.meta.env.VITE_API_URL': JSON.stringify(env.VITE_API_URL || 'http://localhost:3000'),
    },
    server: {
      proxy: {
        '/api': {
          target: 'http://localhost:3000',
          changeOrigin: true,
        },
      },
    },
  };
}); 