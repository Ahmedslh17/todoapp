# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# config/initializers/assets.rb
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")
Rails.application.config.assets.css_compressor = nil
