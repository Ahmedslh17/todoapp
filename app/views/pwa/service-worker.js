const CACHE_NAME = "todo-v2";
const ASSETS = [
  "/",
  "/icon.png",
  "/icon-512.png",
  "/manifest.json"
];

// INSTALL
self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

// ACTIVATE
self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) return caches.delete(key);
        })
      )
    )
  );
  self.clients.claim();
});

// FETCH
self.addEventListener("fetch", (event) => {
  const req = event.request;

  // On ne met PAS en cache : PATCH, POST, PUT, DELETE
  if (req.method !== "GET") {
    return event.respondWith(fetch(req));
  }

  // On ne met pas en cache les pages turbo rails
  if (req.headers.get("accept")?.includes("text/vnd.turbo-stream.html")) {
    return event.respondWith(fetch(req));
  }

  // HTML → Network First
  if (req.headers.get("accept")?.includes("text/html")) {
    return event.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
          return res;
        })
        .catch(() => caches.match(req))
    );
  }

  // Static Files → Cache First
  event.respondWith(
    caches.match(req).then((cacheRes) => {
      return cacheRes || fetch(req);
    })
  );
});
