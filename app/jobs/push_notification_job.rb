class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task

    subscription = task.push_subscription
    return unless subscription

    WebpushService.send_notification(
      subscription.to_webpush_format,
      title: "🔔 Rappel : #{task.title}",
      body: "Tu as une tâche prévue maintenant !"
    )
  end
end
