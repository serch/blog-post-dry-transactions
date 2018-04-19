class CheckPermissions
  def initialize(user:, task:)
    @user = user
    @task = task
  end

  def call
    raise CannotEditError unless @user.can_edit?(@task)
  end
end
