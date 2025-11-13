# db/migrate/XXXXXXXXXXXXXX_add_default_to_tasks_done.rb
class AddDefaultToTasksDone < ActiveRecord::Migration[8.0]
  def change
    # Valeur par défaut pour les nouvelles lignes
    change_column_default :tasks, :done, from: nil, to: false

    # Normaliser les anciennes lignes (si certaines ont done = NULL)
    execute "UPDATE tasks SET done = FALSE WHERE done IS NULL;"
  end
end
