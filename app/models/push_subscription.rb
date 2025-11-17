class PushSubscription < ApplicationRecord
  belongs_to :task, optional: true, primary_key: :client_token, foreign_key: :client_token

  validates :client_token, presence: true
  validates :endpoint, :p256dh_key, :auth_key, presence: true
end
