/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_PROJECT_VERSION: string
  readonly VITE_PROJECT_VERSION_API: string
  readonly VITE_PROJECT_VERSION_DATABASE: string
  readonly VITE_PROJECT_VERSION_FRONTEND: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
} 