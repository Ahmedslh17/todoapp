require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled for production.
  config.consider_all_requests_local = false

  # Cache static assets.
  config.action_controller.perform_caching = true

  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # Uploaded files
  config.active_storage.service = :local

  # Logging
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.silence_healthcheck_path = "/up"

  # Deprecations
  config.active_support.report_deprecations = false

  # Mailer URL default
  config.action_mailer.default_url_options = { host: "todoapp-8ww4.onrender.com" }

  # I18n
  config.i18n.fallbacks = true

  # Don't dump schema
  config.active_record.dump_schema_after_migration = false

  config.active_record.attributes_for_inspect = [:id]

  # -------------------------------
  # 🔥 CONFIG NOTIFICATIONS PUSH
  # -------------------------------
  config.x.vapid_public_key  = ENV["VAPID_PUBLIC_KEY"]
  config.x.vapid_private_key = ENV["VAPID_PRIVATE_KEY"]
  config.x.vapid_contact     = ENV["VAPID_CONTACT"]
end
