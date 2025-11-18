class PushSubscription < ApplicationRecord
  belongs_to :task, optional: true

  def to_webpush_format
    {
      endpoint: endpoint,
      keys: {
        p256dh: p256dh_key,
        auth: auth_key
      }
    }
  end
end
