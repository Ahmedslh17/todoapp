import Sortable from "sortablejs";

export function setupReorder() {
  const el = document.getElementById("taskList");
  if (!el) return;

  new Sortable(el, {
    animation: 150,
    handle: ".drag",
    ghostClass: "opacity-50",
    onEnd() {
      const ids = Array.from(el.children).map((item) => item.dataset.id);
      fetch("/tasks/reorder", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ ordered_ids: ids })
      }).catch(() => {});
    },
  });
}
