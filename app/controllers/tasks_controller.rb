class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    @tasks = Task.order(created_at: :desc, id: :asc)
    render json: { tasks: @tasks }
  end

  def show
    render json: { task: @task }
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: { task: @task }
    else
      render json: { errors: @task.errors }
    end
  end

  def update
    if @task.update(task_params)
      render json: { task: @task }
    else
      render json: { errors: @task.errors }
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
