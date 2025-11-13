// app/javascript/tasks.js

// --- Utils ---
function readReminders() {
  try { return JSON.parse(localStorage.getItem('reminders') || '{}'); }
  catch { return {}; }
}

function writeReminders(map) {
  localStorage.setItem('reminders', JSON.stringify(map));
}

function showNotification(title) {
  if (!('Notification' in window)) return;
  const opts = {
    body: title,
    icon: '/icon.png',
    tag: 'todo-reminder-' + title
  };

  try {
    if (navigator.serviceWorker) {
      navigator.serviceWorker.ready.then(reg => {
        reg.showNotification('Rappel To-Do', opts);
      });
    } else {
      new Notification('Rappel To-Do', opts);
    }
  } catch (e) {
    console.warn('Notification error:', e);
  }
}

function ensureNotifPermission() {
  if (!('Notification' in window)) return Promise.reject('no-support');
  if (Notification.permission === 'granted') return Promise.resolve('granted');
  if (Notification.permission === 'denied') return Promise.reject('denied');
  return Notification.requestPermission();
}

function scheduleTimeout(taskId, whenMs, title, onFire) {
  const delay = whenMs - Date.now();
  if (delay <= 0) return null;
  return setTimeout(() => onFire(taskId, title), delay);
}

const reminderTimers = {}; // taskId -> timeoutId

function rearmRemindersOnLoad() {
  const map = readReminders();
  Object.entries(map).forEach(([taskId, obj]) => {
    const when  = obj.at;
    const title = obj.title;
    if (reminderTimers[taskId]) clearTimeout(reminderTimers[taskId]);

    reminderTimers[taskId] = scheduleTimeout(taskId, when, title, (id, t) => {
      showNotification(t);
      const map2 = readReminders();
      delete map2[id];
      writeReminders(map2);
      delete reminderTimers[id];
    });
  });
}

// --- Rappels : clic sur 🔔 ---
function enableReminderUI() {
  document.addEventListener('click', async (e) => {
    const btn = e.target.closest('.remind-btn');
    if (!btn) return; // ignore les autres clics

    const taskId = btn.dataset.id;
    const title  = btn.dataset.title || 'Rappel';

    // 1) Demander la permission de notification si besoin
    try {
      const perm = await ensureNotifPermission();
      if (perm !== 'granted') {
        alert("Les notifications sont bloquées dans ton navigateur.");
        return;
      }
    } catch {
      alert("Ton navigateur ne supporte pas les notifications.");
      return;
    }

    // 2) Demander l’heure à l’utilisateur (HH:MM)
    const input = prompt(
      `À quelle heure veux-tu le rappel pour :\n"${title}" ?\n\nFormat : HH:MM (ex: 20:30)`,
      "20:00"
    );

    if (!input) return; // annulé

    const match = /^([01]\d|2[0-3]):([0-5]\d)$/.exec(input.trim());
    if (!match) {
      alert("Heure invalide. Utilise le format HH:MM (ex: 08:30, 19:45).");
      return;
    }

    const hh = parseInt(match[1], 10);
    const mm = parseInt(match[2], 10);

    // 3) Construire une date : aujourd’hui à HH:MM, ou demain si déjà passé
    const target = new Date();
    target.setSeconds(0, 0);
    target.setHours(hh, mm, 0, 0);
    if (target.getTime() <= Date.now()) {
      target.setDate(target.getDate() + 1); // demain
    }

    // 4) Sauvegarder en localStorage
    const map = readReminders();
    map[taskId] = { at: target.getTime(), title };
    writeReminders(map);

    // 5) (re)programmer le timer
    if (reminderTimers[taskId]) clearTimeout(reminderTimers[taskId]);

    reminderTimers[taskId] = scheduleTimeout(taskId, target.getTime(), title, (id, t) => {
      showNotification(t);
      const map2 = readReminders();
      delete map2[id];
      writeReminders(map2);
      delete reminderTimers[id];
    });

    // 6) Petit feedback visuel sur la ligne
    const row = document.querySelector(`.task-row[data-id="${taskId}"]`);
    if (row) {
      row.classList.add('ring-1', 'ring-emerald-200', 'bg-emerald-50/40');
      setTimeout(() => row.classList.remove('ring-1', 'ring-emerald-200', 'bg-emerald-50/40'), 500);
    }

    alert(`Rappel programmé pour ${input} ✅`);
  });
}

function initAll() {
  enableReminderUI();
  rearmRemindersOnLoad();
}

document.addEventListener('turbo:load', initAll);
document.addEventListener('DOMContentLoaded', initAll);
