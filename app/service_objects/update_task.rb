class UpdateTask
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    check_permissions
    update_task
    notify_watchers
  end

  private

  def check_permissions
    raise CannotEditError unless @user.can_edit?(@task)
  end

  def update_task
    @task.update(@params)
  end

  def notify_watchers
    if @task.was_just_completed?
      Notifier.notify_watchers(@task)
    end
  end
end
