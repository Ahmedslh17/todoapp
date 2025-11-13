// app/javascript/theme.js

export function initTheme() {
  try {
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && prefersDark)) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  } catch (e) {}
}

export function setupThemeToggle() {
  const btn = document.getElementById('themeToggle');
  if (!btn) return;
  btn.addEventListener('click', () => {
    const d = document.documentElement.classList;
    d.toggle('dark');
    localStorage.theme = d.contains('dark') ? 'dark' : 'light';
  });
}
