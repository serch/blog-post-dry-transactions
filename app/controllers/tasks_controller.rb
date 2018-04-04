class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################################################################
  # BEGIN Update methods
  ################################################################################

  def update
    if params[:commit] == 'regular_update'
      regular_update
    elsif params[:commit] == 'service_object_update'
      service_object_update
    elsif params[:commit] == 'dry_transaction_update'
      dry_transaction_update
    end
  end

  def regular_update
    current_user = User.new
    @task = Task.find(params[:id])
    task_params = params.require(:task).permit(:title, :description, :done)

    unless current_user.can_edit?(@task)
      redirect_to tasks_url, alert: 'You can only edit your tasks.'
      return
    end

    if @task.update(task_params)
      Notifier.notify_watchers(@task) if @task.was_just_completed?
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def service_object_update
    current_user = User.new
    @task = Task.find(params[:id])
    task_params = params.require(:task).permit(:title, :description, :done)

    update_task = UpdateTask.new(user: current_user, task: @task, params: task_params)

    begin
      update_task.call
      redirect_to @task, notice: 'Task was successfully updated.'
    rescue CannotEditError => _exc
      redirect_to tasks_url, alert: 'You can only edit your tasks.'
    rescue StandardError => _exc
      render :edit
    end
  end

  def dry_transaction_update
    current_user = User.new
    @task = Task.find(params[:id])
    task_params = params.require(:task).permit(:title, :description, :done)

    update_task = UpdateTaskTransaction.new
    update_task.call(
      user: current_user,
      task: @task,
      params: task_params
    ) do |tx|
      tx.success do |_value|
        redirect_to @task, notice: 'Task was successfully updated.'
      end

      tx.failure :validate do |_error|
        redirect_to tasks_url, alert: 'You can only edit your tasks.'
      end

      tx.failure do |_error|
        render :edit
      end
    end
  end

  ################################################################################
  # END Update methods
  ################################################################################

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :done)
    end
end
