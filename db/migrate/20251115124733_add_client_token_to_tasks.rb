class AddClientTokenToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :client_token, :string
    add_index  :tasks, :client_token
  end
end
