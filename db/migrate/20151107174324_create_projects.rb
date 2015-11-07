class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :projects, :token
  end
end
