class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 120 }

  # 🔐 Chaque tâche est liée à un navigateur anonyme
  validates :client_token, presence: true

  has_one :push_subscription, primary_key: :client_token, foreign_key: :client_token

  # Scopes
  scope :for_client, ->(token) { where(client_token: token) }
  scope :done,       -> { where(done: true) }
  scope :todo,       -> { where(done: false) }

  before_create :set_default_position
  after_update  :send_reminder_if_needed

  private

  def set_default_position
    self.position ||= (Task.maximum(:position) || 0) + 1
  end

  # 🔔 Quand on change reminder_at → planifier un job
  def send_reminder_if_needed
    return unless reminder_at.present?
    return unless saved_change_to_reminder_at?
    return if reminder_at < Time.current

    PushNotificationJob.set(wait_until: reminder_at).perform_later(self.id)
  end
end
