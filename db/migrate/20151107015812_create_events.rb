class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :actor
      t.string :verb
      t.json :object
      t.json :target
      
      t.datetime :created_at, null: false
    end
  end
end
