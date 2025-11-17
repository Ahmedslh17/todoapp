# app/services/webpush_service.rb
require "webpush"

class WebpushService
  def self.send_notification(subscription_json, title:, body:)
    subscription = JSON.parse(subscription_json)

    Webpush.payload_send(
      message: { title: title, body: body }.to_json,
      endpoint: subscription["endpoint"],
      p256dh: subscription["keys"]["p256dh"],
      auth: subscription["keys"]["auth"],
      vapid: {
        subject: Rails.configuration.x.vapid_contact,
        public_key: Rails.configuration.x.vapid_public_key,
        private_key: Rails.configuration.x.vapid_private_key
      }
    )
  rescue => e
    Rails.logger.error("WebPush ERROR: #{e.message}")
  end
end
