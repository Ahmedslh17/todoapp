class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task

    sub_json = task.client_subscription_json
    return unless sub_json

    WebpushService.send_notification(
      sub_json,
      title: "🔔 Rappel : #{task.title}",
      body: "Tu as une tâche prévue maintenant !"
    )
  end
end
