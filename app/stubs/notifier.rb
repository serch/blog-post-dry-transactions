class Notifier
  def self.notify_watchers(task)
    Rails.logger.info("Task #{task.title} has just been completed.")
  end
end
