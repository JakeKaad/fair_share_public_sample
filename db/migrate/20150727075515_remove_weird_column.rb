class RemoveWeirdColumn < ActiveRecord::Migration
  def change
    remove_column :activities, :"#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition"
  end
end
