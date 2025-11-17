class PushSubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    subscription = params[:subscription]
    cookies.signed[:push_subscription] = {
      value: subscription.to_json,
      expires: 1.year.from_now
    }
    head :ok
  end
end
