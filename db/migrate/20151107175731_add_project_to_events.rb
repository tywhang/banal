class AddProjectToEvents < ActiveRecord::Migration
  def change
    add_column :events, :project_id, :integer, null: false
  end
end
