class UpdateTask
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    check_permissions
    update_task
    @task
  end

  private

  def check_permissions
    raise CannotEditError unless @user.can_edit?(@task)
  end

  def update_task
    @task.update(@params)
  end
end
