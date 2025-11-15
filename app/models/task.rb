class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 120 }

  # 🔐 Associer chaque tâche à un identifiant de navigateur
  validates :client_token, presence: true

  # Scopes
  scope :for_client, ->(token) { where(client_token: token) }
  scope :done,       -> { where(done: true) }
  scope :todo,       -> { where(done: false) }

  before_create :set_default_position

  private

  def set_default_position
    self.position ||= (Task.maximum(:position) || 0) + 1
  end
end
