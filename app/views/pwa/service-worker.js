const CACHE_NAME = "todo-v2";

// 🔐 Clé publique VAPID envoyée par Rails
const VAPID_PUBLIC_KEY = "<%= Rails.configuration.x.vapid_public_key %>";

// Fichiers à mettre en cache
const ASSETS = [
  "/",
  "/icon.png",
  "/icon-512.png",
  "/manifest.json"
];

// INSTALL
self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

// ACTIVATE
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.map((k) => (k !== CACHE_NAME ? caches.delete(k) : null)))
    )
  );
  self.clients.claim();
});

// FETCH
self.addEventListener("fetch", (event) => {
  const req = event.request;

  if (req.method !== "GET") return event.respondWith(fetch(req));

  if (req.headers.get("accept")?.includes("text/vnd.turbo-stream.html"))
    return event.respondWith(fetch(req));

  if (req.headers.get("accept")?.includes("text/html")) {
    return event.respondWith(
      fetch(req)
        .then((res) => {
          caches.open(CACHE_NAME).then((cache) => cache.put(req, res.clone()));
          return res;
        })
        .catch(() => caches.match(req))
    );
  }

  event.respondWith(
    caches.match(req).then((cached) => cached || fetch(req))
  );
});

// 🔔 Push Notification
self.addEventListener("push", (event) => {
  const data = event.data ? event.data.json() : {};

  event.waitUntil(
    self.registration.showNotification(data.title || "Rappel", {
      body: data.body || "Tu as une tâche à faire !",
      icon: "/icon.png",
      badge: "/icon.png"
    })
  );
});
