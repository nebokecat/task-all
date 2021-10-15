class TasksController < ApplicationController
  include Session
  before_action :set_task, only: %i[update destroy]

  def index
    @tasks = Task.search(params[:title], params[:status]).order("#{sort_column} #{sort_method}")
    render json: { tasks: @tasks }
  end

  def show
    @task = current_user.tasks
    if @task
      render json: { task: @task }
    else
      render json: { error: 'タスクが存在しません' }, status: :not_found
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: { task: @task }
    else
      render json: { errors: @task.errors }, status: :bad_request
    end
  end

  def update
    if @task.update(task_params)
      render json: { task: @task }
    else
      render json: { errors: @task.errors }, status: :bad_request
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :finished_at)
  end

  def sort_method
    %w[asc desc].include?(params[:sort_method]) ? params[:sort_method] : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort_column]) ? params[:sort_column] : 'created_at'
  end
end
