class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    base_scope =
      case params[:q]
      when "todo" then Task.todo
      when "done" then Task.done
      else Task.all
      end

    # 🔐 On ne voit que les tâches de ce navigateur / appareil
    @tasks = base_scope
               .for_client(current_client_token)
               .order(position: :asc, created_at: :desc)
  end

  def create
    @task = Task.new(task_params)
    # 🔑 on lie la tâche au client anonyme courant
    @task.client_token = current_client_token

    if @task.save
      redirect_to tasks_path, notice: "Tâche ajoutée."
    else
      @tasks = Task.for_client(current_client_token).order(position: :asc, created_at: :desc)
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :index, status: :unprocessable_entity
    end
  end

  def show
    # @task déjà chargé par set_task
  end

  def edit
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

  # PATCH /tasks/reorder
  def reorder
    ids = params[:ordered_ids] || []

    Task.transaction do
      ids.each_with_index do |id, index|
        # 🔐 on ne réordonne que les tâches de ce client
        Task.for_client(current_client_token)
            .where(id: id)
            .update_all(position: index + 1)
      end
    end

    head :ok
  end

  private

    def set_task
      # 🔐 très important : on ne peut charger qu’une tâche appartenant à ce client
      @task = Task.for_client(current_client_token).find(params[:id])
    end

    def task_params
      # on ne laisse pas le client toucher client_token depuis le formulaire
      params.require(:task).permit(:title, :done, :position, :reminder_at)
    end
end
