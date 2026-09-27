const THEME_KEY = 'kplus-theme'

export function getTheme() {
  try {
    return localStorage.getItem(THEME_KEY) === 'dark' ? 'dark' : 'light'
  } catch {
    return 'light'
  }
}

export function setThemeClass(theme) {
  document.documentElement.classList.toggle('dark', theme === 'dark')
}

export function applyTheme(theme) {
  const next = theme === 'dark' ? 'dark' : 'light'
  setThemeClass(next)
  try {
    localStorage.setItem(THEME_KEY, next)
  } catch {
    /* localStorage 不可用时忽略 */
  }
  return next
}

export function restoreTheme() {
  setThemeClass(getTheme())
}
