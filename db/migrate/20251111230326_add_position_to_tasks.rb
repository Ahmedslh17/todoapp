class AddPositionToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :position, :integer
  end
end
