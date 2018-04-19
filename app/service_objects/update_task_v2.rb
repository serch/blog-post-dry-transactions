class UpdateTaskV2
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    check_permissions
    update_task
  end

  private

  def check_permissions
    CheckPermissions.new(user: @user, task: @task).call
  end

  def update_task
    @task.update(@params)
  end
end
