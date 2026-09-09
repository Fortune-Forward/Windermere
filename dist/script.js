const chapters = [...document.querySelectorAll('main > section[data-label]')];
const chapterNumber = document.querySelector('#chapter-number');
const chapterLabel = document.querySelector('#chapter-label');
const observer = new IntersectionObserver(entries => {
  for (const entry of entries) if (entry.isIntersecting) {
    chapterNumber.textContent = String(chapters.indexOf(entry.target) + 1).padStart(2, '0');
    chapterLabel.textContent = entry.target.dataset.label;
  }
}, { rootMargin: '-30% 0px -55% 0px', threshold: 0 });
chapters.forEach(section => observer.observe(section));
const dialog = document.querySelector('#plan-dialog');
const plan = document.querySelector('#zoom-plan');
let zoom = 1;
function setZoom(next) { zoom = Math.max(1, Math.min(3, next)); plan.style.width = `${zoom * 100}%`; document.querySelector('#zoom-out').disabled = zoom === 1; document.querySelector('#zoom-in').disabled = zoom === 3; }
document.querySelector('.plan-open').addEventListener('click', () => { setZoom(1); dialog.showModal(); document.body.style.overflow = 'hidden'; });
document.querySelector('#close-plan').addEventListener('click', () => dialog.close());
dialog.addEventListener('close', () => { document.body.style.overflow = ''; });
dialog.addEventListener('click', event => { if (event.target === dialog) { const rect = dialog.getBoundingClientRect(); if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) dialog.close(); } });
document.querySelector('#zoom-in').addEventListener('click', () => setZoom(zoom + 0.5));
document.querySelector('#zoom-out').addEventListener('click', () => setZoom(zoom - 0.5));
document.querySelector('#zoom-reset').addEventListener('click', () => setZoom(1));
