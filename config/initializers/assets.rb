# Be sure to restart your server when you modify this file.

# Version des assets
Rails.application.config.assets.version = "1.0"

# Permet à Rails de trouver les fichiers dans app/assets/builds
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

# Désactive la compression CSS (car Tailwind gère déjà)
Rails.application.config.assets.css_compressor = nil

# Ajout du service worker dans la pipeline Rails
Rails.application.config.assets.precompile += %w[
  service-worker.js
  manifest.json
  icon.png
  icon-512.png
]
