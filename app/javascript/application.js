import { setupInstallButton, registerSW } from "./pwa";
import { setupReorder } from "./reorder";
import "@hotwired/turbo-rails"
import "tasks"
import "controllers"
function onReady(fn) {
  if (document.readyState !== "loading") fn();
  else document.addEventListener("DOMContentLoaded", fn);
}

function boot() {
  try {
    setupInstallButton();
    registerSW("/service-worker");
    setupReorder();
    console.log("[todoapp] boot OK");
  } catch (e) {
    console.error("[todoapp] boot error:", e);
  }
}

onReady(boot);
document.addEventListener("turbo:load", boot);
window.addEventListener("load", boot);
