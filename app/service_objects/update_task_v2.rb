class UpdateTaskV2
  def initialize(user:, task:, params:, permission_checker: nil)
    @user = user
    @task = task
    @params = params
    @permission_checker = permission_checker || CheckPermissions.new(user: @user, task: @task)
  end

  def call
    check_permissions
    update_task
    @task
  end

  private

  def check_permissions
    @permission_checker.call
  end

  def update_task
    @task.update(@params)
  end
end
