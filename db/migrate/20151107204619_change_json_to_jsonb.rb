class ChangeJsonToJsonb < ActiveRecord::Migration
  def up
    remove_column :events, :actor
    remove_column :events, :object
    remove_column :events, :target
    add_column :events, :actor, :jsonb
    add_column :events, :object, :jsonb
    add_column :events, :target, :jsonb
  end

  def down
    remove_column :events, :actor
    remove_column :events, :object
    remove_column :events, :target
    add_column :events, :actor, :json
    add_column :events, :object, :json
    add_column :events, :target, :json
  end
end
