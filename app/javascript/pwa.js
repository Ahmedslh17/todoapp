// app/javascript/pwa.js
export function registerSW(path) {
  if ("serviceWorker" in navigator) {
    window.addEventListener("load", () => {
      navigator.serviceWorker.register(path);
    });
  }
}

export function setupInstallButton() {
  let deferredPrompt;
  const installBtn = document.getElementById("installBtn");

  window.addEventListener("beforeinstallprompt", (e) => {
    e.preventDefault();
    deferredPrompt = e;
    installBtn?.classList.remove("hidden");
  });

  installBtn?.addEventListener("click", async () => {
    if (!deferredPrompt) return;
    deferredPrompt.prompt();
    await deferredPrompt.userChoice;
    deferredPrompt = null;
    installBtn.classList.add("hidden");
  });

  window.addEventListener("appinstalled", () =>
    installBtn?.classList.add("hidden")
  );
}
