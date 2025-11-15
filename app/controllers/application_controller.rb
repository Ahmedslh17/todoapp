class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # On expose la méthode au views si besoin
  helper_method :current_client_token

  private

  # 🔑 Identifiant anonyme unique par navigateur (stocké dans un cookie signé)
  # Chaque appareil/navigateur a son propre token, donc sa propre liste de tâches.
  def current_client_token
    cookies.signed[:todo_client_token] ||= SecureRandom.uuid
  end
end
