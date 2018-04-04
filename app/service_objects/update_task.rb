class UpdateTask
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    @task.update(@params)
  end
end
