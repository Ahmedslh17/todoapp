require "webpush"

VAPID_PUBLIC_KEY = ENV["VAPID_PUBLIC_KEY"]
VAPID_PRIVATE_KEY = ENV["VAPID_PRIVATE_KEY"]

WEBPUSH_PARAMS = {
  vapid: {
    subject: "studiokreatix@gmail.com",
    public_key: VAPID_PUBLIC_KEY,
    private_key: VAPID_PRIVATE_KEY
  }
}
