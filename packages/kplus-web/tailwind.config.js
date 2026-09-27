/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'PingFang SC', 'Noto Sans SC', 'Microsoft YaHei', 'system-ui', 'sans-serif'],
        mono: ['Roboto Mono', 'JetBrains Mono', 'SF Mono', 'Consolas', 'monospace']
      },
      colors: {
        primary: {
          50: '#eef4ff',
          100: '#dce8ff',
          200: '#b9d1ff',
          300: '#8fb4ff',
          400: '#5c8fff',
          500: '#2962ff',
          600: '#1f4fd6',
          700: '#1a41ae',
          800: '#173587',
          900: '#142a66'
        },
        app: 'var(--app-bg)',
        ink: {
          DEFAULT: 'var(--c-ink)',
          secondary: 'var(--c-ink-secondary)',
          faint: 'var(--c-ink-faint)'
        },
        panel: {
          DEFAULT: 'var(--c-panel)',
          raised: 'var(--c-panel-raised)'
        },
        line: 'var(--c-line)',
        up: {
          DEFAULT: '#e0535b',
          dim: 'rgba(224, 83, 91, 0.12)'
        },
        down: {
          DEFAULT: '#2ba471',
          dim: 'rgba(43, 164, 113, 0.12)'
        },
        success: {
          50: '#e9f7f1',
          500: '#2ba471',
          600: '#23865e'
        },
        danger: {
          50: '#fcecec',
          500: '#e0535b',
          600: '#c2434a'
        },
        warning: {
          50: '#3a3123',
          500: '#d9a03f',
          600: '#b8852f'
        }
      },
      boxShadow: {
        card: '0 0 0 1px rgba(255, 255, 255, 0.08)',
        'card-hover': '0 0 0 1px rgba(41, 98, 255, 0.4)'
      }
    }
  },
  plugins: []
}
