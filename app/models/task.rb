class Task < ApplicationRecord
  # ===== Validations =====
  validates :title, presence: true, length: { maximum: 120 }
  validates :client_token, presence: true

  # ===== Associations =====
  # On relie la subscription via client_token (pas task_id)
  has_one :push_subscription,
          foreign_key: :client_token,
          primary_key: :client_token,
          dependent: :destroy

  # ===== Scopes =====
  scope :for_client, ->(token) { where(client_token: token) }
  scope :done,       -> { where(done: true) }
  scope :todo,       -> { where(done: false) }

  # ===== Callbacks =====
  before_create :set_default_position
  after_update  :send_reminder_if_needed

  # ===== Méthodes publiques =====

  # Utilisée par PushNotificationJob
  # → retourne la structure attendue par webpush
  def client_subscription_json
    return nil unless push_subscription

    {
      "endpoint" => push_subscription.endpoint,
      "keys" => {
        "p256dh" => push_subscription.p256dh_key,
        "auth"   => push_subscription.auth_key
      }
    }
  end

  private

  def set_default_position
    self.position ||= (Task.maximum(:position) || 0) + 1
  end

  def send_reminder_if_needed
    return unless reminder_at.present?
    return unless saved_change_to_reminder_at?
    return if reminder_at < Time.current

    PushNotificationJob.set(wait_until: reminder_at).perform_later(self.id)
  end
end
