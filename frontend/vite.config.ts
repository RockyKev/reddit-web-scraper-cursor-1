import { defineConfig, loadEnv } from 'vite';

export default defineConfig(({ mode }) => {
  // Load env file from root directory
  const env = loadEnv(mode, process.cwd() + '/..', '');
  
  return {
    define: {
      // Define environment variables that should be available in the frontend
      'import.meta.env.VITE_PROJECT_VERSION': JSON.stringify(env.VITE_PROJECT_VERSION || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_API': JSON.stringify(env.VITE_PROJECT_VERSION_API || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_DATABASE': JSON.stringify(env.VITE_PROJECT_VERSION_DATABASE || '6'),
      'import.meta.env.VITE_PROJECT_VERSION_FRONTEND': JSON.stringify(env.VITE_PROJECT_VERSION_FRONTEND || '6'),
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