import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { defineConfig, loadEnv } from 'vite'
import autoImport from 'unplugin-auto-import/vite'
import IconsResolver from 'unplugin-icons/resolver'
import vue from '@vitejs/plugin-vue'
import zipPack from 'vite-plugin-zip-pack'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
  const env = loadEnv(mode, resolve(__dirname, './'), '')
  return {
    base: '/',
    plugins: [
      vue(),
      autoImport({
        dts: './assets/types/auto-imports.d.ts',
        eslintrc: {
          enabled: true,
          filepath: './assets/types/.eslintrc-auto-import.json',
          globalsPropValue: true
        },
        imports: ['vue', 'vue-router'],
        resolvers: [
          IconsResolver({
            prefix: 'Icon'
          })
        ]
      }),
      zipPack({outDir: '../../dist-zip', outFileName: 'kplus-web.zip'})
    ],
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url)),
        '@c': fileURLToPath(new URL('./src/components', import.meta.url)),
        '@d': fileURLToPath(new URL('./src/data', import.meta.url)),
        '@r': fileURLToPath(new URL('./src/router', import.meta.url)),
        '@s': fileURLToPath(new URL('./src/stores', import.meta.url)),
        '@u': fileURLToPath(new URL('./src/utils', import.meta.url))
      },
      extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue']
    },
    server: {
      port: 80,
      proxy:  {
        '/api': {
          target: env.VITE_APP_API_BASE,
          changeOrigin: true
        }
      }
    },
    build: {
      terserOptions: {
        compress: {
          drop_console: true,
          drop_debugger: true
        }
      },
      rollupOptions: {
        output: {
          assetFileNames: 'assets/[ext]/[name] - [hash][extname]'
        }
      }
    }
  }
})
