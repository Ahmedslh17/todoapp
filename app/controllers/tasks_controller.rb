class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    scope = case params[:q]
            when "todo" then Task.todo
            when "done" then Task.done
            else Task.all
            end
    @tasks = scope.order(position: :asc, created_at: :desc)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Tâche ajoutée."
    else
      @tasks = Task.order(position: :asc, created_at: :desc)
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :index, status: :unprocessable_entity
    end
  end

  def show
    # @task déjà chargé par set_task
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Tâche mise à jour."
    else
      redirect_to tasks_path, alert: @task.errors.full_messages.to_sentence
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Tâche supprimée."
  end

  def reorder
    ids = params[:ordered_ids] || []
    Task.transaction do
      ids.each_with_index do |id, index|
        Task.where(id: id).update_all(position: index + 1)
      end
    end
    head :ok
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :done, :position, :reminder_at)
    end
end
